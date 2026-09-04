-- ProfessionPilot UI/MaterialList.lua
-- Shopping list with two views: current section and everything up to 450.
-- Shows need / bags / bank / missing per item, marks intermediates that have
-- to be crafted first, and can post the missing list to the chat frame.
--
-- GetItemInfo may return nil for items the client has never seen; rows then
-- show a placeholder, the cache is primed via a hidden tooltip and a short
-- timer re-renders once (3.3.5a has no GET_ITEM_INFO_RECEIVED event).

local PP = _G.ProfessionPilot
local L = PP.L

local MaterialList = {}
PP.UI.MaterialList = MaterialList
LibStub("AceEvent-3.0"):Embed(MaterialList)

local FRAME_NAME = "ProfessionPilotMatFrame"
local ROW_HEIGHT = 18
local NUM_ROWS = 14
local WIDTH = 512

local BACKDROP = {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 32, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
}

local frame
local mode = "total"  -- "current" | "total"

-- Expansion state per node path; nil falls back to the autoExpandTree option.
-- Session-local on purpose -- a /reload resets to the configured default.
local expandedOverride = {}

local function nodeSource()
    local snap = PP.snapshot
    if not snap or not snap.profession then return nil end
    if mode == "current" then
        return snap.tree
    end
    return snap.totals and snap.totals.entries or nil
end

local function isExpanded(path)
    local override = expandedOverride[path]
    if override ~= nil then return override end
    return PP.db.profile.autoExpandTree
end

