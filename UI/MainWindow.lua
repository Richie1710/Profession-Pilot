-- ProfessionPilot UI/MainWindow.lua
-- Compact tracker window: current skill, active section, next craft with
-- recipe status, progress bar, remaining crafts and material lines.
-- Renders only on PP_SNAPSHOT messages -- no OnUpdate polling.

local PP = _G.ProfessionPilot
local L = PP.L

local MainWindow = {}
PP.UI.MainWindow = MainWindow
LibStub("AceEvent-3.0"):Embed(MainWindow)

local FRAME_NAME = "ProfessionPilotMainFrame"
local WIDTH = 300
local MAX_MAT_ROWS = 6

local BACKDROP = {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 32, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
}

local COLOR = {
    green  = { 0.3, 1.0, 0.3 },
    red    = { 1.0, 0.35, 0.35 },
    yellow = { 1.0, 0.95, 0.45 },
    orange = { 1.0, 0.6, 0.2 },
    gold   = { 1.0, 0.82, 0.0 },
    white  = { 1.0, 1.0, 1.0 },
    gray   = { 0.6, 0.6, 0.6 },
}

local frame

local function savePosition()
    local point, _, relPoint, x, y = frame:GetPoint(1)
    PP.db.profile.window[FRAME_NAME] = { point = point, relPoint = relPoint, x = x, y = y }
end

local function restorePosition()
    local pos = PP.db.profile.window[FRAME_NAME]
    frame:ClearAllPoints()
    if pos then
        frame:SetPoint(pos.point, UIParent, pos.relPoint, pos.x, pos.y)
    else
        frame:SetPoint("CENTER", UIParent, "CENTER", 220, 60)
    end
end

local function itemTooltip(row)
    if not PP.db.profile.tooltips or not row.itemId then return end
    GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
    GameTooltip:SetHyperlink("item:" .. row.itemId)
    GameTooltip:Show()
end

local function createFrame()
    frame = CreateFrame("Frame", FRAME_NAME, UIParent)
    frame:SetWidth(WIDTH)
    frame:SetHeight(260)
    frame:SetBackdrop(BACKDROP)
    frame:SetBackdropColor(0, 0, 0, 0.9)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self)
        if not PP.db.profile.locked then self:StartMoving() end
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        savePosition()
    end)
    frame:SetClampedToScreen(true)
    tinsert(UISpecialFrames, FRAME_NAME)
    -- ESC (CloseSpecialWindows) hides the frame directly, bypassing
    -- MainWindow:Hide() -- track the open state in OnHide instead.
    frame:SetScript("OnHide", function()
        if PP.db then PP.db.profile.window.mainShown = false end
    end)

    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", 0, 0)
    close:SetScript("OnClick", function() MainWindow:Hide() end)

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.title:SetPoint("TOPLEFT", 10, -8)
    frame.title:SetText(L["MAIN_TITLE"])

    frame.skill = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.skill:SetPoint("TOPRIGHT", -28, -9)

    frame.section = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.section:SetPoint("TOPLEFT", 10, -26)
    frame.section:SetTextColor(unpack(COLOR.gold))

    frame.icon = frame:CreateTexture(nil, "ARTWORK")
    frame.icon:SetWidth(24)
    frame.icon:SetHeight(24)
    frame.icon:SetPoint("TOPLEFT", 10, -42)

    frame.nextName = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.nextName:SetPoint("TOPLEFT", frame.icon, "TOPRIGHT", 6, -1)
    frame.nextName:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
    frame.nextName:SetJustifyH("LEFT")

    frame.recipeStatus = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.recipeStatus:SetPoint("TOPLEFT", frame.icon, "TOPRIGHT", 6, -14)
    frame.recipeStatus:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
    frame.recipeStatus:SetJustifyH("LEFT")

    frame.bar = CreateFrame("StatusBar", nil, frame)
    frame.bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    frame.bar:SetStatusBarColor(0.25, 0.78, 0.25)
    frame.bar:SetHeight(14)
    frame.bar:SetPoint("TOPLEFT", 10, -74)
    frame.bar:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
    frame.bar.bg = frame.bar:CreateTexture(nil, "BACKGROUND")
    frame.bar.bg:SetAllPoints()
    frame.bar.bg:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
    frame.bar.bg:SetVertexColor(0.15, 0.15, 0.15, 0.8)
    frame.bar.text = frame.bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    frame.bar.text:SetPoint("CENTER")

    frame.crafts = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.crafts:SetPoint("TOPLEFT", 10, -92)
    frame.crafts:SetTextColor(unpack(COLOR.white))

    local craftBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    craftBtn:SetWidth(110)
    craftBtn:SetHeight(18)
    craftBtn:SetPoint("TOPRIGHT", -10, -90)
    craftBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    craftBtn:SetScript("OnClick", function(self, button)
        local Crafter = PP:GetModule("Crafter", true)
        if not Crafter then return end
        if self.state == "closed" then
            Crafter:OpenProfession()
        elseif self.state == "ready" then
            Crafter:CraftCurrent(button == "RightButton" and -1 or 1)
        end
    end)
    craftBtn:SetScript("OnEnter", function(self)
        if not PP.db.profile.tooltips or self.state ~= "ready" then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(L["BTN_CRAFT"], 1, 0.82, 0)
        GameTooltip:AddLine(L["CRAFT_TT_LEFT"], 0.9, 0.9, 0.9)
        GameTooltip:AddLine(L["CRAFT_TT_RIGHT"], 0.9, 0.9, 0.9)
        GameTooltip:Show()
    end)
    craftBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    frame.craftBtn = craftBtn

    frame.matRows = {}
    for i = 1, MAX_MAT_ROWS do
        local row = CreateFrame("Frame", nil, frame)
        row:SetHeight(14)
        row:SetPoint("TOPLEFT", 12, -108 - (i - 1) * 15)
        row:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
        row:EnableMouse(true)
        row:SetScript("OnEnter", itemTooltip)
        row:SetScript("OnLeave", function() GameTooltip:Hide() end)

        row.icon = row:CreateTexture(nil, "ARTWORK")
        row.icon:SetWidth(12)
        row.icon:SetHeight(12)
        row.icon:SetPoint("LEFT", 0, 0)

        row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        row.name:SetPoint("LEFT", row.icon, "RIGHT", 4, 0)
        row.name:SetJustifyH("LEFT")

        row.count = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        row.count:SetPoint("RIGHT", 0, 0)
        row.name:SetPoint("RIGHT", row.count, "LEFT", -4, 0)

        frame.matRows[i] = row
    end

    frame.forecast = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.forecast:SetPoint("BOTTOMLEFT", 10, 46)
    frame.forecast:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
    frame.forecast:SetJustifyH("LEFT")
    frame.forecast:SetTextColor(1, 0.82, 0)

    frame.note = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.note:SetPoint("BOTTOMLEFT", 10, 32)
    frame.note:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
    frame.note:SetJustifyH("LEFT")

    local function makeButton(text, xOff, onClick)
        local b = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        b:SetWidth(88)
        b:SetHeight(20)
        b:SetPoint("BOTTOMLEFT", xOff, 8)
        b:SetText(text)
        b:SetScript("OnClick", onClick)
        return b
    end
    makeButton(L["BTN_STEPS"], 10, function() PP.UI.StepList:Toggle() end)
    makeButton(L["BTN_MATS"], 106, function() PP.UI.MaterialList:Toggle() end)
    makeButton(L["BTN_OPTIONS"], 202, function() PP.UI.Options:Open() end)

    MainWindow:ApplySettings()
    restorePosition()
