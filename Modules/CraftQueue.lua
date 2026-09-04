-- ProfessionPilot Modules/CraftQueue.lua
-- One-click "craft everything": works through the current step's material
-- tree bottom-up, crafting every MISSING intermediate. The step's own
-- recipe stays on the existing main-window craft button.
--
-- Event-driven loop, no OnUpdate: craft ONE combine, wait for
-- UNIT_SPELLCAST_SUCCEEDED (3.3.5a args: unit, spellName, rank -- this
-- client has NO spellId argument, so we match the localized name from
-- GetSpellInfo), then wait for the next PP_SNAPSHOT (the recompute that
-- follows the bucketed BAG_UPDATE) and rebuild the queue from the fresh
-- snapshot.tree. Rebuilding after every combine keeps the counts honest
-- and handles multi-output recipes (numMade > 1) without local bookkeeping.
-- Craft-API professions (Enchanting) craft 1 per DoCraft anyway, so the
-- one-combine-at-a-time loop paces both APIs identically.

local PP = _G.ProfessionPilot
local L = PP.L
local CraftQueue = PP:NewModule("CraftQueue", "AceEvent-3.0", "AceTimer-3.0")

local MAX_COMBINES = 200   -- runaway guard per run
local SAFETY_DELAY = 0.5

-- phase: "idle" (may cast) -> "casting" (combine in flight) ->
-- "waiting" (success seen, waiting for the recomputed snapshot) -> "idle"
local running = false
local phase = "idle"
local currentSpellId, currentSpellName
local combines = 0
local castTimer, snapTimer
local castChecks = 0

local function isReady(spellId)
    local Crafter = PP:GetModule("Crafter", true)
    if not Crafter then return false end
    local state, available = Crafter:GetRecipeState(spellId)
    return state == "ready" and (available or 0) > 0
end

local function buildQueue()
    local snap = PP.snapshot
    return PP.Queue.BuildFromTree(snap and snap.tree or nil)
end

function CraftQueue:IsRunning()
    return running
end

function CraftQueue:Toggle()
    if running then
        self:Stop("QUEUE_STOPPED")
    else
        self:Start()
    end
end

