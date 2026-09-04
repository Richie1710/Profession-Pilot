-- ProfessionPilot Core/Core.lua
-- Addon bootstrap: creates the single global addon object, wires slash
-- commands and turns tracker state into UI snapshots (PP_SNAPSHOT message).
--
-- 3.3.5a note: the private addon namespace (`local name, ns = ...`) does not
-- exist on this client (added in 4.0), so one deliberate global table is used.

local AceAddon = LibStub("AceAddon-3.0")
local PP = AceAddon:NewAddon("ProfessionPilot",
    "AceConsole-3.0", "AceEvent-3.0", "AceBucket-3.0", "AceTimer-3.0")
_G.ProfessionPilot = PP

PP.L = LibStub("AceLocale-3.0"):GetLocale("ProfessionPilot")
PP.UI = {}

-- Live state maintained by the tracker modules.
PP.state = { skill = 0, cap = 0, hasProfession = false, activeKey = nil }
PP.counts = {}   -- [itemId] = { bags = n, bank = n }, tracked items only
PP.snapshot = nil

function PP:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("ProfessionPilotDB", self.defaults, true)
    self:RegisterChatCommand("pp", "HandleSlash")
    self:RegisterChatCommand("professionpilot", "HandleSlash")
    self:RegisterChatCommand("ph", "HandleSlash")
end

function PP:Debug(...)
    if self.db and self.db.profile.debug then
        self:Print("|cff33ff99[debug]|r", ...)
    end
end

-- Item names may be missing from the client cache (GetItemInfo returns nil
-- until the server answers; 3.3.5a has no GET_ITEM_INFO_RECEIVED event).
-- Shared by every renderer: returns a placeholder, primes the cache via a
-- hidden tooltip and schedules a single delayed re-render broadcast.
local scanTip, refreshPending
function PP:GetItemName(itemId)
    local name = GetItemInfo(itemId)
    if name then return name end

    if not scanTip then
        scanTip = CreateFrame("GameTooltip", "ProfessionPilotScanTip",
            nil, "GameTooltipTemplate")
        scanTip:SetOwner(UIParent, "ANCHOR_NONE")
    end
    scanTip:SetHyperlink("item:" .. itemId)

    if not refreshPending then
        refreshPending = true
        self:ScheduleTimer(function()
            refreshPending = false
            self:SendMessage("PP_SNAPSHOT")
        end, 1)
    end
    return self.L["ITEM_LOADING"]:format(itemId)
end

function PP:GetActiveProfession()
    local key = self.state.activeKey
    if not key then return nil end
    return self:GetProfession(key)
end

-- Switch the tracked profession (must be one the character actually has).
function PP:SetActiveProfession(key)
    local info = self.state.professions and self.state.professions[key]
    if not info then return false end
    self.state.activeKey = key
    self.state.hasProfession = true
    self.state.skill = info.skill
    self.state.cap = info.cap
    if self.db then self.db.char.activeProfession = key end
    self:Debug("active profession ->", key)
    self:Recompute()
    return true
end