end

function MainWindow:ApplySettings()
    if not frame then return end
    frame:SetScale(PP.db.profile.scale or 1)
    restorePosition()  -- also re-anchors after /pp reset cleared the profile
end

local function recipeStatusText(step, flags)
    if flags.recipeKnown then
        return L["RECIPE_KNOWN"], COLOR.green
    end
    if step.source == "vendor" then
        return L["RECIPE_VENDOR"], COLOR.orange
    end
    if step.source == "quest" then
        return L["RECIPE_QUEST"], COLOR.orange
    end
    if flags.recipeLearnable then
        return L["RECIPE_LEARNABLE"]:format(step.learnAtSkill), COLOR.yellow
    end
    return L["RECIPE_NOT_YET"]:format(step.learnAtSkill), COLOR.red
end

local function hideDetails()
    frame.section:SetText("")
    frame.icon:Hide()
    frame.nextName:SetText("")
    frame.recipeStatus:SetText("")
    frame.bar:Hide()
    frame.crafts:SetText("")
    frame.forecast:SetText("")
    frame.craftBtn:Hide()
    for i = 1, MAX_MAT_ROWS do frame.matRows[i]:Hide() end
end

-- Estimated auction-house cost of everything still missing (base materials
-- only -- intermediates are covered by their expanded ingredients).
local function updateForecast()
    frame.forecast:SetText("")
    if not PP.db.profile.showPrices or not PP.GetPriceSourceName
        or not PP:GetPriceSourceName() then
        return
    end
    local snap = PP.snapshot
    if not snap or not snap.profession then return end

    local total = 0
    PP.Calc.WalkTree(snap.totals.entries, function(n)
        if n.missing > 0 and not n.craftedBy then
            local unit = PP:GetItemPrice(n.itemId)
            if unit then total = total + unit * n.missing end
        end
    end)
    if total > 0 then
        frame.forecast:SetText(L["TOTAL_COST"]:format(
            PP.util.FormatMoney(total), PP:GetPriceSourceName() or "?"))
    end
end

-- Crafter is an optional module (a fresh /reload without a client restart
-- would run this file but not a newly added module file).
local function updateCraftButton()
    local btn = frame.craftBtn
    local Crafter = PP:GetModule("Crafter", true)
    if not Crafter then
        btn:Hide()
        return
    end

    local state, available = Crafter:GetState()
    btn.state = state
    if state == "hidden" then
        btn:Hide()
    elseif state == "unknown" then
        btn:SetText(L["BTN_CRAFT"])
        btn:Disable()
        btn:Show()
    elseif state == "closed" then
        btn:SetText(L["BTN_OPEN_PROF"])
        btn:Enable()
        btn:Show()
    else -- ready
        btn:SetText(L["BTN_CRAFT"] .. " (" .. available .. ")")
        if available > 0 then btn:Enable() else btn:Disable() end
        btn:Show()
    end
