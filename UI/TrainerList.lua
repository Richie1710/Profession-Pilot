-- ProfessionPilot UI/TrainerList.lua
-- Lehrer-Uebersicht: Lehrer je Beruf nach Ort gruppiert, eigene Fraktion + neutral,
-- Lehrer fuer den naechsten Rang hervorgehoben. Klick setzt einen Wegpunkt (PP.Waypoint),
-- Shift-Klick schreibt die Koordinaten in den Chat. Logik in Core/Trainers.lua.

local PP = _G.ProfessionPilot
local L = PP.L

local TrainerList = {}
PP.UI.TrainerList = TrainerList
LibStub("AceEvent-3.0"):Embed(TrainerList)

local FRAME_NAME = "ProfessionPilotTrainerFrame"
local ROW_HEIGHT = 16
local NUM_ROWS = 18
local WIDTH = 380
local TOP = 76 -- Hoehe des Kopfbereichs

local BACKDROP = {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 32, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
}

local FACTION_COLOR = { A = "ff4a8cff", H = "ffff4040", N = "ffaaaaaa" }
local REP_KEY = { aldor = "REP_ALDOR", scryers = "REP_SCRYERS", timbermaw = "REP_TIMBERMAW" }

local frame
local display = {}
-- Ansichtszustand: Beruf, Rang aus einem Meilenstein (nil = naechster Rang), Rangfilter
local view = { key = nil, rank = nil, onlyRank = nil }