-- Cycle to the next known profession (sorted key order); used by /pp prof.
function PP:CycleProfession()
    local keys = {}
    for k in pairs(self.state.professions or {}) do keys[#keys + 1] = k end
    table.sort(keys)
    if #keys == 0 then return end
    local nextIdx = 1
    for i, k in ipairs(keys) do
        if k == self.state.activeKey then
            nextIdx = (i % #keys) + 1
            break
        end
    end
    self:SetActiveProfession(keys[nextIdx])
end

local function displayCounts(self, itemId)
    local c = self.counts[itemId]
    local bags = c and c.bags or 0
    local bank = c and c.bank or 0
    return bags, bank
end

-- Rebuild the full UI snapshot from current state. Called by trackers after
-- every relevant change; all heavy lifting is pure Calc code, no polling.
function PP:Recompute()
    if not self.db then return end
    local prof = self:GetActiveProfession()

    if not prof or not self.state.hasProfession then
        self.snapshot = { profession = nil }
        self:SendMessage("PP_SNAPSHOT")
        return
    end

    local Calc = self.Calc
    local profile = self.db.profile
    local ctx = {
        skill = self.state.skill,
        cap = self.state.cap,
        known = self.db.char.knownRecipes,
        counts = self.counts,
        includeBank = profile.includeBank,
        maxSkill = prof.maxSkill,
    }

    local steps = prof.steps
    local currentIndex = Calc.GetCurrentStepIndex(steps, ctx.skill)

    local stepInfos = {}
    for i = 1, #steps do
        local status, flags = Calc.GetStepStatus(steps[i], ctx)
        if i == currentIndex then status = "current" end
        stepInfos[i] = {
            status = status,
            flags = flags,
            remainingCrafts = Calc.GetRemainingCrafts(steps[i], ctx.skill),
        }
    end

    -- Skill-up telemetry: replace the current step's guide estimate with
    -- the measured one when enough observations exist (guarded so a missing
    -- Stats.lua/SkillStats.lua never breaks the snapshot).
    local SkillStats = self.GetModule and self:GetModule("SkillStats", true)
    if currentIndex and self.Stats and SkillStats and SkillStats.GetObserved then
        local observed = SkillStats:GetObserved(steps[currentIndex].recipeSpellId)
        if observed then
            local refined, measured = self.Stats.RefinedRemaining(
                steps[currentIndex], ctx.skill, observed)
            if measured then
                stepInfos[currentIndex].remainingCrafts = refined
                stepInfos[currentIndex].measured = true
            end
        end
    end

    local currentMaterials = {}
    if currentIndex then
        local needs = Calc.GetStepMaterialNeeds(steps[currentIndex], ctx.skill)
        for i = 1, #needs do
            local n = needs[i]
            local bags, bank = displayCounts(self, n.itemId)
            local have = bags
            if profile.includeBank then have = have + bank end
            currentMaterials[i] = {
                itemId = n.itemId, need = n.need, bags = bags, bank = bank,
                have = have, missing = math.max(0, n.need - have),
                craftedBy = n.craftedBy,
            }
        end
    end

    local toSkill = prof.maxSkill
    if not profile.showUpcoming and currentIndex then
        toSkill = steps[currentIndex].maxSkill
    end
    local totals = Calc.AggregateMaterials(prof, ctx, { toSkill = toSkill })
    local tree = {}
    if currentIndex then
        tree = Calc.BuildMaterialTree(prof, steps[currentIndex], ctx)
    end

    -- Attach display counts to every node of both hierarchies.
    local function attachCounts(e)
        e.bags, e.bank = displayCounts(self, e.itemId)
    end
    Calc.WalkTree(totals.entries, attachCounts)
    Calc.WalkTree(tree, attachCounts)

    self.snapshot = {
        profession = prof,
        skill = ctx.skill,
        cap = ctx.cap,
        currentIndex = currentIndex,
        steps = stepInfos,
        currentMaterials = currentMaterials,
        totals = totals,
        tree = tree,
        rankWarning = ctx.cap < prof.maxSkill and ctx.skill >= ctx.cap - 10,
    }
    if self.UI.MinimapButton and self.UI.MinimapButton.UpdateFromSnapshot then
        self.UI.MinimapButton:UpdateFromSnapshot()
    end
    self:SendMessage("PP_SNAPSHOT")
end

function PP:HandleSlash(input)
    local L = self.L
    local cmd = (input or ""):match("^%s*(%S*)") or ""
    cmd = cmd:lower()

    if cmd == "" or cmd == "show" then
        self.UI.MainWindow:Toggle()
    elseif cmd == "steps" then
        self.UI.StepList:Toggle()
    elseif cmd == "mats" or cmd == "material" then
        self.UI.MaterialList:Toggle()
    elseif cmd == "config" or cmd == "options" then
        self.UI.Options:Open()
    elseif cmd == "prof" or cmd == "beruf" then
        self:CycleProfession()
        local prof = self:GetActiveProfession()
        if prof then
            self:Print((L["PROF_SWITCHED"]):format(
                GetSpellInfo(prof.professionSpellId) or prof.key))
        end
    elseif cmd == "debug" then
        self.db.profile.debug = not self.db.profile.debug
        self:Print(self.db.profile.debug and L["DEBUG_ON"] or L["DEBUG_OFF"])
    elseif cmd == "reset" then
        self.db:ResetProfile()
        self:Print(L["PROFILE_RESET"])
        self.UI.MinimapButton:ApplySettings()
        self:SendMessage("PP_SETTINGS_CHANGED")
        self:Recompute()
    elseif cmd == "scan" then
        self:SendMessage("PP_FORCE_SCAN")
        self:Print(L["SCAN_DONE"])
    else
        self:Print(L["SLASH_HELP"])
    end
end