-- Flatten the nested nodes honoring per-node expansion. Each list entry is
-- { node, depth, path }; the path key (parent item chain) survives recomputes.
local function currentEntries()
    local out = {}
    local src = nodeSource()
    if not src then return out end
    local function walk(nodes, depth, parentPath)
        for _, n in ipairs(nodes) do
            local path = parentPath .. ">" .. n.itemId
            out[#out + 1] = { node = n, depth = depth, path = path }
            if n.children and #n.children > 0 and isExpanded(path) then
                walk(n.children, depth + 1, path)
            end
        end
    end
    walk(src, 0, mode)
    return out
end

-- Prices are shown only for base materials (things you would buy); crafted
-- intermediates carry the "craft first" badge instead, so the sum never
-- double-counts an intermediate plus its expanded ingredients.
--
-- The PP.GetPriceSourceName/GetItemPrice existence checks are deliberate:
-- files newly added to the TOC only load after a full client RESTART, while
-- /reload re-runs existing files. Without the guard, a /reload right after
-- an update would error out here and blank the whole list.
local function priceEnabled()
    return PP.db.profile.showPrices
        and PP.GetPriceSourceName ~= nil
        and PP:GetPriceSourceName() ~= nil
end

local function missingCost(e)
    if e.missing <= 0 or e.craftedBy or not PP.GetItemPrice then return nil end
    local unit = PP:GetItemPrice(e.itemId)
    return unit and unit * e.missing or nil
end

local function updateRows()
    local entries = currentEntries()
    local offset = FauxScrollFrame_GetOffset(frame.scroll)
    local showPrices = priceEnabled()
    local Crafter = PP.GetModule and PP:GetModule("Crafter", true)

    for r = 1, NUM_ROWS do
        local row = frame.rows[r]
        local w = entries[offset + r]
        if w then
            local n = w.node
            row.wrapper = w
            row.itemId = n.itemId
            row.icon:ClearAllPoints()
            row.icon:SetPoint("LEFT", w.depth * 14, 0)
            row.icon:SetTexture(GetItemIcon(n.itemId))

            local prefix = ""
            if n.children and #n.children > 0 then
                prefix = isExpanded(w.path)
                    and "|cffffd200[-]|r " or "|cffffd200[+]|r "
            end
            local badge = ""
            if n.crafts then
                badge = " |cff88ccff(" .. L["CRAFT_FIRST_N"]:format(n.crafts) .. ")|r"
            elseif n.craftedBy then
                badge = " |cff88ccff(" .. L["CRAFT_FIRST"] .. ")|r"
            end
            local buy = PP.advice and PP.advice.buys and PP.advice.buys[n.itemId]
            if buy and buy.verdict == "buy" then
                badge = badge .. " |cffffd200" .. L["ADVICE_BUY"] .. "|r"
            end
            row.name:SetText(prefix .. PP:GetItemName(n.itemId) .. badge)

            row.need:SetText(n.need)
            row.bags:SetText(n.bags or 0)
            row.bank:SetText(n.bank or 0)
            row.missing:SetText(n.missing)
            if n.missing > 0 then
                row.missing:SetTextColor(1, 0.35, 0.35)
            else
                row.missing:SetTextColor(0.3, 1, 0.3)
            end

            if showPrices then
                local cost = missingCost(n)
                row.cost:SetText(cost and PP.util.FormatMoney(cost)
                    or (n.missing > 0 and not n.craftedBy and "-" or ""))
            else
                row.cost:SetText("")
            end

            -- Craftable dependency -> inline craft button (both views).
            if n.crafts and Crafter then
                row.cost:SetText("")
                row.craftBtn.entry = n
                local state, available = Crafter:GetRecipeState(n.craftedBy)
                if state == "ready" and available == 0 then
                    row.craftBtn:Disable()
                else
                    row.craftBtn:Enable()
                end
                row.craftBtn:Show()
            else
                row.craftBtn:Hide()
            end
            row:Show()
        else
            row.wrapper = nil
            row:Hide()
        end
    end

    FauxScrollFrame_Update(frame.scroll, #entries, NUM_ROWS, ROW_HEIGHT)

    frame.costHeader:SetText(showPrices and L["COL_COST"] or "")
    if showPrices then
        local total = 0
        local src = nodeSource()
        if src then
            PP.Calc.WalkTree(src, function(n)
                total = total + (missingCost(n) or 0)
            end)
        end
        frame.totalCost:SetText(L["TOTAL_COST"]:format(
            PP.util.FormatMoney(total), PP:GetPriceSourceName() or "?"))
    else
        frame.totalCost:SetText("")
    end

    -- (SetShown does not exist on 3.3.5a)
    if PP.db.profile.includeBank and not PP.db.char.bankScanned then
        frame.bankHint:Show()
    else
        frame.bankHint:Hide()
    end

    local CQ = PP.GetModule and PP:GetModule("CraftQueue", true)
    if frame.queueBtn then
        frame.queueBtn:SetText(CQ and CQ:IsRunning()
            and L["BTN_QUEUE_STOP"] or L["BTN_QUEUE_START"])
        if CQ then frame.queueBtn:Enable() else frame.queueBtn:Disable() end
    end
end

local function setMode(newMode)
    mode = newMode
    frame.tabCurrent:SetAlpha(mode == "current" and 1 or 0.55)
    frame.tabTotal:SetAlpha(mode == "total" and 1 or 0.55)
    FauxScrollFrame_SetOffset(frame.scroll, 0)
    updateRows()
end

-- Exports the FULL tree (independent of expansion state), indented.
local function exportToChat()
    local src = nodeSource()
    local lines = {}
    if src then
        local function walk(nodes, indent)
            for _, n in ipairs(nodes) do
                if n.missing > 0 then
                    local name = GetItemInfo(n.itemId) or ("item:" .. n.itemId)
                    local badge = n.craftedBy
                        and (" (" .. L["CRAFT_FIRST"] .. ")") or ""
                    lines[#lines + 1] = ("  %s%dx %s%s")
                        :format(indent, n.missing, name, badge)
                end
                if n.children then
                    walk(n.children, indent .. "   ")
                end
            end
        end
        walk(src, "")
    end
    if #lines == 0 then
        PP:Print(L["EXPORT_EMPTY"])
        return
    end
    PP:Print(L["EXPORT_HEADER"])
    for _, line in ipairs(lines) do
        DEFAULT_CHAT_FRAME:AddMessage(line)
    end
    if priceEnabled() and src then
        local total = 0
        PP.Calc.WalkTree(src, function(n)
            total = total + (missingCost(n) or 0)
        end)
        if total > 0 then
            DEFAULT_CHAT_FRAME:AddMessage("  " .. L["TOTAL_COST"]:format(
                PP.util.FormatMoney(total), PP:GetPriceSourceName() or "?"))
        end
    end
end

-- Shift-click links the item; a plain click on a craftable row drills one
-- level down (or back up) in the tree.
local function rowClick(row)
    local w = row.wrapper
    if not w then return end
    if IsShiftKeyDown() then
        local _, link = GetItemInfo(w.node.itemId)
        if link then
            ChatEdit_InsertLink(link)
        end
        return
    end
    if w.node.children and #w.node.children > 0 then
        expandedOverride[w.path] = not isExpanded(w.path)
        updateRows()
    end
end

-- Craft button on tree rows of craftable intermediates. Same two-stage
-- behavior as the main window button: closed window -> open profession,
-- open window -> craft (left 1x, right the needed amount).
local function rowCraftClick(btn, mouseButton)
    local Crafter = PP:GetModule("Crafter", true)
    local e = btn.entry
    if not Crafter or not e or not e.craftedBy then return end
    local state = Crafter:GetRecipeState(e.craftedBy)
    if state == "closed" then
        Crafter:OpenProfession()
    else
        Crafter:CraftRecipe(e.craftedBy,
            mouseButton == "RightButton" and (e.crafts or 1) or 1)
    end
end

local function rowCraftTooltip(btn)
    if not PP.db.profile.tooltips then return end
    GameTooltip:SetOwner(btn, "ANCHOR_RIGHT")
    GameTooltip:AddLine(L["BTN_CRAFT"], 1, 0.82, 0)
    local Crafter = PP:GetModule("Crafter", true)
    local e = btn.entry
    if Crafter and e and Crafter:GetRecipeState(e.craftedBy) == "closed" then
        GameTooltip:AddLine(L["BTN_OPEN_PROF"], 0.9, 0.9, 0.9)
    else
        GameTooltip:AddLine(L["CRAFT_TT_LEFT"], 0.9, 0.9, 0.9)
        GameTooltip:AddLine(L["CRAFT_TT_RIGHT"], 0.9, 0.9, 0.9)
    end
    GameTooltip:Show()
end

local function rowTooltip(row)
    if not PP.db.profile.tooltips or not row.itemId then return end
    GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
    GameTooltip:SetHyperlink("item:" .. row.itemId)
    local buy = PP.advice and PP.advice.buys and PP.advice.buys[row.itemId]
    if buy and buy.verdict == "buy" and PP.util.FormatMoney(buy.saving) then
        GameTooltip:AddLine(L["ADVICE_BUY_TT"]:format(
            PP.util.FormatMoney(buy.saving)), 1, 0.82, 0, true)
    end
    -- Mining info: how bar materials are smelted (informational only).
    local smelt = PP.SmeltData and PP.SmeltData.Get and PP.SmeltData.Get(row.itemId)
    if smelt then
        if smelt.components then
            local parts = {}
            for i = 1, #smelt.components do
                local c = smelt.components[i]
                parts[#parts + 1] = c.amount .. "x " .. PP:GetItemName(c.itemId)
            end
            GameTooltip:AddLine(L["SMELT_FROM_COMBO"]:format(
                table.concat(parts, " + "), smelt.miningSkill), 0.6, 0.8, 1, true)
            if (smelt.numMade or 1) > 1 then
                GameTooltip:AddLine(L["SMELT_YIELD"]:format(smelt.numMade),
                    0.6, 0.8, 1)
            end
        else
            GameTooltip:AddLine(L["SMELT_FROM"]:format(smelt.orePerBar,
                PP:GetItemName(smelt.oreItemId), smelt.miningSkill),
                0.6, 0.8, 1, true)
        end
    end
    -- Alt roster: what the player's other characters own of this material.
    if PP.db.profile.showRoster then
        local RosterStore = PP:GetModule("RosterStore", true)
        if RosterStore and RosterStore.GetOthers then
            local total, breakdown = RosterStore:GetOthers(row.itemId)
            if total > 0 and breakdown then
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine(L["ROSTER_TT_HEADER"]:format(total), 1, 0.82, 0)
                for i = 1, #breakdown do
                    GameTooltip:AddLine(L["ROSTER_TT_LINE"]:format(
                        breakdown[i].name, breakdown[i].count), 0.8, 0.8, 0.8)
                end
            end
        end
    end
    GameTooltip:Show()
end

local function createFrame()
    frame = CreateFrame("Frame", FRAME_NAME, UIParent)
    frame:SetWidth(WIDTH)
    frame:SetHeight(NUM_ROWS * ROW_HEIGHT + 110)
    frame:SetBackdrop(BACKDROP)
    frame:SetBackdropColor(0, 0, 0, 0.92)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    frame:SetClampedToScreen(true)
    frame:SetPoint("CENTER", UIParent, "CENTER", 40, -40)
    tinsert(UISpecialFrames, FRAME_NAME)

    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", 0, 0)

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.title:SetPoint("TOPLEFT", 10, -8)
    frame.title:SetText(L["MATLIST_TITLE"])

    local function makeTab(text, x, m)
        local b = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        b:SetWidth(130)
        b:SetHeight(20)
        b:SetPoint("TOPLEFT", x, -26)
        b:SetText(text)
        b:SetScript("OnClick", function() setMode(m) end)
        return b
    end
    frame.tabCurrent = makeTab(L["TAB_CURRENT"], 10, "current")
    frame.tabTotal = makeTab(L["TAB_TOTAL"], 144, "total")

    -- Column headers
    local header = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    header:SetPoint("TOPLEFT", 34, -52)
    header:SetText("")  -- item column has no caption; numbers get theirs below

    local function colHeader(text, rightOffset)
        local fs = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        fs:SetPoint("TOPRIGHT", rightOffset, -52)
        fs:SetText(text)
        return fs
    end
    frame.costHeader = colHeader("", -34)  -- text set in updateRows
    colHeader(L["COL_MISSING"], -106)
    colHeader(L["COL_BANK"], -160)
    colHeader(L["COL_BAGS"], -210)
    colHeader(L["COL_NEED"], -264)

    frame.scroll = CreateFrame("ScrollFrame", FRAME_NAME .. "Scroll", frame,
        "FauxScrollFrameTemplate")
    frame.scroll:SetPoint("TOPLEFT", 8, -66)
    frame.scroll:SetPoint("BOTTOMRIGHT", -28, 44)
    frame.scroll:SetScript("OnVerticalScroll", function(self, delta)
        FauxScrollFrame_OnVerticalScroll(self, delta, ROW_HEIGHT, updateRows)
    end)

    frame.rows = {}
    for r = 1, NUM_ROWS do
        local row = CreateFrame("Button", nil, frame)
        row:SetHeight(ROW_HEIGHT)
        row:SetPoint("TOPLEFT", 12, -66 - (r - 1) * ROW_HEIGHT)
        row:SetPoint("RIGHT", frame, "RIGHT", -30, 0)
        row:SetScript("OnClick", rowClick)
        row:SetScript("OnEnter", rowTooltip)
        row:SetScript("OnLeave", function() GameTooltip:Hide() end)

        row.icon = row:CreateTexture(nil, "ARTWORK")
        row.icon:SetWidth(14)
        row.icon:SetHeight(14)
        row.icon:SetPoint("LEFT", 0, 0)

        row.cost = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        row.cost:SetPoint("RIGHT", -4, 0)
        row.cost:SetWidth(72)
        row.cost:SetJustifyH("RIGHT")

        -- Occupies the cost cell; intermediates never show a price there.
        row.craftBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
        row.craftBtn:SetWidth(72)
        row.craftBtn:SetHeight(16)
        row.craftBtn:SetPoint("RIGHT", -2, 0)
        row.craftBtn:SetNormalFontObject("GameFontNormalSmall")
        row.craftBtn:SetHighlightFontObject("GameFontHighlightSmall")
        row.craftBtn:SetDisabledFontObject("GameFontDisableSmall")
        row.craftBtn:SetText(L["BTN_CRAFT"])
        row.craftBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
        row.craftBtn:SetScript("OnClick", rowCraftClick)
        row.craftBtn:SetScript("OnEnter", rowCraftTooltip)
        row.craftBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
        row.craftBtn:Hide()

        row.missing = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        row.missing:SetPoint("RIGHT", -80, 0)
        row.missing:SetWidth(44)
        row.missing:SetJustifyH("RIGHT")

        row.bank = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        row.bank:SetPoint("RIGHT", -130, 0)
        row.bank:SetWidth(44)
        row.bank:SetJustifyH("RIGHT")

        row.bags = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        row.bags:SetPoint("RIGHT", -180, 0)
        row.bags:SetWidth(44)
        row.bags:SetJustifyH("RIGHT")

        row.need = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        row.need:SetPoint("RIGHT", -234, 0)
        row.need:SetWidth(44)
        row.need:SetJustifyH("RIGHT")

        row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        row.name:SetPoint("LEFT", row.icon, "RIGHT", 4, 0)
        row.name:SetPoint("RIGHT", row.need, "LEFT", -6, 0)
        row.name:SetJustifyH("LEFT")

        frame.rows[r] = row
    end

    frame.totalCost = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.totalCost:SetPoint("BOTTOMLEFT", 10, 12)
    frame.totalCost:SetTextColor(1, 0.82, 0)

    frame.bankHint = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.bankHint:SetPoint("BOTTOMLEFT", 10, 26)
    frame.bankHint:SetText(L["BANK_NOT_SCANNED"])
    frame.bankHint:SetTextColor(1, 0.6, 0.2)

    local export = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    export:SetWidth(160)
    export:SetHeight(20)
    export:SetPoint("BOTTOMRIGHT", -8, 8)
    export:SetText(L["EXPORT_CHAT"])
    export:SetScript("OnClick", exportToChat)

    -- Craft queue: works through all missing intermediates bottom-up.
    local queueBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    queueBtn:SetWidth(150)
    queueBtn:SetHeight(20)
    queueBtn:SetPoint("RIGHT", export, "LEFT", -4, 0)
    queueBtn:SetText(L["BTN_QUEUE_START"])
    queueBtn:SetScript("OnClick", function()
        local CQ = PP:GetModule("CraftQueue", true)
        if CQ then CQ:Toggle() end  -- nil until client restart after update
    end)
    frame.queueBtn = queueBtn
end

function MaterialList:Refresh()
    if not frame or not frame:IsShown() then return end
    updateRows()
end

function MaterialList:Show()
    if not frame then
        createFrame()
        setMode(mode)
    end
    frame:Show()
    self:Refresh()
end

function MaterialList:Hide()
    if frame then frame:Hide() end
end

function MaterialList:Toggle()
    if frame and frame:IsShown() then self:Hide() else self:Show() end
end

MaterialList:RegisterMessage("PP_SNAPSHOT", function() MaterialList:Refresh() end)
MaterialList:RegisterMessage("PP_ADVICE", function() MaterialList:Refresh() end)
MaterialList:RegisterMessage("PP_QUEUE_STATE", function() MaterialList:Refresh() end)
MaterialList:RegisterMessage("PP_SETTINGS_CHANGED", function()
    -- The autoExpandTree default changed (or a reset happened): drop the
    -- per-node overrides so the new default applies everywhere.
    for k in pairs(expandedOverride) do expandedOverride[k] = nil end
    MaterialList:Refresh()
end)
