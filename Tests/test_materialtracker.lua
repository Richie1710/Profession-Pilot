-- MaterialTracker: countsReady fuer die oeffentliche API. Das Flag darf erst
-- nach einem vollen Scan seit dem letzten Ladescreen true sein.

local root = ((arg and arg[0] or ""):match("^(.*)[/\\]") or ".") .. "/.."
local PP = _G.ProfessionPilot

local saved = {
    NewModule = rawget(PP, "NewModule"),
    Recompute = rawget(PP, "Recompute"),
    db = rawget(PP, "db"),
    state = rawget(PP, "state"),
    counts = rawget(PP, "counts"),
    NUM_BAG_SLOTS = _G.NUM_BAG_SLOTS,
    GetContainerNumSlots = _G.GetContainerNumSlots,
    GetContainerItemLink = _G.GetContainerItemLink,
    GetContainerItemInfo = _G.GetContainerItemInfo,
}

local module
local events = {}
function PP:NewModule()
    module = {}
    function module:RegisterEvent(name, handler) events[name] = handler end
    function module:RegisterBucketEvent(name, _, handler) events[name] = handler end
    function module:RegisterMessage(name, handler) events[name] = handler end
    return module
end

local recomputed = 0
PP.Recompute = function() recomputed = recomputed + 1 end
PP.state = {}
PP.counts = {}
PP.db = { char = {}, profile = {} }

-- Ein Beutel mit 2 Plaetzen: Rugged Leather (8170) x7 in Platz 1.
_G.NUM_BAG_SLOTS = 0
_G.GetContainerNumSlots = function() return 2 end
_G.GetContainerItemLink = function(_, slot)
    if slot == 1 then return "|cffffffff|Hitem:8170:0:0:0:0:0:0:0|h[Rugged Leather]|h|r" end
end
_G.GetContainerItemInfo = function() return nil, 7 end

assert(loadfile(root .. "/Modules/MaterialTracker.lua"))()
local MT = module
T.ok(MT ~= nil and MT.FullScan ~= nil, "MaterialTracker laedt headless")

MT:OnEnable()
T.eq(PP.state.countsReady, false, "nach OnEnable: Zahlen noch nicht gelesen")
T.eq(events["PLAYER_LEAVING_WORLD"], "OnLeavingWorld", "Ladescreen-Ende vorbereitet: LEAVING_WORLD registriert")
T.eq(events["PLAYER_ENTERING_WORLD"], "FullScan", "PLAYER_ENTERING_WORLD loest den vollen Scan aus")

-- Ein BAG_UPDATE mitten im Login ist kein voller Scan.
MT:OnBagUpdate()
T.eq(PP.state.countsReady, false, "BAG_UPDATE setzt countsReady nicht")
T.eq(PP.counts[8170] and PP.counts[8170].bags, 7, "Zahlen werden trotzdem veroeffentlicht")

MT:FullScan()
T.eq(PP.state.countsReady, true, "FullScan: Zahlen gelesen")
T.eq(PP.counts[8170].bags, 7, "FullScan zaehlt die Taschen")
T.ok(recomputed > 0, "Neuberechnung angestossen")

-- Neuer Ladescreen: Flag faellt, bis der naechste volle Scan lief.
MT:OnLeavingWorld()
T.eq(PP.state.countsReady, false, "Ladescreen: Zahlen gelten als veraltet")
MT:OnBagUpdate()
T.eq(PP.state.countsReady, false, "BAG_UPDATE im Ladescreen: weiter nicht bereit")
MT:FullScan()
T.eq(PP.state.countsReady, true, "nach dem Ladescreen wieder bereit")

for k in pairs({ NewModule = 1, Recompute = 1, db = 1, state = 1, counts = 1 }) do
    PP[k] = saved[k]
end
_G.NUM_BAG_SLOTS = saved.NUM_BAG_SLOTS
_G.GetContainerNumSlots = saved.GetContainerNumSlots
_G.GetContainerItemLink = saved.GetContainerItemLink
_G.GetContainerItemInfo = saved.GetContainerItemInfo
