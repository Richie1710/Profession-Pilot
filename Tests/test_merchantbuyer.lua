-- MerchantBuyer: Haendlersortiment lesen, Preise merken, fehlende Menge
-- kaufen, Sperre gegen Doppelkauf. Das Modul wird headless mit gestubbter
-- Haendler-API geladen (Stub-Muster aus test_recipetracker.lua).

local root = ((arg and arg[0] or ""):match("^(.*)[/\\]") or ".") .. "/.."
local PP = _G.ProfessionPilot

-- Umgebung sichern: alle Tests teilen sich einen Lua-Zustand.
local saved = {
    NewModule = rawget(PP, "NewModule"),
    GetProfessions = rawget(PP, "GetProfessions"),
    GetItemName = rawget(PP, "GetItemName"),
    Print = rawget(PP, "Print"),
    db = rawget(PP, "db"),
    snapshot = rawget(PP, "snapshot"),
    counts = rawget(PP, "counts"),
    GetMerchantNumItems = _G.GetMerchantNumItems,
    GetMerchantItemLink = _G.GetMerchantItemLink,
    GetMerchantItemInfo = _G.GetMerchantItemInfo,
    GetMerchantItemMaxStack = _G.GetMerchantItemMaxStack,
    BuyMerchantItem = _G.BuyMerchantItem,
    GetMoney = _G.GetMoney,
    GetTime = _G.GetTime,
    MerchantFrame = _G.MerchantFrame,
    hooksecurefunc = _G.hooksecurefunc,
    ERR_INV_FULL = _G.ERR_INV_FULL,
}

local THREAD, CLOTH, DYE, OTHER = 14341, 14047, 4342, 999999
local PROF = { steps = { { materials = {
    { itemId = THREAD }, { itemId = CLOTH }, { itemId = DYE } } } } }

