-- ProfessionPilot UI/MerchantBar.lua
-- Kaufleiste unter dem Haendlerfenster. Ein Knopf kauft die fehlenden
-- Basismaterialien, die dieser Haendler fuehrt: Linksklick fuer den
-- aktuellen Abschnitt, Rechtsklick fuer die Gesamtansicht. Die Leiste zeigt
-- nur MerchantBuyer:GetPlan an; gekauft wird im Modul.

local PP = _G.ProfessionPilot
local L = PP.L

local MerchantBar = {}
PP.UI.MerchantBar = MerchantBar
LibStub("AceEvent-3.0"):Embed(MerchantBar)

-- Sichtbarer Bereich des 3.3.5a-Haendlerfensters: 11 px links, 32 px rechts
-- (ElvUI bildet ihn mit genau diesen Werten als Backdrop nach, siehe
-- ElvUI/Modules/Skins/Blizzard/Merchant.lua). Die Reiter Haendler/Rueckkauf
-- haengen unten heraus (Mitte 62 px ueber der Rahmenunterkante), die Leiste
-- sitzt deshalb darunter.
local INSET_LEFT, INSET_RIGHT, BAR_TOP = 11, 32, 44
-- Zwei Zeilen Summentext (Abschnitt / Gesamt): neben dem 130-px-Knopf
-- bleiben ~190 px, einzeilig passen groessere Goldbetraege nicht hinein.
local BAR_HEIGHT = 36

local BACKDROP = {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 32, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
}

local bar

-- MerchantBuyer ist eine neue TOC-Datei: nach einem Update ohne
-- Client-Neustart fehlt das Modul, die Leiste bleibt dann einfach aus.
local function buyer()
    return PP.GetModule and PP:GetModule("MerchantBuyer", true)
end

local function money(copper)
    return PP.util.FormatMoney(copper) or "-"
end

local function hasContent(plan)
    return #plan.items > 0 or #plan.skipped > 0
end

local function planText(plan)
    return #plan.items > 0 and money(plan.total) or "-"
end

-- Tooltip-Block fuer einen Plan: Menge und Kosten je Item, Summe, danach
-- die Hinweise (Vorrat, Gold, Sonderwaehrung).
local function addPlan(title, plan)
    GameTooltip:AddLine(title, 1, 0.82, 0)
    if not hasContent(plan) then
        GameTooltip:AddLine(L["BUY_TT_NOTHING"], 0.6, 0.6, 0.6)
        return
    end
    for _, it in ipairs(plan.items) do
        GameTooltip:AddDoubleLine(it.count .. "x " .. PP:GetItemName(it.itemId),
            money(it.cost), 1, 1, 1, 1, 1, 1)
    end
    if #plan.items > 1 then
        GameTooltip:AddDoubleLine(" ", money(plan.total), 1, 1, 1, 1, 0.82, 0)
    end
    local notes = PP.Shopping.Notes(plan)
    for _, n in ipairs(notes) do
        GameTooltip:AddLine(L["BUY_NOTE_" .. n.kind:upper()]:format(
            PP:GetItemName(n.itemId), n.count), 1, 0.5, 0.25, true)
    end
end

local function showTooltip(btn)
    local MB = buyer()
    if not MB or not PP.db.profile.tooltips then return end
    GameTooltip:SetOwner(btn, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:AddLine("ProfessionPilot", 1, 1, 1)
    addPlan(L["BUY_TT_LEFT"], MB:GetPlan("current"))
    GameTooltip:AddLine(" ")
    addPlan(L["BUY_TT_RIGHT"]:format(L["TAB_TOTAL"]), MB:GetPlan("total"))
    GameTooltip:Show()
end

local function onClick(_, mouseButton)
    local MB = buyer()
    if not MB then return end
    GameTooltip:Hide()
    MB:Buy(mouseButton == "RightButton" and "total" or "current")
end

local function createBar()
    bar = CreateFrame("Frame", "ProfessionPilotMerchantBar", MerchantFrame)
    bar:SetHeight(BAR_HEIGHT)
    bar:SetPoint("TOPLEFT", MerchantFrame, "BOTTOMLEFT", INSET_LEFT, BAR_TOP)
    bar:SetPoint("TOPRIGHT", MerchantFrame, "BOTTOMRIGHT", -INSET_RIGHT, BAR_TOP)
    bar:SetBackdrop(BACKDROP)
    bar:SetBackdropColor(0, 0, 0, 0.92)

    local btn = CreateFrame("Button", nil, bar, "UIPanelButtonTemplate")
    btn:SetWidth(130)
    btn:SetHeight(20)
    btn:SetPoint("LEFT", 6, 0)
    btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    btn:SetScript("OnClick", onClick)
    btn:SetScript("OnEnter", showTooltip)
    btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    bar.btn = btn

    bar.summary = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    bar.summary:SetPoint("LEFT", btn, "RIGHT", 8, 0)
    bar.summary:SetPoint("RIGHT", -8, 0)
    bar.summary:SetJustifyH("LEFT")
end

-- Sichtbar nur bei offenem Haendler, eingeschalteter Option und wenn einer
-- der beiden Plaene etwas enthaelt (auch nur Hinweise wie "zu wenig
-- Gold") oder gerade ein Kauf laeuft.
function MerchantBar:Refresh()
    local MB = buyer()
    local cur, tot
    local show = MB and MB:IsOpen() and PP.db and PP.db.profile.merchantBar
    if show then
        cur, tot = MB:GetPlan("current"), MB:GetPlan("total")
        show = MB:IsBusy() or hasContent(cur) or hasContent(tot)
    end
    if not show then
        if bar then bar:Hide() end
        return
    end
    if not bar then createBar() end

    if MB:IsBusy() then
        bar.btn:SetText(L["BUY_BUSY"])
        bar.btn:Disable()
    else
        bar.btn:SetText(L["BTN_BUY_MISSING"])
        bar.btn:Enable()
    end
    bar.summary:SetText(L["BUY_SUMMARY"]:format(
        planText(cur), L["TAB_TOTAL"], planText(tot)))
    bar:Show()
end

MerchantBar:RegisterMessage("PP_MERCHANT_STATE", function() MerchantBar:Refresh() end)
MerchantBar:RegisterMessage("PP_SNAPSHOT", function() MerchantBar:Refresh() end)
MerchantBar:RegisterMessage("PP_SETTINGS_CHANGED", function() MerchantBar:Refresh() end)
