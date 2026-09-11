-- ProfessionPilot Modules/MerchantBuyer.lua
-- Haendlerkauf: liest bei offenem Haendlerfenster das Sortiment, merkt sich
-- Stueckpreise von Berufsmaterialien accountweit (db.global.vendorPrices)
-- und kauft auf Klick die fehlende Menge ein. Die Rechenlogik liegt pure
-- in Core/Shopping.lua, die Leiste in UI/MerchantBar.lua.
--
-- 3.3.5a: BuyMerchantItem ist nicht geschuetzt, braucht also keinen
-- Hardware-Klick (StealYourCarbon kauft direkt aus MERCHANT_SHOW). Ein Kauf
-- landet erst nach der Serverantwort in den Taschen; bis MaterialTracker
-- die Ankunft gezaehlt hat, sperrt `pending` weitere Kaeufe (sonst wuerde
-- ein zweiter Klick dieselbe Menge noch einmal kaufen).

local PP = _G.ProfessionPilot
local L = PP.L
local MerchantBuyer = PP:NewModule("MerchantBuyer", "AceEvent-3.0", "AceTimer-3.0")

local BUY_TIMEOUT = 5  -- Sekunden bis die Sperre ohne Ankunft verfaellt

local interest = {}    -- [itemId] = true, alle Schritt-Materialien
local offers = {}      -- Angebote des offenen Haendlers (nur interest-Items)
local pending = {}     -- [itemId] = Ziel-Taschenbestand nach dem Kauf
local open = false
local timeoutTimer

local function buildInterest()
    for _, prof in pairs(PP:GetProfessions()) do
        for _, step in ipairs(prof.steps) do
            for _, m in ipairs(step.materials) do
                interest[m.itemId] = true
            end
        end
    end
end

-- Knoten des Snapshots je Umfang: "current" = aktueller Abschnitt
-- (snapshot.tree), sonst die Gesamtansicht (snapshot.totals).
local function scopeNodes(scope)
    local snap = PP.snapshot
    if not snap or not snap.profession then return nil end
    if scope == "current" then return snap.tree end
    return snap.totals and snap.totals.entries
end

function MerchantBuyer:OnEnable()
    buildInterest()
    self:RegisterEvent("MERCHANT_SHOW")
    self:RegisterEvent("MERCHANT_CLOSED")
    -- /reload bei offenem Haendler: das SHOW-Event ist dann schon vorbei.
    if MerchantFrame and MerchantFrame:IsShown() then
        self:MERCHANT_SHOW()
    end
end

function MerchantBuyer:IsOpen()
    return open
end

function MerchantBuyer:IsBusy()
    return next(pending) ~= nil
end

-- Sortiment lesen; Stueckpreise ohne Sonderwaehrung wandern in den
-- accountweiten Preis-Cache (unabhaengig von der Leisten-Option).
function MerchantBuyer:ScanOffers()
    offers = {}
    local prices = PP.db and PP.db.global.vendorPrices
    for i = 1, GetMerchantNumItems() do
        local itemId = PP.util.ItemIdFromLink(GetMerchantItemLink(i))
        if itemId and interest[itemId] then
            local _, _, price, quantity, numAvailable, _, extendedCost =
                GetMerchantItemInfo(i)
            local lot = (quantity and quantity > 0) and quantity or 1
            local maxStack = GetMerchantItemMaxStack(i)
            offers[#offers + 1] = {
                index = i, itemId = itemId, price = price or 0, lot = lot,
                available = numAvailable or -1,
                maxStack = (maxStack and maxStack > 0) and maxStack or 1,
                extendedCost = extendedCost and true or nil,
            }
            if prices and not extendedCost and price and price > 0 then
                prices[itemId] = price / lot
            end
        end
    end
end

-- Kaufplan fuer einen Umfang ("current" | "total"); leer, solange kein
-- Haendler offen ist. Bereits gekaufte, noch nicht gezaehlte Mengen werden
-- abgezogen.
function MerchantBuyer:GetPlan(scope)
    local S = PP.Shopping
    local outstanding = S.Outstanding(pending, PP.counts)
    return S.PlanPurchases(S.CollectMissing(scopeNodes(scope)), offers,
        { money = GetMoney(), outstanding = outstanding })
end

local function printNotes(plan)
    local notes = PP.Shopping.Notes(plan)
    for i = 1, #notes do
        local n = notes[i]
        PP:Print(L["BUY_NOTE_" .. n.kind:upper()]:format(
            PP:GetItemName(n.itemId), n.count))
    end
    return #notes
end

function MerchantBuyer:Buy(scope)
    if not open or self:IsBusy() then return end
    local plan = self:GetPlan(scope)
    if #plan.items == 0 then
        if printNotes(plan) == 0 then
            PP:Print(L["BUY_NOTHING"])
        end
        return
    end

    local parts = {}
    for _, item in ipairs(plan.items) do
        for _, n in ipairs(item.calls) do
            BuyMerchantItem(item.index, n)
        end
        local c = PP.counts[item.itemId]
        pending[item.itemId] = (c and c.bags or 0) + item.count
        parts[#parts + 1] = item.count .. "x " .. PP:GetItemName(item.itemId)
    end
    PP:Print(L["BUY_DONE"]:format(table.concat(parts, ", "),
        PP.util.FormatMoney(plan.total)))
    printNotes(plan)

    timeoutTimer = self:ScheduleTimer("OnBuyTimeout", BUY_TIMEOUT)
    self:RegisterMessage("PP_SNAPSHOT", "OnSnapshot")
    self:SendMessage("PP_MERCHANT_STATE")
end

function MerchantBuyer:ClearPending()
    for k in pairs(pending) do pending[k] = nil end
    if timeoutTimer then
        self:CancelTimer(timeoutTimer, true)
        timeoutTimer = nil
    end
    self:UnregisterMessage("PP_SNAPSHOT")
end

-- Jede Neuberechnung nach BAG_UPDATE: ist alles Gekaufte gezaehlt, faellt
-- die Sperre.
function MerchantBuyer:OnSnapshot()
    if not next(pending) then return end
    local _, any = PP.Shopping.Outstanding(pending, PP.counts)
    if not any then
        self:ClearPending()
        self:SendMessage("PP_MERCHANT_STATE")
    end
end

-- Kam der Kauf nicht (vollstaendig) an -- Taschen voll, Server lehnt ab --,
-- zeigt die Leiste nach dem Timeout einfach den echten Rest.
function MerchantBuyer:OnBuyTimeout()
    timeoutTimer = nil
    if next(pending) then
        self:ClearPending()
        self:SendMessage("PP_MERCHANT_STATE")
    end
end

function MerchantBuyer:MERCHANT_SHOW()
    open = true
    self:RegisterEvent("MERCHANT_UPDATE")
    self:RegisterEvent("PLAYER_MONEY")
    self:ScanOffers()
    self:SendMessage("PP_MERCHANT_STATE")
end

function MerchantBuyer:MERCHANT_UPDATE()
    if not open then return end
    self:ScanOffers()
    self:SendMessage("PP_MERCHANT_STATE")
end

function MerchantBuyer:PLAYER_MONEY()
    if open then self:SendMessage("PP_MERCHANT_STATE") end
end

-- 3.3.5a feuert MERCHANT_CLOSED teils doppelt; nur der erste zaehlt.
function MerchantBuyer:MERCHANT_CLOSED()
    if not open then return end
    open = false
    offers = {}
    self:ClearPending()
    self:UnregisterEvent("MERCHANT_UPDATE")
    self:UnregisterEvent("PLAYER_MONEY")
    self:SendMessage("PP_MERCHANT_STATE")
end
