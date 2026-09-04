-- ProfessionPilot Modules/SkillTracker.lua
-- Finds every registered profession the character knows and keeps skill/cap
-- up to date. Locale-independent detection: a skill line belongs to a
-- registered profession when its name equals GetSpellInfo(professionSpellId).
-- The "active" profession (shown in the UI) is the persisted user choice if
-- still valid, otherwise the first known one in sorted key order.

local PP = _G.ProfessionPilot
local SkillTracker = PP:NewModule("SkillTracker", "AceEvent-3.0")

function SkillTracker:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "Scan")
    self:RegisterEvent("SKILL_LINES_CHANGED", "Scan")
    self:RegisterMessage("PP_FORCE_SCAN", "Scan")
end

local function scanLines(byName, into)
    for i = 1, GetNumSkillLines() do
        local name, isHeader, _, rank, _, _, maxRank = GetSkillLineInfo(i)
        if not isHeader and name and byName[name] then
            into[byName[name]] = { skill = rank, cap = maxRank }
        end
    end
end

local function sortedKeys(t)
    local keys = {}
    for k in pairs(t) do keys[#keys + 1] = k end
    table.sort(keys)
    return keys
end

local function hasCollapsedHeader()
    for i = 1, GetNumSkillLines() do
        local _, isHeader, isExpanded = GetSkillLineInfo(i)
        if isHeader and not isExpanded then return true end
    end
end

function SkillTracker:Scan()
    -- ExpandSkillHeader in DoScan fires SKILL_LINES_CHANGED synchronously,
    -- which lands right back here. Without this guard that recurses until the
    -- C stack overflows, because a character with no known profession never
    -- satisfies the "found something" exit condition.
    if self.scanning then return end
    self.scanning = true
    local ok, err = pcall(self.DoScan, self)
    self.scanning = nil
    if not ok then error(err, 0) end
end

function SkillTracker:DoScan()
    local byName = {}
    for key, prof in pairs(PP:GetProfessions()) do
        local name = GetSpellInfo(prof.professionSpellId)
        if name then byName[name] = key end
    end

    local found = {}
    scanLines(byName, found)
    if not next(found) and hasCollapsedHeader() then
        -- Collapsed skill headers hide their children from enumeration.
        -- Expand once and retry; rare enough that we accept the side effect.
        ExpandSkillHeader(0)
        scanLines(byName, found)
    end

    local st = PP.state
    local previous = st.professions or {}
    st.professions = found

    -- Unlearning wipes all recipes server-side; drop the stale cache so a
    -- re-learned profession does not show recipes as known.
    if PP.db then
        for key in pairs(previous) do
            if not found[key] then
                local oldProf = PP:GetProfession(key)
                if oldProf then
                    for _, step in ipairs(oldProf.steps) do
                        PP.db.char.knownRecipes[step.recipeSpellId] = nil
                    end
                    PP:Debug("SkillTracker:", key, "unlearned, recipe cache cleared")
                end
            end
        end
    end

    -- Pick the active profession: current if still valid, else the persisted
    -- choice, else the first known one (sorted for determinism).
    local active = st.activeKey
    if not (active and found[active]) then
        active = PP.db and PP.db.char.activeProfession or nil
        if not (active and found[active]) then
            active = sortedKeys(found)[1]
        end
    end

    local info = active and found[active]
    local changed = st.activeKey ~= active
        or st.skill ~= (info and info.skill or 0)
        or st.cap ~= (info and info.cap or 0)

    st.activeKey = active
    st.hasProfession = active ~= nil
    st.skill = info and info.skill or 0
    st.cap = info and info.cap or 0

    if PP.db then
        PP.db.char.activeProfession = active
        PP.db.char.lastSkill = st.skill
    end
    if changed then
        PP:Debug("SkillTracker:", tostring(active), "skill", st.skill, "cap", st.cap)
    end
    PP:Recompute()
end