local module, MB
function PP:NewModule() module = {} return module end
PP.GetProfessions = function() return { tailoring = PROF } end
PP.GetItemName = function(_, id) return "item" .. id end
local printed = {}
PP.Print = function(_, msg) printed[#printed + 1] = msg end
PP.db = { global = { vendorPrices = {} }, profile = { debug = false } }
PP.counts = { [THREAD] = { bags = 5, bank = 0 } }

-- Haendler: [1] Runenfaden (Einzelware, 5s), [2] fremdes Item,
-- [3] Farbe im 5er-Buendel, [4] Stoff nur gegen Sonderwaehrung.
local MERCHANT = {
    { id = THREAD, price = 500, qty = 1, avail = -1, stack = 20 },
    { id = OTHER,  price = 100, qty = 1, avail = -1, stack = 20 },
    { id = DYE,    price = 250, qty = 5, avail = -1, stack = 1 },
    { id = CLOTH,  price = 0,   qty = 1, avail = -1, stack = 20, ext = 1 },
}
_G.MerchantFrame = nil
_G.ERR_INV_FULL = "Inventory is full."
local now = 100
_G.GetTime = function() return now end
_G.GetMerchantNumItems = function() return #MERCHANT end
_G.GetMerchantItemLink = function(i)
    return "|cffffffff|Hitem:" .. MERCHANT[i].id .. ":0:0:0:0:0:0:0|h[x]|h|r"
end
_G.GetMerchantItemInfo = function(i)
    local e = MERCHANT[i]
    return "x", "tex", e.price, e.qty, e.avail, 1, e.ext
end
_G.GetMerchantItemMaxStack = function(i) return MERCHANT[i].stack end
local bought = {}
-- failNext: der Client lehnt den naechsten Kauf synchron ab (Fehlermeldung
-- noch waehrend des BuyMerchantItem-Aufrufs).
local failNext = false
_G.BuyMerchantItem = function(i, n)
    bought[#bought + 1] = i .. "x" .. (n or 1)
    if failNext then
        failNext = false
        MB:UI_ERROR_MESSAGE("UI_ERROR_MESSAGE", "Inventory is full.")
    end
end
_G.GetMoney = function() return 10000000 end
-- Wie im Client: der Hook laeuft nach der Originalfunktion.
_G.hooksecurefunc = function(name, fn)
    local orig = _G[name]
    _G[name] = function(...) orig(...) fn(...) end
end

local chunk = assert(loadfile(root .. "/Modules/MerchantBuyer.lua"))
chunk()
MB = module
T.ok(MB ~= nil and MB.Buy ~= nil, "MerchantBuyer laedt headless")

-- AceEvent/AceTimer-Ersatz: zeichnet nur auf (Timer als "Methode@Sekunden").
local events, messages, sent, timers = {}, {}, {}, {}
function MB:RegisterEvent(e) events[e] = true end
function MB:UnregisterEvent(e) events[e] = nil end
function MB:RegisterMessage(m, h) messages[m] = h or true end
function MB:UnregisterMessage(m) messages[m] = nil end
function MB:SendMessage(m) sent[#sent + 1] = m end
function MB:ScheduleTimer(method, delay)
    timers[#timers + 1] = method .. "@" .. tostring(delay)
    return #timers
end
function MB:CancelTimer() end

MB:OnEnable()
T.ok(events.MERCHANT_SHOW and events.MERCHANT_CLOSED,
    "enable: Haendler-Events registriert")
T.eq(MB:IsOpen(), false, "enable: Haendler zu")

PP.snapshot = {
    profession = PROF,
    tree = { { itemId = THREAD, missing = 45 } },
    totals = { entries = {
        { itemId = THREAD, missing = 45 },
        { itemId = DYE, missing = 7 },
        { itemId = CLOTH, missing = 3 },
    } },
}
T.eq(#MB:GetPlan("total").items, 0, "zu: leerer Plan")

MB:MERCHANT_SHOW()
T.eq(MB:IsOpen(), true, "show: offen")
T.ok(events.MERCHANT_UPDATE and events.PLAYER_MONEY, "show: Update-Events aktiv")
T.ok(events.UI_ERROR_MESSAGE, "show: lauscht auf Kaufablehnungen")
T.eq(sent[#sent], "PP_MERCHANT_STATE", "show: Zustand gesendet")

-- Preis-Cache: nur Berufsmaterialien, Stueckpreis, keine Sonderwaehrung.
local prices = PP.db.global.vendorPrices
T.eq(prices[THREAD], 500, "cache: Stueckpreis Einzelware")
T.eq(prices[DYE], 50, "cache: Buendelpreis / Buendelgroesse")
T.eq(prices[OTHER], nil, "cache: fremde Items nicht")
T.eq(prices[CLOTH], nil, "cache: Sonderwaehrung nicht")

-- Plaene je Umfang.
local cur = MB:GetPlan("current")
T.eq(#cur.items, 1, "plan current: nur Faden")
T.eq(cur.items[1].count, 45, "plan current: 45 Faden")
local tot = MB:GetPlan("total")
T.eq(#tot.items, 2, "plan total: Faden + Farbe")
T.eq(tot.skipped[1] and tot.skipped[1].reason, "currency",
    "plan total: Stoff nur gegen Sonderwaehrung")

-- Kauf: exakte Aufrufliste (Faden in 20er-Stapeln, Farbe je Buendel).
MB:Buy("total")
T.eq(table.concat(bought, " "), "1x20 1x20 1x5 3x1 3x1",
    "buy: Stapel fuer Faden, Buendel einzeln")
T.eq(MB:IsBusy(), true, "buy: Sperre aktiv")
T.ok(messages.PP_SNAPSHOT, "buy: wartet auf Snapshot")
T.ok(events.UI_ERROR_MESSAGE, "buy: lauscht auf Serverablehnungen")
T.eq(timers[#timers], "OnBuyTimeout@20", "buy: Notbremse nach 20 s")
T.eq(printed[1], "BUY_DONE", "buy: Zusammenfassung im Chat")
T.eq(printed[2], "BUY_NOTE_SKIP_CURRENCY", "buy: Sonderwaehrungs-Hinweis")

-- Zweiter Klick waehrend der Sperre kauft nichts.
local before = #bought
MB:Buy("total")
T.eq(#bought, before, "sperre: kein Doppelkauf")

-- Waehrend der Sperre zieht der Plan das Unterwegs-Material ab.
T.eq(#MB:GetPlan("current").items, 0,
    "sperre: Faden unterwegs -> nichts mehr zu kaufen")

-- Teilankunft: Sperre bleibt.
PP.counts[THREAD] = { bags = 30, bank = 0 }
MB:OnSnapshot()
T.eq(MB:IsBusy(), true, "teilweise angekommen: noch gesperrt")

-- Alles angekommen (Ziel: 5 + 45 Faden, 0 + 10 Farbe): Sperre frei. Das
-- belegt nebenbei, dass der BuyMerchantItem-Hook eigene Kaeufe nicht ein
-- zweites Mal zaehlt (sonst laege das Ziel bei 95).
PP.counts[THREAD] = { bags = 50, bank = 0 }
PP.counts[DYE] = { bags = 10, bank = 0 }
MB:OnSnapshot()
T.eq(MB:IsBusy(), false, "angekommen: Sperre frei")
T.eq(messages.PP_SNAPSHOT, nil, "angekommen: Snapshot-Abo beendet")
T.ok(events.UI_ERROR_MESSAGE, "angekommen: Fehler-Event bleibt bei offenem Haendler")

-- Notbremse: weder Ankunft noch Fehlermeldung -> Sperre loest sich.
PP.snapshot.tree = { { itemId = THREAD, missing = 10 } }
MB:Buy("current")
T.eq(MB:IsBusy(), true, "timeout: gesperrt nach Kauf")
MB:OnBuyTimeout()
T.eq(MB:IsBusy(), false, "timeout: Sperre frei")

-- Serverablehnung (Taschen voll): kurze Gnadenfrist fuer die Taschen-
-- zaehlung statt der Notbremse; fremde Fehlermeldungen aendern nichts.
MB:Buy("current")
local nTimers = #timers
MB:UI_ERROR_MESSAGE("UI_ERROR_MESSAGE", "Not enough rage")
T.eq(#timers, nTimers, "fehler: fremde Meldung ignoriert")
T.eq(MB:IsBusy(), true, "fehler: fremde Meldung laesst die Sperre stehen")
MB:UI_ERROR_MESSAGE("UI_ERROR_MESSAGE", "Inventory is full.")
T.eq(timers[#timers], "OnBuyTimeout@1", "fehler: Taschen voll -> 1 s Gnadenfrist")
T.eq(MB:IsBusy(), true, "fehler: bis zur Gnadenfrist gesperrt")
MB:OnBuyTimeout()
T.eq(MB:IsBusy(), false, "fehler: danach frei")

-- Synchrone Ablehnung: der Client meldet den Fehler schon waehrend
-- BuyMerchantItem, also bevor die Sperre steht -> trotzdem nur die
-- Gnadenfrist. Eine Ablehnung aus einem frueheren Frame zaehlt nicht.
now = 200
failNext = true
MB:Buy("current")
T.eq(timers[#timers], "OnBuyTimeout@1",
    "sync-fehler: Ablehnung waehrend des Kaufs -> Gnadenfrist")
MB:OnBuyTimeout()
now = 201
MB:Buy("current")
T.eq(timers[#timers], "OnBuyTimeout@20",
    "sync-fehler: alte Ablehnung verkuerzt keine neue Sperre")
MB:OnBuyTimeout()

-- Kaeufe am Knopf vorbei (Blizzard-Haendlerfenster, Auto-Restock-Addons)
-- sperren ebenfalls und werden vom Plan abgezogen.
PP.snapshot.tree = { { itemId = THREAD, missing = 10 } }
_G.BuyMerchantItem(1, 4)
T.eq(MB:IsBusy(), true, "extern: Handkauf sperrt")
local p = MB:GetPlan("current")
T.eq(p.items[1] and p.items[1].count, 6, "extern: 4 unterwegs -> nur 6 fehlen")
PP.counts[THREAD] = { bags = 54, bank = 0 }
MB:OnSnapshot()
T.eq(MB:IsBusy(), false, "extern: nach Ankunft frei")
_G.BuyMerchantItem(3, 1)
T.eq(MB:IsBusy(), true, "extern: Buendelkauf sperrt")
PP.counts[DYE] = { bags = 15, bank = 0 }
MB:OnSnapshot()
T.eq(MB:IsBusy(), false, "extern: ein Buendel (5) angekommen -> frei")
_G.BuyMerchantItem(2, 1)
T.eq(MB:IsBusy(), false, "extern: fremdes Item sperrt nicht")

-- Nichts zu kaufen: Hinweis statt Kauf.
before = #bought
PP.snapshot.tree = {}
MB:Buy("current")
T.eq(#bought, before, "leer: kein Kauf")
T.eq(printed[#printed], "BUY_NOTHING", "leer: Hinweis im Chat")

-- Schliessen: Zustand weg, doppeltes CLOSED ist harmlos.
PP.snapshot.tree = { { itemId = THREAD, missing = 10 } }
MB:Buy("current")
MB:MERCHANT_CLOSED()
T.eq(MB:IsOpen(), false, "closed: zu")
T.eq(MB:IsBusy(), false, "closed: Sperre weg")
T.eq(events.MERCHANT_UPDATE, nil, "closed: Update-Event abgemeldet")
T.eq(events.UI_ERROR_MESSAGE, nil, "closed: Fehler-Event abgemeldet")
T.eq(#MB:GetPlan("current").items, 0, "closed: keine Angebote mehr")
local n = #sent
MB:MERCHANT_CLOSED()
T.eq(#sent, n, "closed doppelt: kein zweites Signal")

-- Umgebung zuruecksetzen.
for k in pairs({ NewModule = 1, GetProfessions = 1, GetItemName = 1,
                 Print = 1, db = 1, snapshot = 1, counts = 1 }) do
    PP[k] = saved[k]
end
_G.GetMerchantNumItems = saved.GetMerchantNumItems
_G.GetMerchantItemLink = saved.GetMerchantItemLink
_G.GetMerchantItemInfo = saved.GetMerchantItemInfo
_G.GetMerchantItemMaxStack = saved.GetMerchantItemMaxStack
_G.BuyMerchantItem = saved.BuyMerchantItem
_G.GetMoney = saved.GetMoney
_G.GetTime = saved.GetTime
_G.MerchantFrame = saved.MerchantFrame
_G.hooksecurefunc = saved.hooksecurefunc
_G.ERR_INV_FULL = saved.ERR_INV_FULL
