-- ProfessionPilot UI/StepList.lua
-- Scrollable overview of every leveling step 1-450 with status colors and
-- trainer-rank milestones. Tooltip per row shows materials, source and notes.

local PP = _G.ProfessionPilot
local L = PP.L

local StepList = {}
PP.UI.StepList = StepList
LibStub("AceEvent-3.0"):Embed(StepList)

local FRAME_NAME = "ProfessionPilotStepFrame"
local ROW_HEIGHT = 16
local NUM_ROWS = 18
local WIDTH = 380

local BACKDROP = {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 32, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
}

local STATUS_COLOR = {
    completed = { 0.55, 0.55, 0.55 },
    current   = { 1.0, 0.82, 0.0 },
    rank      = { 1.0, 0.35, 0.35 },
    recipe    = { 1.0, 0.6, 0.2 },
    mats      = { 1.0, 0.95, 0.45 },
    upcoming  = { 0.95, 0.95, 0.95 },
}

local STATUS_ICON = {
    completed = "Interface\\RaidFrame\\ReadyCheck-Ready",
    blocked   = "Interface\\RaidFrame\\ReadyCheck-NotReady",
    waiting   = "Interface\\RaidFrame\\ReadyCheck-Waiting",
}

local frame
local displayList = {}

-- One list entry per step plus milestone rows after each rank cap.
local function buildDisplayList(snap)
    for i = #displayList, 1, -1 do displayList[i] = nil end
    if not snap or not snap.profession then return end

    local onlyCurrent = PP.db.profile.onlyCurrent
    local prof = snap.profession
    local capIdx = 1
    for i = 1, #prof.steps do
        local step = prof.steps[i]
        while capIdx < #prof.ranks and step.minSkill >= prof.ranks[capIdx] do
            if not (onlyCurrent and snap.cap > prof.ranks[capIdx]) then
                displayList[#displayList + 1] =
                    { milestone = capIdx, cap = prof.ranks[capIdx] }
            end
            capIdx = capIdx + 1
        end
        if not (onlyCurrent and snap.steps[i].status == "completed") then
            displayList[#displayList + 1] = { stepIndex = i }
        end
    end
end

-- Effective display status of a step row: progression first, then blockers.
local function rowStatus(info)
    if info.status == "completed" then return "completed" end
    if info.flags.rankBlocked then return "rank" end
    if not info.flags.recipeKnown and not info.flags.recipeLearnable then
        return "recipe"
    end
    if info.status == "current" then
        if not info.flags.recipeKnown then return "recipe" end
        if info.flags.matsMissing then return "mats" end
        return "current"
    end
    return "upcoming"
end

local STATUS_LABEL = {
    completed = "STATUS_COMPLETED",
    current   = "STATUS_CURRENT",
    upcoming  = "STATUS_UPCOMING",
    rank      = "STATUS_RANK_MISSING",
    recipe    = "STATUS_RECIPE_MISSING",
    mats      = "STATUS_MATS_MISSING",
}

local function stepTooltip(row)
    local entry = displayList[row.listIndex]
    if not entry or not entry.stepIndex or not PP.db.profile.tooltips then return end
    local snap = PP.snapshot
    if not snap or not snap.profession then return end

    local step = snap.profession.steps[entry.stepIndex]
    local info = snap.steps[entry.stepIndex]

    GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
    local name = GetSpellInfo(step.recipeSpellId)
    GameTooltip:AddLine(name or "?", 1, 1, 1)
    GameTooltip:AddLine(L["SECTION_LABEL"]:format(step.minSkill, step.maxSkill)
        .. "  -  " .. L[STATUS_LABEL[rowStatus(info)]], 1, 0.82, 0)

    for _, m in ipairs(step.materials) do
        local matName = PP:GetItemName(m.itemId)
        local c = PP.counts[m.itemId]
        local bags = c and c.bags or 0
        local bank = (PP.db.profile.includeBank and c) and (c.bank or 0) or 0
        local haveTotal = bags + bank
        local suffix = m.craftedBy and (" |cff88ccff(" .. L["CRAFT_FIRST"] .. ")|r") or ""
        local r, g, b = 1, 0.4, 0.4
        if haveTotal >= m.amount then r, g, b = 0.4, 1, 0.4 end
        GameTooltip:AddDoubleLine(matName .. suffix, haveTotal .. " / " .. m.amount,
            0.9, 0.9, 0.9, r, g, b)
    end

    local sourceKey = "SOURCE_TRAINER"
    if step.source == "vendor" then
        sourceKey = "SOURCE_VENDOR"
    elseif step.source == "quest" then
        sourceKey = "SOURCE_QUEST"
    end
    GameTooltip:AddLine(L[sourceKey], 0.7, 0.7, 1)
    if step.vendorNoteKey then
        GameTooltip:AddLine(L[step.vendorNoteKey], 0.7, 0.7, 1, true)
    end
    if step.notesKey then
        GameTooltip:AddLine(L[step.notesKey], 1, 0.95, 0.45, true)
    end
    if step.saveForLater then
        GameTooltip:AddLine(L["SAVE_FOR_LATER"], 0.4, 1, 0.4, true)
    end
    if step.alternatives and PP.db.profile.showAlternatives then
        for _, alt in ipairs(step.alternatives) do
            local altName = GetSpellInfo(alt.recipeSpellId)
            GameTooltip:AddLine(L["ALTERNATIVE_LABEL"] .. " " .. (altName or "?")
                .. " (" .. L[alt.condKey] .. ")", 0.53, 0.8, 1, true)
        end
    end
    GameTooltip:Show()
end

local function updateRows()
    local offset = FauxScrollFrame_GetOffset(frame.scroll)
    local snap = PP.snapshot

    for r = 1, NUM_ROWS do
        local row = frame.rows[r]
        local entry = displayList[offset + r]
        row.listIndex = offset + r

        if not entry or not snap or not snap.profession then
            row:Hide()
        elseif entry.milestone then
            local rankName = L["RANK_" .. (entry.milestone + 1)]
            row.range:SetText("")
            row.name:SetText(L["MILESTONE_LEARN"]:format(rankName))
            row.count:SetText("")
            if snap.cap > entry.cap then
                row.name:SetTextColor(unpack(STATUS_COLOR.completed))
                row.statusIcon:SetTexture(STATUS_ICON.completed)
            elseif snap.skill >= entry.cap - 10 then
                row.name:SetTextColor(unpack(STATUS_COLOR.rank))
                row.statusIcon:SetTexture(STATUS_ICON.blocked)
            else
                row.name:SetTextColor(unpack(STATUS_COLOR.upcoming))
                row.statusIcon:SetTexture(STATUS_ICON.waiting)
            end
            row:Show()
        else
            local step = snap.profession.steps[entry.stepIndex]
            local info = snap.steps[entry.stepIndex]
            local status = rowStatus(info)

            row.range:SetText(step.minSkill .. "-" .. step.maxSkill)
            local name = GetSpellInfo(step.recipeSpellId)
            row.name:SetText(name or "?")

            local countFmt = step.approximate and L["CRAFT_COUNT_APPROX"]
                or L["CRAFT_COUNT"]
            if info.status == "current" then
                row.count:SetText(countFmt:format(info.remainingCrafts))
            else
                row.count:SetText(countFmt:format(step.estimatedCrafts))
            end

            local color = STATUS_COLOR[status]
            row.range:SetTextColor(unpack(color))
            row.name:SetTextColor(unpack(color))
            row.count:SetTextColor(unpack(color))

            if status == "completed" then
                row.statusIcon:SetTexture(STATUS_ICON.completed)
            elseif status == "rank" or status == "recipe" then
                row.statusIcon:SetTexture(STATUS_ICON.blocked)
            else
                row.statusIcon:SetTexture(STATUS_ICON.waiting)
            end
            row:Show()
        end
    end

    FauxScrollFrame_Update(frame.scroll, #displayList, NUM_ROWS, ROW_HEIGHT)
end

local function createFrame()
    frame = CreateFrame("Frame", FRAME_NAME, UIParent)
    frame:SetWidth(WIDTH)
    frame:SetHeight(NUM_ROWS * ROW_HEIGHT + 52)
    frame:SetBackdrop(BACKDROP)
    frame:SetBackdropColor(0, 0, 0, 0.92)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    frame:SetClampedToScreen(true)
    frame:SetPoint("CENTER", UIParent, "CENTER", -120, 40)
    tinsert(UISpecialFrames, FRAME_NAME)

    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", 0, 0)

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.title:SetPoint("TOPLEFT", 10, -8)  -- text set in Refresh (per profession)

    frame.scroll = CreateFrame("ScrollFrame", FRAME_NAME .. "Scroll", frame,
        "FauxScrollFrameTemplate")
    frame.scroll:SetPoint("TOPLEFT", 8, -28)
    frame.scroll:SetPoint("BOTTOMRIGHT", -28, 10)
    frame.scroll:SetScript("OnVerticalScroll", function(self, delta)
        FauxScrollFrame_OnVerticalScroll(self, delta, ROW_HEIGHT, updateRows)
    end)

    frame.rows = {}
    for r = 1, NUM_ROWS do
        local row = CreateFrame("Frame", nil, frame)
        row:SetHeight(ROW_HEIGHT)
        row:SetPoint("TOPLEFT", 12, -28 - (r - 1) * ROW_HEIGHT)
        row:SetPoint("RIGHT", frame, "RIGHT", -30, 0)
        row:EnableMouse(true)
        row:SetScript("OnEnter", stepTooltip)
        row:SetScript("OnLeave", function() GameTooltip:Hide() end)

        row.statusIcon = row:CreateTexture(nil, "ARTWORK")
        row.statusIcon:SetWidth(12)
        row.statusIcon:SetHeight(12)
        row.statusIcon:SetPoint("LEFT", 0, 0)

        row.range = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        row.range:SetPoint("LEFT", row.statusIcon, "RIGHT", 4, 0)
        row.range:SetWidth(52)
        row.range:SetJustifyH("LEFT")

        row.count = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        row.count:SetPoint("RIGHT", 0, 0)

        row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        row.name:SetPoint("LEFT", row.range, "RIGHT", 4, 0)
        row.name:SetPoint("RIGHT", row.count, "LEFT", -4, 0)
        row.name:SetJustifyH("LEFT")

        frame.rows[r] = row
    end
end

function StepList:Refresh()
    if not frame or not frame:IsShown() then return end
    local snap = PP.snapshot
    if snap and snap.profession then
        frame.title:SetText(L["STEPLIST_TITLE"]:format(
            GetSpellInfo(snap.profession.professionSpellId) or "?",
            snap.profession.maxSkill))
    else
        frame.title:SetText(L["STEPLIST_TITLE"]:format("?", 450))
    end
    buildDisplayList(snap)
    updateRows()
end

function StepList:Show()
    if not frame then createFrame() end
    frame:Show()
    self:Refresh()
end

function StepList:Hide()
    if frame then frame:Hide() end
end

function StepList:Toggle()
    if frame and frame:IsShown() then self:Hide() else self:Show() end
end

StepList:RegisterMessage("PP_SNAPSHOT", function() StepList:Refresh() end)
StepList:RegisterMessage("PP_SETTINGS_CHANGED", function() StepList:Refresh() end)