end

function MainWindow:Render()
    if not frame or not frame:IsShown() then return end
    local snap = PP.snapshot

    if not snap or not snap.profession then
        frame.title:SetText(L["MAIN_TITLE"])
        frame.skill:SetText("")
        hideDetails()
        local names = {}
        for _, prof in pairs(PP:GetProfessions()) do
            names[#names + 1] = GetSpellInfo(prof.professionSpellId) or prof.key
        end
        table.sort(names)
        frame.note:SetText(L["NO_PROFESSION"]:format(table.concat(names, ", ")))
        frame.note:SetTextColor(unpack(COLOR.white))
        return
    end

    local prof = snap.profession
    frame.title:SetText(GetSpellInfo(prof.professionSpellId) or L["MAIN_TITLE"])
    frame.skill:SetText(L["SKILL_LABEL"]:format(snap.skill, prof.maxSkill))

    if not snap.currentIndex then
        hideDetails()
        frame.note:SetText(L["DONE_ALL"])
        frame.note:SetTextColor(unpack(COLOR.green))
        return
    end

    local step = prof.steps[snap.currentIndex]
    local info = snap.steps[snap.currentIndex]

    frame.section:SetText(L["SECTION_LABEL"]:format(step.minSkill, step.maxSkill))

    local name, _, icon = GetSpellInfo(step.recipeSpellId)
    frame.icon:SetTexture(icon)
    frame.icon:Show()
    frame.nextName:SetText(L["NEXT_LABEL"] .. " " .. (name or "?"))

    local statusText, statusColor = recipeStatusText(step, info.flags)
    frame.recipeStatus:SetText(statusText)
    frame.recipeStatus:SetTextColor(unpack(statusColor))

    frame.bar:Show()
    frame.bar:SetMinMaxValues(step.minSkill, step.maxSkill)
    frame.bar:SetValue(math.max(snap.skill, step.minSkill))
    frame.bar.text:SetText(snap.skill .. " / " .. step.maxSkill)

    local craftsFmt = step.approximate and L["CRAFTS_REMAINING_APPROX"]
        or L["CRAFTS_REMAINING"]
    local craftsText = craftsFmt:format(info.remainingCrafts)
    if info.measured then
        craftsText = craftsText .. " " .. L["STATS_MEASURED_SUFFIX"]
    end
    frame.crafts:SetText(craftsText)

    updateCraftButton()
    updateForecast()

    for i = 1, MAX_MAT_ROWS do
        local row = frame.matRows[i]
        local mat = snap.currentMaterials[i]
        if mat then
            row.itemId = mat.itemId
            row.icon:SetTexture(GetItemIcon(mat.itemId))
            row.name:SetText(PP:GetItemName(mat.itemId))
            row.count:SetText(mat.have .. " / " .. mat.need)
            local c = mat.missing > 0 and COLOR.red or COLOR.green
            row.count:SetTextColor(unpack(c))
            row:Show()
        else
            row:Hide()
        end
    end

    local note
    local noteColor = COLOR.yellow
    local advice = PP.advice and PP.advice.alt
    if snap.rankWarning then
        note = L["RANK_WARNING"]
        noteColor = COLOR.red
    elseif advice then
        note = L["ADVICE_ALT_CHEAPER"]:format(
            GetSpellInfo(advice.spellId) or "?",
            PP.util.FormatMoney(advice.saving) or "?")
        noteColor = { 0.53, 0.8, 1 }
    elseif not info.flags.recipeKnown and not next(PP.db.char.knownRecipes) then
        note = L["RECIPE_UNKNOWN_HINT"]
    elseif step.notesKey then
        note = L[step.notesKey]
    elseif step.saveForLater then
        note = L["SAVE_FOR_LATER"]
    end
    frame.note:SetText(note or "")
    frame.note:SetTextColor(unpack(noteColor))
end

function MainWindow:Show()
    if not frame then createFrame() end
    frame:Show()
    PP.db.profile.window.mainShown = true
    self:Render()
end

function MainWindow:Hide()
    if frame then frame:Hide() end  -- OnHide script records the state
end

function MainWindow:Toggle()
    if frame and frame:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end

MainWindow:RegisterMessage("PP_SNAPSHOT", function()
    -- Reopen automatically after /reload or relog if it was open before.
    if not frame and PP.db and PP.db.profile.window.mainShown then
        MainWindow:Show()
        return
    end
    MainWindow:Render()
end)

MainWindow:RegisterMessage("PP_SETTINGS_CHANGED", function()
    MainWindow:ApplySettings()
    MainWindow:Render()
end)

MainWindow:RegisterMessage("PP_ADVICE", function() MainWindow:Render() end)
