-- Modules/Waypoint.lua: TomTom / Carbonite / Chat mit Stubs (keine echten Addons noetig).

local root = ((arg and arg[0] or ""):match("^(.*)[/\\]") or ".") .. "/.."
local PP = _G.ProfessionPilot

local GLOBALS = { "TomTom", "Nx", "WorldMapFrame", "GetMapContinents", "GetMapZones", "SetMapZoom",
    "GetMapInfo", "GetCurrentMapContinent", "GetCurrentMapZone", "SetMapToCurrentZone",
    "GetCurrentMapDungeonLevel", "SetDungeonMapLevel" }
local saved = { Print = rawget(PP, "Print"), db = rawget(PP, "db"), Waypoint = rawget(PP, "Waypoint") }
local savedG = {}
for _, k in ipairs(GLOBALS) do savedG[k] = rawget(_G, k) end

local printed = {}
PP.Print = function(_, msg) printed[#printed + 1] = msg end
PP.db = { profile = { waypointTarget = "auto" } }

assert(loadfile(root .. "/Modules/Waypoint.lua"))()
local W = PP.Waypoint
T.ok(W ~= nil and W.Set ~= nil, "Waypoint laedt headless")

-- Weltkarte: Kalimdor (1) mit Zonen A, B; Oestliche Koenigreiche (2) mit Sturmwind an Index 2
local MAP = { [1] = { { "Ashenvale", "Eschental" }, { "Ogrimmar", "Orgrimmar" } },
              [2] = { { "Elwynn", "Wald von Elwynn" }, { "Stormwind", "Sturmwind" } } }
local zoomCalls, current = {}, { 2, 1 }
local function setupMap()
    zoomCalls = {}
    current = { 2, 1 }
    _G.GetMapContinents = function() return "Kalimdor", "Oestliche Koenigreiche" end
    _G.GetMapZones = function(c)
        local out = {}
        for i, z in ipairs(MAP[c] or {}) do out[i] = z[2] end
        return unpack(out)
    end
    _G.SetMapZoom = function(c, z) zoomCalls[#zoomCalls + 1] = c .. ":" .. tostring(z); current = { c, z } end
    _G.GetMapInfo = function()
        local z = MAP[current[1]] and MAP[current[1]][current[2]]
        return z and z[1]
    end
    _G.GetCurrentMapContinent = function() return current[1] end
    _G.GetCurrentMapZone = function() return current[2] end
    _G.SetMapToCurrentZone = function() zoomCalls[#zoomCalls + 1] = "current" end
    _G.WorldMapFrame = { shown = false, IsShown = function(self) return self.shown end }
end

local function newTomTom()
    local tt = { adds = {}, removed = {}, arrows = {}, valid = {}, nextUid = 1, profile = { arrow = { arrival = 20 } } }
    function tt:AddZWaypoint(c, z, x, y, desc, persistent, minimap, world, cb, silent, crazy)
        self.adds[#self.adds + 1] = { c = c, z = z, x = x, y = y, desc = desc, persistent = persistent, silent = silent }
        local uid = self.nextUid
        self.nextUid = uid + 1
        self.valid[uid] = true
        return uid
    end
    function tt:GetCZ(file)
        for c, zones in pairs(MAP) do
            for z, e in ipairs(zones) do if e[1] == file then return c, z end end
        end
    end
    function tt:RemoveWaypoint(uid) self.removed[#self.removed + 1] = uid; self.valid[uid] = nil end
    function tt:SetCrazyArrow(uid, dist, title) self.arrows[#self.arrows + 1] = { uid = uid, dist = dist } end
    function tt:IsValidWaypoint(uid) return self.valid[uid] == true end
    return tt
end

local function newCarbonite()
    local nx = { calls = {}, removed = {} }
    local map = { targets = {} }
    function map:FiT(uid) return self.targets[uid] end
    nx.Map = { CZ2I = { [1] = { 1001, 1002 }, [2] = { 2001, 2002 } } }
    function nx.Map:GeM() return map end
    local n = 100
    function nx:TTSTCZXY(c, z, x, y, name)
        self.calls[#self.calls + 1] = { c = c, z = z, x = x, y = y, name = name }
        n = n + 1
        map.targets[n] = true
        return n
    end
    function nx:TTRW(id) self.removed[#self.removed + 1] = id; map.targets[id] = nil end
    return nx
end

local SW = { c = 2, map = "Stormwind", x = 62.1, y = 30.3, title = "Lilliam", zoneName = "Sturmwind" }
local OG = { c = 1, map = "Ogrimmar", x = 76.2, y = 25.2, title = "Roxxik", zoneName = "Orgrimmar" }
local function reset()
    W._Reset()
    printed = {}
    _G.TomTom, _G.Nx = nil, nil
    PP.db.profile.waypointTarget = "auto"
    setupMap()
end

-- nur TomTom ---------------------------------------------------------------------------------
reset()
local tt = newTomTom()
_G.TomTom = tt
T.eq(W.Set(SW), "tomtom", "nur TomTom -> TomTom")
T.eq(#tt.adds, 1, "ein Wegpunkt angelegt")
T.eq(tt.adds[1].c, 2, "TomTom: Kontinent")
T.eq(tt.adds[1].z, 2, "TomTom: Zonenindex per GetCZ")
T.eq(tt.adds[1].persistent, false, "TomTom: nicht persistent")
T.eq(tt.adds[1].x, 62.1, "TomTom: x in Prozent")
T.eq(#tt.arrows, 1, "TomTom: Pfeil gesetzt")
T.eq(tt.arrows[1].dist, 20, "TomTom: Ankunftsradius aus dem Profil")
T.eq(#zoomCalls, 0, "mit TomTom wird die Weltkarte nicht angefasst")

-- gleicher Klick zweimal: kein zweiter Wegpunkt, Pfeil neu
T.eq(W.Set(SW), "tomtom", "zweiter Klick -> TomTom")
T.eq(#tt.adds, 1, "kein zweiter Wegpunkt")
T.eq(#tt.arrows, 2, "Pfeil erneut gesetzt")

-- anderer Lehrer: alter Wegpunkt wird entfernt
W.Set(OG)
T.eq(#tt.adds, 2, "neuer Lehrer -> neuer Wegpunkt")
T.eq(tt.removed[1], 1, "alter eigener Wegpunkt entfernt")

-- Ziel erreicht (uid ungueltig) -> wieder anlegen
tt.valid[2] = nil
W.Set(OG)
T.eq(#tt.adds, 3, "abgelaufener Wegpunkt wird neu angelegt")

-- Carbonite-Emulation als TomTom (ohne GetCZ) + Carbonite -----------------------------------
reset()
local nx = newCarbonite()
_G.Nx = nx
_G.TomTom = { version = "236", AddZWaypoint = function() error("Emulation darf nicht benutzt werden") end,
    RemoveWaypoint = function() end, SetCrazyArrow = function() end }
T.ok(not W.HasTomTom(), "Emulation wird nicht als TomTom erkannt")
T.eq(W.Set(SW), "carbonite", "Emulation -> Carbonite direkt")
T.eq(nx.calls[1] and nx.calls[1].z, 2, "Carbonite: Zonenindex aus dem Karten-Cache")
T.ok(#zoomCalls > 0, "Cache-Bau zoomt die Karte")
T.eq(zoomCalls[#zoomCalls], "2:1", "Kartenansicht danach wiederhergestellt")
local before = #zoomCalls
W.Set(OG)
T.eq(#zoomCalls, before, "Cache wird nur einmal pro Sitzung gebaut")
T.eq(nx.removed[1], 101, "Carbonite: alter Wegpunkt entfernt")

-- mehrstoeckige Karte: Stockwerk wird nach dem Cache-Bau wiederhergestellt
reset()
_G.Nx = newCarbonite()
local level = 2
_G.GetCurrentMapDungeonLevel = function() return level end
_G.SetDungeonMapLevel = function(l) zoomCalls[#zoomCalls + 1] = "level" .. l; level = l end
local oldZoom = _G.SetMapZoom
_G.SetMapZoom = function(c, z) oldZoom(c, z); level = 1 end
W.Set(SW)
T.eq(zoomCalls[#zoomCalls - 1], "2:1", "Stockwerk: erst Zone wiederhergestellt")
T.eq(zoomCalls[#zoomCalls], "level2", "Stockwerk: dann SetDungeonMapLevel(2)")
T.eq(level, 2, "Stockwerk 2 nach dem Cache-Bau aktiv")

-- Karte ohne Stockwerke: kein SetDungeonMapLevel
reset()
_G.Nx = newCarbonite()
_G.GetCurrentMapDungeonLevel = function() return 0 end
W.Set(SW)
T.eq(zoomCalls[#zoomCalls], "2:1", "ohne Stockwerk: kein SetDungeonMapLevel")
_G.GetCurrentMapDungeonLevel, _G.SetDungeonMapLevel = nil, nil

-- Kartenansicht Kontinent 0 -> SetMapToCurrentZone
reset()
_G.Nx = newCarbonite()
current = { 0, 0 }
_G.GetCurrentMapContinent = function() return 0 end
W.Set(SW)
T.eq(zoomCalls[#zoomCalls], "current", "ohne Zonenansicht: SetMapToCurrentZone")

-- nur Carbonite, unbekannter Index -> Chat
reset()
nx = newCarbonite()
nx.Map.CZ2I = { [2] = {} }
_G.Nx = nx
T.eq(W.Set(SW), "chat", "Carbonite ohne CZ2I-Eintrag -> Chat")
T.eq(#nx.calls, 0, "Carbonite nicht aufgerufen")

-- beide: TomTom gewinnt; Option carbonite dreht die Reihenfolge -------------------------------
reset()
tt, nx = newTomTom(), newCarbonite()
_G.TomTom, _G.Nx = tt, nx
T.eq(W.Set(SW), "tomtom", "beide -> TomTom")
T.eq(#nx.calls, 0, "Carbonite nicht benutzt")
W._Reset()
PP.db.profile.waypointTarget = "carbonite"
T.eq(W.Set(SW), "carbonite", "Option carbonite -> Carbonite zuerst")
PP.db.profile.waypointTarget = "chat"
W._Reset()
local adds = #tt.adds
T.eq(W.Set(OG), "chat", "Option chat -> Chat")
T.eq(#tt.adds, adds, "Option chat: TomTom nie benutzt")

-- forceChat (Shift-Klick)
PP.db.profile.waypointTarget = "auto"
printed = {}
T.eq(W.Set({ c = 2, map = "Stormwind", x = 62.1, y = 30.3, title = "L", zoneName = "Sturmwind", forceChat = true }),
    "chat", "forceChat -> Chat")
T.eq(#printed, 1, "Chat-Ausgabe")

-- TomTom wirft -> Carbonite
reset()
tt, nx = newTomTom(), newCarbonite()
tt.AddZWaypoint = function() error("boom") end
_G.TomTom, _G.Nx = tt, nx
T.eq(W.Set(SW), "carbonite", "AddZWaypoint wirft -> Carbonite")

-- keins -> Chat ------------------------------------------------------------------------------
reset()
T.eq(W.Set(SW), "chat", "ohne Addon -> Chat")
T.eq(#zoomCalls, 0, "ohne Addon wird die Karte nicht angefasst")
T.eq(printed[1], "WAYPOINT_CHAT", "Chat-Text ausgegeben")

-- Weltkarte offen, kein TomTom: Karte nicht anfassen; Namensvergleich als Rueckfall ----------
reset()
nx = newCarbonite()
_G.Nx = nx
_G.WorldMapFrame.shown = true
T.eq(W.Set(SW), "carbonite", "Karte offen: Carbonite ueber Zonennamen")
T.eq(#zoomCalls, 0, "Karte offen: kein SetMapZoom")
W._Reset()
T.eq(W.Set({ c = 2, map = "Stormwind", x = 1, y = 1, title = "X", zoneName = "Unbekannt" }), "chat",
    "Karte offen, Name passt nicht -> Chat")
T.eq(printed[#printed], "WAYPOINT_MAP_OPEN", "Hinweis: Karte schliessen")
T.eq(#zoomCalls, 0, "Karte offen: weiterhin kein SetMapZoom")

-- Aufraeumen ---------------------------------------------------------------------------------
PP.Print, PP.db, PP.Waypoint = saved.Print, saved.db, saved.Waypoint
for _, k in ipairs(GLOBALS) do _G[k] = savedG[k] end
