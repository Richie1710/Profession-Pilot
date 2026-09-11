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
-- ein zweiter Klick dieselbe Menge noch einmal kaufen). Die Sperre faellt
-- bei Ankunft, kurz nach einer Serverablehnung (UI_ERROR_MESSAGE) oder per
-- Notbremse -- nie nach einer kurzen festen Zeit, die bei Lag einen
-- Doppelkauf erlauben wuerde. Kaeufe am Knopf vorbei (Blizzard-Fenster,
-- Auto-Restock-Addons) landen per BuyMerchantItem-Hook ebenfalls in
-- `pending`.

local PP = _G.ProfessionPilot
local L = PP.L
local MerchantBuyer = PP:NewModule("MerchantBuyer", "AceEvent-3.0", "AceTimer-3.0")

local BUY_TIMEOUT = 20  -- Notbremse: weder Ankunft noch Ablehnung
local ERROR_GRACE = 1   -- nach einer Ablehnung: Zeit fuer die Taschenzaehlung

-- Serverablehnungen eines Haendlerkaufs. Verglichen wird mit den globalen
-- Client-Strings (sprachunabhaengig); fehlt ein Name auf diesem Client,
-- wird er uebersprungen.
local BUY_ERRORS = {
    "ERR_INV_FULL", "ERR_ITEM_MAX_COUNT", "ERR_NOT_ENOUGH_MONEY",
    "ERR_VENDOR_SOLD_OUT", "ERR_VENDOR_TOO_FAR", "ERR_TOO_MUCH_GOLD",
}

local interest = {}    -- [itemId] = true, alle Schritt-Materialien
local offers = {}      -- Angebote des offenen Haendlers (nur interest-Items)
local pending = {}     -- [itemId] = Ziel-Taschenbestand nach dem Kauf
local open = false
local timeoutTimer
local ownBuy = false   -- true, solange Buy() selbst BuyMerchantItem aufruft
local hooked = false

local function buildInterest()
    for _, prof in pairs(PP:GetProfessions()) do
        for _, step in ipairs(prof.steps) do
            for _, m in ipairs(step.materials) do
                interest[m.itemId] = true
            end
        end
    end
end

local function isBuyError(msg)
    for i = 1, #BUY_ERRORS do
        local text = _G[BUY_ERRORS[i]]
        if text and msg == text then return true end
    end
    return false
end

-- Knoten des Snapshots je Umfang: "current" = aktueller Abschnitt
-- (snapshot.tree), sonst die Gesamtansicht (snapshot.totals).
local function scopeNodes(scope)
    local snap = PP.snapshot
    if not snap or not snap.profession then return nil end
    if scope == "current" then return snap.tree end
    return snap.totals and snap.totals.entries
end

-- Kaeufe am Knopf vorbei (Blizzard-Haendlerfenster, Auto-Restock wie
-- StealYourCarbon): ohne Eintrag in `pending` wuerde der naechste Klick
-- sie aus den noch veralteten Zaehlungen ein zweites Mal kaufen. Das Item
-- wird direkt am Haendler-Index nachgeschlagen -- ein Auto-Restock kann
-- vor unserem eigenen MERCHANT_SHOW laufen.
local function onBuyMerchantItem(index, n)
    if ownBuy then return end
    local itemId = PP.util.ItemIdFromLink(GetMerchantItemLink(index))
    if not itemId or not interest[itemId] then return end
    local _, _, _, quantity = GetMerchantItemInfo(index)
    -- Bei Buendelware ist n uneinheitlich (Stueck oder Buendel): ein Buendel
    -- annehmen -- lieber frueher entsperren als die Notbremse abwarten.
    local amount = (quantity and quantity > 1) and quantity or (n or 1)
    MerchantBuyer:AddPending(itemId, amount)
    MerchantBuyer:ArmLock()
end

function MerchantBuyer:OnEnable()
    buildInterest()
    self:RegisterEvent("MERCHANT_SHOW")
    self:RegisterEvent("MERCHANT_CLOSED")
    if not hooked and hooksecurefunc then
        hooksecurefunc("BuyMerchantItem", onBuyMerchantItem)
        hooked = true
    end
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

-- Gekaufte Menge vormerken: Ziel = Taschenbestand vor dem ersten offenen
-- Kauf plus alles, was seitdem gekauft wurde.
function MerchantBuyer:AddPending(itemId, amount)
    local c = PP.counts[itemId]
    pending[itemId] = (pending[itemId] or (c and c.bags or 0)) + amount
end

-- Sperre scharf machen bzw. fuer einen weiteren Kauf verlaengern.
function MerchantBuyer:ArmLock()
    if timeoutTimer then self:CancelTimer(timeoutTimer, true) end
    timeoutTimer = self:ScheduleTimer("OnBuyTimeout", BUY_TIMEOUT)
    self:RegisterMessage("PP_SNAPSHOT", "OnSnapshot")
    self:RegisterEvent("UI_ERROR_MESSAGE")
    self:SendMessage("PP_MERCHANT_STATE")
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
    ownBuy = true
    for _, item in ipairs(plan.items) do
        for _, n in ipairs(item.calls) do
            BuyMerchantItem(item.index, n)
        end
        self:AddPending(item.itemId, item.count)
        parts[#parts + 1] = item.count .. "x " .. PP:GetItemName(item.itemId)
    end
    ownBuy = false
    PP:Print(L["BUY_DONE"]:format(table.concat(parts, ", "),
        PP.util.FormatMoney(plan.total)))
    printNotes(plan)
    self:ArmLock()
end

function MerchantBuyer:ClearPending()
    for k in pairs(pending) do pending[k] = nil end
    if timeoutTimer then
        self:CancelTimer(timeoutTimer, true)
        timeoutTimer = nil
    end
    self:UnregisterMessage("PP_SNAPSHOT")
    self:UnregisterEvent("UI_ERROR_MESSAGE")
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

-- Lehnt der Server einen Kauf ab (Taschen voll, Gold, ausverkauft ...),
-- kommt der Rest nie an: kurz auf die Taschenzaehlung warten, dann die
-- Sperre loesen, statt die Notbremse abzuwarten.
function MerchantBuyer:UI_ERROR_MESSAGE(_, msg)
    if not next(pending) or not isBuyError(msg) then return end
    if timeoutTimer then self:CancelTimer(timeoutTimer, true) end
    timeoutTimer = self:ScheduleTimer("OnBuyTimeout", ERROR_GRACE)
end

-- Gnadenfrist nach einer Ablehnung bzw. Notbremse: die Leiste zeigt danach
-- den echten Rest.
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
