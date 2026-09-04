-- ProfessionPilot Modules/RecipeTracker.lua
-- Caches which recipes the character knows. 3.3.5a offers no API to list
-- known recipes without the profession window, so we scan whenever one is
-- open and persist the result per character.
-- Two window APIs exist on this client: most professions use the TradeSkill
-- API; Enchanting still uses the old Craft API (CRAFT_SHOW, GetCraftInfo,
-- GetCraftRecipeLink) -- both are handled here.

local PP = _G.ProfessionPilot
local RecipeTracker = PP:NewModule("RecipeTracker", "AceEvent-3.0")

function RecipeTracker:OnEnable()
    self:RegisterEvent("TRADE_SKILL_SHOW", "ScanTradeSkill")
    self:RegisterEvent("TRADE_SKILL_UPDATE", "ScanTradeSkill")
    self:RegisterEvent("CRAFT_SHOW", "ScanCraft")
    self:RegisterEvent("CRAFT_UPDATE", "ScanCraft")
    self:RegisterEvent("LEARNED_SPELL_IN_TAB", "OnSpellLearned")
end

local function professionByName(openName)
    if not openName or openName == "UNKNOWN" then return nil end
    for _, prof in pairs(PP:GetProfessions()) do
        if GetSpellInfo(prof.professionSpellId) == openName then
            return prof
        end
    end
    return nil
end

-- Is the currently open trade skill window one of our registered professions?
local function openProfession()
    return professionByName(GetTradeSkillLine())
end

-- Expanding a subclass fires TRADE_SKILL_UPDATE, which lands back here; without
-- this guard the scan recurses until the C stack overflows.
local scanning = false

-- The trade skill APIs only enumerate VISIBLE entries; recipes under a
-- collapsed subclass header would be missed. Expand only headers that are
-- actually collapsed, so an already-expanded window fires no event at all.
-- Iterate backwards and re-check, because expanding shifts later indices.
local function expandAllSubClasses()
    for _ = 1, 5 do
        local collapsed = false
        for i = GetNumTradeSkills(), 1, -1 do
            local _, skillType, _, isExpanded = GetTradeSkillInfo(i)
            if skillType == "header" and not isExpanded then
                collapsed = true
                ExpandTradeSkillSubClass(i)
            end
        end
        if not collapsed then return end
    end
end

function RecipeTracker:ScanTradeSkill()
    if scanning then return end
    local prof = openProfession()
    if not prof or not PP.db then return end

    -- Opening a profession window switches the tracker to that profession --
    -- the player is clearly working on it right now.
    if prof.key ~= PP.state.activeKey and PP.state.professions
        and PP.state.professions[prof.key] then
        PP:SetActiveProfession(prof.key)
    end

    -- Client-side filters ("have materials" etc.) can still hide entries for
    -- one scan, but we only ever add to the cache, never remove.
    scanning = true
    expandAllSubClasses()

    local known = PP.db.char.knownRecipes
    local changed = false
    for i = 1, GetNumTradeSkills() do
        local name, skillType = GetTradeSkillInfo(i)
        if name and skillType ~= "header" then
            local spellId = PP.util.SpellIdFromRecipeLink(GetTradeSkillRecipeLink(i))
            if spellId and not known[spellId] then
                known[spellId] = true
                changed = true
                PP:Debug("RecipeTracker: learned", spellId, name)
            end
        end
    end
    scanning = false

    if PP.db.profile.debug then
        self:VerifyReagents(prof)
    end
    if changed then
        PP:Recompute()
    end
end

-- Ein beim Lehrer oder aus einem Buch gelerntes Rezept taucht in keinem Scan
-- auf, solange kein Berufsfenster offen ist -- und der Spieler hat dann keinen
-- Weg, es bekannt zu machen (Issue #1). Der Zauberbuch-Abgleich schliesst die
-- Luecke: IsSpellKnown (ab 3.0) kennt das Rezept sofort nach dem Lernen.
-- Wie beim Fenster-Scan wird nur hinzugefuegt, nie entfernt.
function RecipeTracker:SweepKnownSpells()
    if type(IsSpellKnown) ~= "function" or not PP.db then return false end
    local known = PP.db.char.knownRecipes
    local changed = false
    for key in pairs(PP.state and PP.state.professions or {}) do
        local prof = PP:GetProfession(key)
        if prof then
            for _, step in ipairs(prof.steps) do
                local spellId = step.recipeSpellId
                if spellId and not known[spellId] and IsSpellKnown(spellId) then
                    known[spellId] = true
                    changed = true
                    PP:Debug("RecipeTracker: learned (spellbook)", spellId)
                end
            end
        end
    end
    return changed
end

function RecipeTracker:OnSpellLearned()
    -- Ein offenes Fenster ist die genauere Quelle (es kennt auch Rezepte
    -- ausserhalb unserer Schrittdaten); beide Scans sind ohne Fenster No-ops.
    self:ScanTradeSkill()
    self:ScanCraft()
    if self:SweepKnownSpells() then
        PP:Recompute()
    end
end

-- Craft API scan (Enchanting on 3.3.5a). Recipe links use the same
-- |Henchant:<spellId> form as trade skill links.
function RecipeTracker:ScanCraft()
    local prof = professionByName(GetCraftName and GetCraftName() or nil)
    if not prof or not PP.db then return end

    if prof.key ~= PP.state.activeKey and PP.state.professions
        and PP.state.professions[prof.key] then
        PP:SetActiveProfession(prof.key)
    end

    local known = PP.db.char.knownRecipes
    local changed = false
    for i = 1, GetNumCrafts() do
        local name, _, craftType = GetCraftInfo(i)
        if name and craftType ~= "header" then
            local spellId = PP.util.SpellIdFromRecipeLink(GetCraftRecipeLink(i))
            if spellId and not known[spellId] then
                known[spellId] = true
                changed = true
                PP:Debug("RecipeTracker: learned (craft)", spellId, name)
            end
        end
    end
    if changed then
        PP:Recompute()
    end
end

-- Debug aid: compare live reagent data against the static step data and log
-- any mismatch (guide numbers are estimates; the client is the truth).
function RecipeTracker:VerifyReagents(prof)
    for i = 1, GetNumTradeSkills() do
        local name, skillType = GetTradeSkillInfo(i)
        if name and skillType ~= "header" then
            local spellId = PP.util.SpellIdFromRecipeLink(GetTradeSkillRecipeLink(i))
            local step = spellId and prof.producers[spellId]
            if step then
                local perCraft = {}
                for _, m in ipairs(step.materials) do
                    perCraft[m.itemId] = m.amount / step.estimatedCrafts
                end
                for r = 1, GetTradeSkillNumReagents(i) do
                    local _, _, needed = GetTradeSkillReagentInfo(i, r)
                    local itemId = PP.util.ItemIdFromLink(
                        GetTradeSkillReagentItemLink(i, r))
                    if itemId and perCraft[itemId] and perCraft[itemId] ~= needed then
                        PP:Debug("reagent mismatch:", name, "item", itemId,
                            "data", perCraft[itemId], "client", needed)
                    end
                end
                local minMade = GetTradeSkillNumMade(i)
                if minMade and minMade ~= (step.numMade or 1) then
                    PP:Debug("numMade mismatch:", name,
                        "data", step.numMade or 1, "client", minMade)
                end
            end
        end
    end
end