function CraftQueue:Start()
    if running then return end
    if UnitAffectingCombat("player") then
        PP:Print(L["QUEUE_COMBAT"])
        return
    end
    local queue = buildQueue()
    if #queue == 0 then
        PP:Print(L["QUEUE_EMPTY"])
        return
    end

    -- Two-stage like every craft button in this addon: profession window
    -- closed -> open it (CastSpellByName works because Start runs from the
    -- button's hardware click); the next click starts the run. All queue
    -- entries belong to the active profession (profession.producers), so
    -- probing the first entry is enough.
    local Crafter = PP:GetModule("Crafter", true)
    if not Crafter then return end
    if Crafter:GetRecipeState(queue[1].recipeSpellId) == "closed" then
        Crafter:OpenProfession()
        return
    end

    running = true
    phase = "idle"
    combines = 0
    self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", "OnCastGone")
    self:RegisterEvent("UNIT_SPELLCAST_FAILED", "OnCastGone")
    self:RegisterEvent("TRADE_SKILL_CLOSE", "OnWindowClosed")
    self:RegisterEvent("CRAFT_CLOSE", "OnWindowClosed")
    self:RegisterEvent("PLAYER_REGEN_DISABLED", "OnCombat")
    self:RegisterMessage("PP_SNAPSHOT", "OnSnapshot")
    PP:Debug("CraftQueue: start,", #queue, "queue entries")
    self:SendMessage("PP_QUEUE_STATE")
    self:ProcessNext(queue)
end

function CraftQueue:Stop(reasonKey)
    if not running then return end
    running = false
    phase = "idle"
    currentSpellId, currentSpellName = nil, nil
    if castTimer then self:CancelTimer(castTimer, true); castTimer = nil end
    if snapTimer then self:CancelTimer(snapTimer, true); snapTimer = nil end
    self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    self:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED")
    self:UnregisterEvent("UNIT_SPELLCAST_FAILED")
    self:UnregisterEvent("TRADE_SKILL_CLOSE")
    self:UnregisterEvent("CRAFT_CLOSE")
    self:UnregisterEvent("PLAYER_REGEN_DISABLED")
    self:UnregisterMessage("PP_SNAPSHOT")
    if reasonKey == "QUEUE_LIMIT" then
        PP:Print(L["QUEUE_LIMIT"]:format(MAX_COMBINES))
    elseif reasonKey then
        PP:Print(L[reasonKey])
    end
    self:SendMessage("PP_QUEUE_STATE")
end

-- Issue exactly one combine for the first craftable queue entry.
-- `queue` is optional (Start passes the one it just built); every later
-- call rebuilds from the current snapshot.
function CraftQueue:ProcessNext(queue)
    if not running or phase ~= "idle" then return end
    if UnitAffectingCombat("player") then
        self:Stop("QUEUE_COMBAT")
        return
    end
    queue = queue or buildQueue()
    if #queue == 0 then
        self:Stop("QUEUE_DONE")
        return
    end
    if combines >= MAX_COMBINES then
        self:Stop("QUEUE_LIMIT")
        return
    end
    local entry = PP.Queue.NextCraftable(queue, isReady)
    if not entry then
        self:Stop("QUEUE_BLOCKED")
        return
    end

    local Crafter = PP:GetModule("Crafter", true)  -- exists: isReady passed
    currentSpellId = entry.recipeSpellId
    currentSpellName = GetSpellInfo(currentSpellId)
    phase = "casting"
    castChecks = 0
    combines = combines + 1
    PP:Debug("CraftQueue: combine", combines,
        currentSpellName or currentSpellId)
    Crafter:CraftRecipe(currentSpellId, 1)
    castTimer = self:ScheduleTimer("CastSafetyCheck", SAFETY_DELAY)
end

-- Safety net: CraftRecipe can be a silent no-op (recipe filtered out of
-- the list, reagents gone, window state changed between checks). If no
-- cast is visible and no success arrived after two checks (~1s, covers
-- normal latency), treat the run as blocked instead of hanging forever.
function CraftQueue:CastSafetyCheck()
    castTimer = nil
    if not running or phase ~= "casting" then return end
    if UnitCastingInfo and UnitCastingInfo("player") then
        castChecks = 0
        castTimer = self:ScheduleTimer("CastSafetyCheck", SAFETY_DELAY)
        return
    end
    castChecks = castChecks + 1
    if castChecks >= 2 then
        self:Stop("QUEUE_BLOCKED")
    else
        castTimer = self:ScheduleTimer("CastSafetyCheck", SAFETY_DELAY)
    end
end

function CraftQueue:UNIT_SPELLCAST_SUCCEEDED(_, unit, spellName)
    if not running or phase ~= "casting" then return end
    if unit ~= "player" or spellName ~= currentSpellName then return end
    phase = "waiting"
    if castTimer then self:CancelTimer(castTimer, true); castTimer = nil end
    -- MaterialTracker's bucketed BAG_UPDATE recompute normally lands within
    -- ~0.3s; the timer is the fallback if no snapshot arrives at all.
    snapTimer = self:ScheduleTimer("SnapshotSafety", SAFETY_DELAY)
end

function CraftQueue:OnSnapshot()
    if not running or phase ~= "waiting" then return end
    if snapTimer then self:CancelTimer(snapTimer, true); snapTimer = nil end
    phase = "idle"
    self:ProcessNext()
end

function CraftQueue:SnapshotSafety()
    snapTimer = nil
    if not running or phase ~= "waiting" then return end
    phase = "idle"
    self:ProcessNext()
end

function CraftQueue:OnCastGone(_, unit, spellName)
    if not running or phase ~= "casting" then return end
    if unit ~= "player" or spellName ~= currentSpellName then return end
    self:Stop("QUEUE_ABORTED")
end

function CraftQueue:OnWindowClosed()
    if running then
        self:Stop("QUEUE_CLOSED")
    end
end

function CraftQueue:OnCombat()
    if running then
        self:Stop("QUEUE_COMBAT")
    end
end
