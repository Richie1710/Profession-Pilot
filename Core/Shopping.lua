-- ProfessionPilot Core/Shopping.lua
-- Pure Einkaufslogik fuer den Haendlerkauf: fehlende Basismaterialien aus
-- dem Materialbaum sammeln, gegen das Sortiment eines Haendlers planen und
-- ausstehende (gekaufte, noch nicht gezaehlte) Mengen bestimmen. Keine
-- WoW-API, kein Zustand -- headless testbar (Tests/test_shopping.lua).
-- Der Laufzeit-Feeder ist Modules/MerchantBuyer.lua.

local PP = _G.ProfessionPilot
local Shopping = {}
PP.Shopping = Shopping

local ceil, floor, min = math.ceil, math.floor, math.min

-- nodes: verschachtelte Knoten aus Calc.BuildMaterialTree bzw.
-- Calc.AggregateMaterials ({ itemId, missing, craftedBy?, children? }).
-- -> { {itemId, missing}, ... } in Erstverwendungs-Reihenfolge (Pre-Order),
-- je Item summiert. Nur Basismaterialien: Knoten mit craftedBy werden
-- hergestellt, ihre Zutaten stehen bereits als Kinder im Baum. Die Summe
-- zaehlt nichts doppelt, weil Calc den Bestand aus einem gemeinsamen Pool
-- abzieht (gleiche Regel wie die Kostenspalte der Einkaufsliste).
function Shopping.CollectMissing(nodes)
    local list, byItem = {}, {}
    local function walk(ns)
        for i = 1, #ns do
            local n = ns[i]
            if not n.craftedBy and (n.missing or 0) > 0 then
                local e = byItem[n.itemId]
                if not e then
                    e = { itemId = n.itemId, missing = 0 }
                    byItem[n.itemId] = e
                    list[#list + 1] = e
                end
                e.missing = e.missing + n.missing
            end
            if n.children then walk(n.children) end
        end
    end
    if nodes then walk(nodes) end
    return list
end

local function lotOf(offer)
    local lot = offer.lot
    if not lot or lot < 1 then return 1 end
    return lot
end

-- Argumente fuer BuyMerchantItem(index, n). Einzelware (lot == 1) geht in
-- Stuecken zu hoechstens maxStack; bei Buendelware (lot > 1) ist die
-- Bedeutung von n zwischen Addons uneinheitlich, deshalb ein Buendel pro
-- Aufruf.
function Shopping.BuildCalls(lots, lot, maxStack)
    local calls = {}
    if lot > 1 then
        for i = 1, lots do calls[i] = 1 end
        return calls
    end
    local per = (maxStack and maxStack >= 1) and maxStack or 1
    local left = lots
    while left > 0 do
        local n = min(left, per)
        calls[#calls + 1] = n
        left = left - n
    end
    return calls
end

-- Guenstigstes Angebot je Item (Stueckpreis), Sonderwaehrung ausgenommen.
-- -> best[itemId] = offer, currencyOnly[itemId] = true
local function pickOffers(offers)
    local best, currencyOnly = {}, {}
    for i = 1, #(offers or {}) do
        local o = offers[i]
        if o.extendedCost then
            if not best[o.itemId] then currencyOnly[o.itemId] = true end
        else
            local cur = best[o.itemId]
            if not cur or o.price / lotOf(o) < cur.price / lotOf(cur) then
                best[o.itemId] = o
            end
            currencyOnly[o.itemId] = nil
        end
    end
    return best, currencyOnly
end

-- missing: Ausgabe von CollectMissing
-- offers:  { {index, itemId, price, lot, available, maxStack, extendedCost}, ... }
--          price = Kupfer pro Buendel, lot = Stueck pro Buendel,
--          available = -1 unbegrenzt, sonst Buendel; maxStack = pro Aufruf
-- opts.money:       verfuegbares Kupfer (nil = unbegrenzt)
-- opts.outstanding: { [itemId] = n } bereits gekauft, noch nicht gezaehlt
-- -> { items = { {itemId, index, lots, count, cost, calls, capped?} },
--      skipped = { {itemId, reason = "stock"|"money"|"currency", want} },
--      total = Kupfer }
-- Gold wird in der Reihenfolge von `missing` verteilt; Items, die der
-- Haendler nicht fuehrt, fallen still heraus.
function Shopping.PlanPurchases(missing, offers, opts)
    opts = opts or {}
    local money = opts.money
    local outstanding = opts.outstanding or {}
    local best, currencyOnly = pickOffers(offers)
    local plan = { items = {}, skipped = {}, total = 0 }

    for i = 1, #(missing or {}) do
        local m = missing[i]
        local want = m.missing - (outstanding[m.itemId] or 0)
        local o = best[m.itemId]
        if want > 0 and o then
            local lot = lotOf(o)
            local lots = ceil(want / lot)
            local capped
            if o.available and o.available >= 0 and o.available < lots then
                lots = o.available
                capped = "stock"
            end
            if lots > 0 and money and o.price > 0 then
                local affordable = floor(money / o.price)
                if affordable < lots then
                    lots = affordable
                    capped = "money"
                end
            end
            if lots > 0 then
                local cost = lots * o.price
                if money then money = money - cost end
                plan.items[#plan.items + 1] = {
                    itemId = m.itemId, index = o.index, lots = lots,
                    count = lots * lot, cost = cost, capped = capped,
                    calls = Shopping.BuildCalls(lots, lot, o.maxStack),
                }
                plan.total = plan.total + cost
            else
                plan.skipped[#plan.skipped + 1] =
                    { itemId = m.itemId, reason = capped, want = want }
            end
        elseif want > 0 and currencyOnly[m.itemId] then
            plan.skipped[#plan.skipped + 1] =
                { itemId = m.itemId, reason = "currency", want = want }
        end
    end
    return plan
end

-- Hinweise fuer Chat und Tooltip: gedeckelte Kaeufe (count = gekaufte
-- Stueckzahl) und uebersprungene Items (count = gewollte Stueckzahl).
-- kind: "capped_stock" | "capped_money" | "skip_stock" | "skip_money" |
--       "skip_currency"
function Shopping.Notes(plan)
    local notes = {}
    for i = 1, #plan.items do
        local it = plan.items[i]
        if it.capped then
            notes[#notes + 1] = { itemId = it.itemId,
                kind = "capped_" .. it.capped, count = it.count }
        end
    end
    for i = 1, #plan.skipped do
        local s = plan.skipped[i]
        notes[#notes + 1] = { itemId = s.itemId,
            kind = "skip_" .. s.reason, count = s.want }
    end
    return notes
end

-- pending: { [itemId] = Ziel-Taschenbestand nach dem Kauf }
-- counts:  PP.counts ({ [itemId] = { bags, bank } })
-- -> { [itemId] = noch nicht angekommene Stueckzahl } (nur > 0), anyOutstanding
function Shopping.Outstanding(pending, counts)
    local out, any = {}, false
    for itemId, target in pairs(pending or {}) do
        local c = counts and counts[itemId]
        local bags = c and c.bags or 0
        if target > bags then
            out[itemId] = target - bags
            any = true
        end
    end
    return out, any
end

return Shopping
