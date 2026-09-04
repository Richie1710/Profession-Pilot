-- ProfessionPilot Modules/SkillStats.lua
-- Skill-up telemetry: counts the player's own crafts of guide recipes and
-- the skill points they yielded, persisted per character as
--   PP.db.char.stats[recipeSpellId] = { crafts = n, ups = n }.
-- Core/Stats.lua turns these observations into refined "remaining crafts"
-- estimates (guide numbers assume standard 1x rates; private servers vary).
--
-- Detection (3.3.5a): UNIT_SPELLCAST_SUCCEEDED delivers (unit, spellName,
-- rank) -- there is NO spellId argument on this client -- so casts are
-- matched through a name -> spellId map built with GetSpellInfo from the
-- active profession's step recipes (alternatives included) and refreshed
-- via PP_SNAPSHOT whenever the active profession changes.
--
-- Attribution heuristics -- deliberately simple, with known imperfections:
--  * A craft is counted at cast success; a SKILL_LINES_CHANGED within
--    ATTRIBUTION_WINDOW seconds attributes the observed delta (+1, +2, ...)
--    to that craft. SkillTracker handles the same event and updates
--    PP.state.skill -- handler order is not guaranteed -- so the delta is
--    measured against our own skill-line scan and the skill remembered at
--    cast time, never against PP.state.skill at event time.
--  * Batching: if the server delivers the skill update only after the NEXT
--    cast already succeeded, the whole delta lands on the newer pending
--    craft and any further batched delta is dropped (pending is cleared
--    after one attribution). Ups therefore undercount slightly on laggy
--    servers, which keeps refined estimates conservative.
--  * Rates are lifetime aggregates per recipe, not conditioned on the skill
--    at which each craft happened (orange vs yellow crafts pool together).
--  * Crafts at/past the recipe's own step window are ignored entirely:
--    skill never drops, so those can never skill up again and would poison
--    the rate with structural zeros (e.g. re-crafting intermediates later).

local PP = _G.ProfessionPilot
local SkillStats = PP:NewModule("SkillStats", "AceEvent-3.0")

local ATTRIBUTION_WINDOW = 5   -- seconds from cast success to skill event

local tracked = {}       -- [spellName] = recipeSpellId (active profession)
local windowMax = {}     -- [recipeSpellId] = maxSkill of the owning step
local trackedKey = false -- profession key the maps were built for
local pending = nil      -- { spellId, time, skill, profKey } of last craft

function SkillStats:OnEnable()
    self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    self:RegisterEvent("SKILL_LINES_CHANGED")
    self:RegisterMessage("PP_SNAPSHOT", "RefreshTracked")
    self:RefreshTracked()
end

-- Rebuild the name -> spellId map for the active profession. Runs on every
-- PP_SNAPSHOT but short-circuits while the profession is unchanged
-- (GetSpellInfo reads client DBCs, so names resolve reliably at any time).
function SkillStats:RefreshTracked()
    local key = PP.state.activeKey
    if key == trackedKey then return end
    trackedKey = key

    tracked, windowMax = {}, {}
    local prof = PP:GetActiveProfession()
    if not prof then return end

    local function add(spellId, maxSkill)
        local name = GetSpellInfo(spellId)
        if name then
            -- Same-name collisions (recipe ranks) are rare within one
            -- guide; last one wins, both share the step window anyway.
            tracked[name] = spellId
            windowMax[spellId] = maxSkill
        end
    end

    for i = 1, #prof.steps do
        local step = prof.steps[i]
        add(step.recipeSpellId, step.maxSkill)
        if step.alternatives then
            for j = 1, #step.alternatives do
                add(step.alternatives[j].recipeSpellId, step.maxSkill)
            end
        end
    end
end

-- Lazy per-character storage. AceDB persists keys written into db.char even
-- without a defaults entry; adding `stats = {}` to the Database.lua char
-- defaults is still the cleaner declared shape (see wiring notes).
local function statsFor(spellId)
    local char = PP.db and PP.db.char
    if not char then return nil end
    local stats = char.stats
    if not stats then
        stats = {}
        char.stats = stats
    end
    local s = stats[spellId]
    if not s then
        s = { crafts = 0, ups = 0 }
        stats[spellId] = s
    end
    return s
end

function SkillStats:UNIT_SPELLCAST_SUCCEEDED(_, unit, spellName)
    if unit ~= "player" or not spellName then return end
    local spellId = tracked[spellName]
    if not spellId then return end

    local skill = PP.state.skill
    local maxSkill = windowMax[spellId]
    if maxSkill and skill >= maxSkill then return end  -- gray by design

    local s = statsFor(spellId)
    if not s then return end
    s.crafts = s.crafts + 1
    pending = { spellId = spellId, time = GetTime(), skill = skill,
        profKey = PP.state.activeKey }
end

-- Own scan: current rank of the active profession's skill line, independent
-- of PP.state (SkillTracker updates that on the same event, order unknown).
local function scanActiveRank()
    local prof = PP:GetActiveProfession()
    if not prof then return nil end
    local profName = GetSpellInfo(prof.professionSpellId)
    if not profName then return nil end
    for i = 1, GetNumSkillLines() do
        local name, isHeader, _, rank = GetSkillLineInfo(i)
        if not isHeader and name == profName then
            return rank
        end
    end
    -- A collapsed skill header hides the line; SkillTracker expands it on
    -- its own scans, so this stays nil only transiently. Attribution is
    -- skipped rather than guessed.
    return nil
end

function SkillStats:SKILL_LINES_CHANGED()
    local p = pending
    if not p then return end

    if GetTime() - p.time > ATTRIBUTION_WINDOW
        or PP.state.activeKey ~= p.profKey then
        pending = nil  -- stale or profession switched: drop, stay honest
        return
    end

    local rank = scanActiveRank()
    if not rank then return end          -- transient; keep pending
    local delta = rank - p.skill
    if delta <= 0 then return end        -- unrelated skill line changed

    pending = nil
    local s = statsFor(p.spellId)
    if not s then return end
    s.ups = s.ups + delta
    PP:Debug("SkillStats:", p.spellId, "+" .. delta,
        "(" .. s.ups .. "/" .. s.crafts .. ")")

    -- SkillTracker's Recompute on this same event may have run before the
    -- ups were recorded; recompute once more so refined estimates and the
    -- "(measured)" label stay current.
    PP:Recompute()
end

-- -> { crafts = n, ups = n } | nil. Live reference into the saved table;
-- callers must treat it as read-only.
function SkillStats:GetObserved(spellId)
    local char = PP.db and PP.db.char
    local stats = char and char.stats
    local s = stats and stats[spellId]
    if s and (s.crafts or 0) > 0 then return s end
    return nil
end