local function sortedProfessionKeys()
    local keys = {}
    for key in pairs(PP:GetProfessions() or {}) do keys[#keys + 1] = key end
    table.sort(keys)
    return keys
end

local function defaultKey()
    if PP.state and PP.state.activeKey then return PP.state.activeKey end
    if PP.db and PP.db.char and PP.db.char.activeProfession then return PP.db.char.activeProfession end
    return sortedProfessionKeys()[1]
end

-- Naechster Rang des Charakters im angezeigten Beruf (nicht erlernt -> Lehrling)
local function nextRankFor(key)
    local prof = PP:GetProfession(key)
    local info = PP.state and PP.state.professions and PP.state.professions[key]
    if not prof then return 1 end
    if type(info) ~= "table" then return 1 end
    return PP.Trainers.NextRank(prof.ranks, info.skill, info.cap, prof.maxSkill)
end

local function onlyRankActive()
    if view.onlyRank ~= nil then return view.onlyRank end
    return PP.db.profile.trainerOnlyNext and true or false
end

local function rowTooltip(row)
    local item = display[row.listIndex]
    if not item or not item.row or not PP.db.profile.tooltips then return end
    local r, t = item.row, item.row.trainer
    local locale = GetLocale()
    local data = PP.TrainerData

    GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
    GameTooltip:AddLine(r.name, 1, 1, 1)
    if t.spec then
        local sub = PP.Trainers.LocalSub(t, locale)
        if sub and sub ~= "" then GameTooltip:AddLine(sub, 0.8, 0.8, 0.8) end
    end
    local where = r.zone
    if r.sub then where = r.sub .. ", " .. r.zone end
    GameTooltip:AddLine(L["TRAINER_TT_COORDS"]:format(where, t.x, t.y), 1, 0.82, 0)

    if t.ranks and #t.ranks > 0 then
        local names = {}
        for i, rank in ipairs(t.ranks) do names[i] = L["RANK_" .. rank] end
        GameTooltip:AddLine(L["TRAINER_TT_RANKS"]:format(table.concat(names, ", ")), 0.9, 0.9, 0.9, true)
    end

    local rank = view.rank or nextRankFor(view.key)
    if rank and PP.Trainers.Teaches(t, rank) then
        local lvl = PP.Trainers.RankLevel(data, view.key, rank)
        if lvl then
            local low = (UnitLevel("player") or 0) < lvl
            GameTooltip:AddLine(L["TRAINER_TT_LEVEL"]:format(L["RANK_" .. rank], lvl),
                low and 1 or 0.6, low and 0.35 or 0.9, low and 0.35 or 0.6)
        end
    end
    if t.rep and REP_KEY[t.rep] then
        GameTooltip:AddLine(L["TRAINER_TT_REP"]:format(L[REP_KEY[t.rep]]), 1, 0.6, 0.2, true)
    end
    GameTooltip:AddLine(L["TRAINER_TT_CLICK"], 0.4, 0.75, 1)
    GameTooltip:AddLine(L["TRAINER_TT_SHIFTCLICK"], 0.4, 0.75, 1)
    GameTooltip:Show()
end

local function rowClick(row)
    local item = display[row.listIndex]
    if not item or not item.row then return end
    local r, t = item.row, item.row.trainer
    local z = PP.TrainerData.zones[t.map]
    PP.Waypoint.Set({
        c = z and z.c, map = t.map, x = t.x, y = t.y,
        title = r.name, zoneName = r.zone, forceChat = IsShiftKeyDown() and true or false,
    })
end

local function updateRows()
    local offset = FauxScrollFrame_GetOffset(frame.scroll)
    for i = 1, NUM_ROWS do
        local row = frame.rows[i]
        local item = display[offset + i]
        row.listIndex = offset + i
        if not item then
            row:Hide()
        elseif item.header then
            local g = item.header
            row.name:SetText(g.kind == "spec" and L["TRAINER_GROUP_SPEC"] or (g.title or "?"))
            row.name:SetTextColor(1, 0.82, 0)
            row.right:SetText("")
            row.mark:SetText("")
            row:EnableMouse(false)
            row:Show()
        else
            local r, t = item.row, item.row.trainer
            local text = r.name
            if item.group.kind == "spec" then
                local sub = PP.Trainers.LocalSub(t, GetLocale())
                text = text .. " - " .. r.zone .. ((sub and sub ~= "") and (" (" .. sub .. ")") or "")
            elseif r.sub then
                text = text .. " - " .. r.sub
            end
            row.name:SetText(text)
            row.mark:SetText(r.highlight and ">" or "")
            if r.highlight then
                row.name:SetTextColor(0.3, 1, 0.3)
            else
                row.name:SetTextColor(0.95, 0.95, 0.95)
            end
            local rankText = r.maxRank and L["RANK_" .. r.maxRank] or ""
            row.right:SetText(string.format("%s |c%s%s|r", rankText,
                FACTION_COLOR[t.f] or FACTION_COLOR.N, L["FACTION_SHORT_" .. (t.f or "N")]))
            row:EnableMouse(true)
            row:Show()
        end
    end
    FauxScrollFrame_Update(frame.scroll, #display, NUM_ROWS, ROW_HEIGHT)
end

local function resetScroll()
    FauxScrollFrame_SetOffset(frame.scroll, 0)
    local bar = _G[FRAME_NAME .. "ScrollScrollBar"]
    if bar then bar:SetValue(0) end
end

local function cycleProfession(step)
    local keys = sortedProfessionKeys()
    if #keys == 0 then return end
    local idx = 1
    for i, k in ipairs(keys) do if k == view.key then idx = i end end
    idx = (idx - 1 + step) % #keys + 1
    view.key = keys[idx]
    view.rank, view.onlyRank = nil, nil
    resetScroll()
    TrainerList:Refresh()
end

local function createFrame()
    frame = CreateFrame("Frame", FRAME_NAME, UIParent)
    frame:SetWidth(WIDTH)
    frame:SetHeight(NUM_ROWS * ROW_HEIGHT + TOP + 12)
    frame:SetBackdrop(BACKDROP)
    frame:SetBackdropColor(0, 0, 0, 0.92)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    frame:SetClampedToScreen(true)
    frame:SetPoint("CENTER", UIParent, "CENTER", -160, 20)
    tinsert(UISpecialFrames, FRAME_NAME)

    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", 0, 0)

    local prev = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    prev:SetWidth(22)
    prev:SetHeight(18)
    prev:SetPoint("TOPLEFT", 8, -7)
    prev:SetText("<")
    prev:SetScript("OnClick", function() cycleProfession(-1) end)
    local nxt = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    nxt:SetWidth(22)
    nxt:SetHeight(18)
    nxt:SetPoint("LEFT", prev, "RIGHT", 2, 0)
    nxt:SetText(">")
    nxt:SetScript("OnClick", function() cycleProfession(1) end)

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.title:SetPoint("LEFT", nxt, "RIGHT", 8, 0)

    frame.rankLine = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    frame.rankLine:SetPoint("TOPLEFT", 12, -32)
    frame.rankLine:SetJustifyH("LEFT")

    frame.only = CreateFrame("CheckButton", FRAME_NAME .. "Only", frame, "UICheckButtonTemplate")
    frame.only:SetWidth(20)
    frame.only:SetHeight(20)
    frame.only:SetPoint("TOPLEFT", 8, -46)
    frame.onlyText = _G[FRAME_NAME .. "OnlyText"]
    frame.only:SetScript("OnClick", function(self)
        local on = self:GetChecked() and true or false
        view.onlyRank = on
        PP.db.profile.trainerOnlyNext = on
        resetScroll()
        TrainerList:Refresh()
    end)

    frame.count = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    frame.count:SetPoint("TOPRIGHT", -12, -52)
    frame.count:SetJustifyH("RIGHT")

    frame.empty = frame:CreateFontString(nil, "OVERLAY", "GameFontDisable")
    frame.empty:SetPoint("TOP", 0, -TOP - 20)

    frame.scroll = CreateFrame("ScrollFrame", FRAME_NAME .. "Scroll", frame, "FauxScrollFrameTemplate")
    frame.scroll:SetPoint("TOPLEFT", 8, -TOP)
    frame.scroll:SetPoint("BOTTOMRIGHT", -28, 10)
    frame.scroll:SetScript("OnVerticalScroll", function(self, delta)
        FauxScrollFrame_OnVerticalScroll(self, delta, ROW_HEIGHT, updateRows)
    end)

    frame.rows = {}
    for i = 1, NUM_ROWS do
        local row = CreateFrame("Button", nil, frame)
        row:SetHeight(ROW_HEIGHT)
        row:SetPoint("TOPLEFT", 12, -TOP - (i - 1) * ROW_HEIGHT)
        row:SetPoint("RIGHT", frame, "RIGHT", -30, 0)
        row:RegisterForClicks("LeftButtonUp")
        row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
        row:SetScript("OnClick", rowClick)
        row:SetScript("OnEnter", rowTooltip)
        row:SetScript("OnLeave", function() GameTooltip:Hide() end)

        row.mark = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        row.mark:SetPoint("LEFT", 0, 0)
        row.mark:SetWidth(10)
        row.mark:SetTextColor(0.3, 1, 0.3)

        row.right = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        row.right:SetPoint("RIGHT", 0, 0)
        row.right:SetJustifyH("RIGHT")

        row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        row.name:SetPoint("LEFT", row.mark, "RIGHT", 2, 0)
        row.name:SetPoint("RIGHT", row.right, "LEFT", -4, 0)
        row.name:SetJustifyH("LEFT")

        frame.rows[i] = row
    end
end

function TrainerList:Refresh()
    if not frame or not frame:IsShown() then return end
    for i = #display, 1, -1 do display[i] = nil end

    if not view.key or not PP:GetProfession(view.key) then view.key = defaultKey() end
    local prof = view.key and PP:GetProfession(view.key)
    if not prof or not PP.TrainerData then
        frame.title:SetText(L["TRAINERLIST_TITLE"]:format("?"))
        frame.rankLine:SetText(L["TRAINER_NO_PROFESSION"])
        frame.only:Hide()
        frame.count:SetText("")
        frame.empty:SetText("")
        updateRows()
        return
    end

    frame.title:SetText(L["TRAINERLIST_TITLE"]:format(GetSpellInfo(prof.professionSpellId) or prof.key))

    local nextRank = nextRankFor(view.key)
    local rank = view.rank or nextRank
    if nextRank then
        local lvl = PP.Trainers.RankLevel(PP.TrainerData, view.key, nextRank)
        local text = L["TRAINER_NEXT_RANK"]:format(L["RANK_" .. nextRank])
        if lvl then text = text .. " " .. L["TRAINER_NEXT_LEVEL"]:format(lvl) end
        frame.rankLine:SetText(text)
    else
        frame.rankLine:SetText(L["TRAINER_ALL_LEARNED"])
    end

    local onlyRank = onlyRankActive()
    if rank then
        frame.only:Show()
        frame.only:SetChecked(onlyRank)
        if frame.onlyText then frame.onlyText:SetText(L["TRAINER_ONLY_RANK"]:format(L["RANK_" .. rank])) end
    else
        frame.only:Hide()
        onlyRank = false
    end

    local groups = PP.Trainers.Build(PP.TrainerData, view.key, {
        faction = PP.Trainers.FactionCode(UnitFactionGroup("player")),
        nextRank = rank,
        onlyRank = (onlyRank and rank) or nil,
        locale = GetLocale(),
    })
    for _, item in ipairs(PP.Trainers.Flatten(groups)) do display[#display + 1] = item end
    frame.count:SetText(L["TRAINER_COUNT"]:format(PP.Trainers.Count(groups), PP.Trainers.HighlightCount(groups)))
    frame.empty:SetText(#display == 0 and L["TRAINER_NONE"] or "")
    updateRows()
end

-- opts = { profession = key, rank = 1..6, onlyRank = bool } (alles optional)
function TrainerList:Show(opts)
    if not frame then createFrame() end
    opts = opts or {}
    if opts.profession then view.key = opts.profession elseif not view.key then view.key = defaultKey() end
    view.rank = opts.rank
    if opts.onlyRank ~= nil then view.onlyRank = opts.onlyRank else view.onlyRank = nil end
    resetScroll()
    frame:Show()
    self:Refresh()
end

function TrainerList:Hide()
    if frame then frame:Hide() end
end

function TrainerList:Toggle()
    if frame and frame:IsShown() then self:Hide() else self:Show() end
end

TrainerList:RegisterMessage("PP_SNAPSHOT", function() TrainerList:Refresh() end)
TrainerList:RegisterMessage("PP_SETTINGS_CHANGED", function() TrainerList:Refresh() end)
