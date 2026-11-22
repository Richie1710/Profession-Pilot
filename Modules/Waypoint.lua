-- ProfessionPilot Modules/Waypoint.lua
-- Wegpunkt fuer einen Lehrer: TomTom -> Carbonite -> Koordinaten im Chat.
-- Plain Table (kein AceModule, keine Events); alles wird erst beim Klick aufgeloest.
--
-- TomTom und Carbonite sind nur OptionalDeps. Globals (_G.TomTom, _G.Nx) nie beim Laden
-- cachen: Carbonite legt ohne TomTom eine TomTom-Emulation an, die nur einen Teil der API hat.
-- Jeder Fremdaufruf laeuft in pcall; scheitert ein Anbieter, kommt der naechste dran.

local PP = _G.ProfessionPilot
local Waypoint = {}
PP.Waypoint = Waypoint

local last = { provider = nil, uid = nil, key = nil }
local czCache -- mapFile -> { c, z }, einmal pro Sitzung gebaut

local ORDER = {
    auto = { "tomtom", "carbonite" },
    tomtom = { "tomtom", "carbonite" },
    carbonite = { "carbonite", "tomtom" },
    chat = {},
}
Waypoint.ORDER = ORDER

-- echtes TomTom (die Carbonite-Emulation hat kein GetCZ)
function Waypoint.HasTomTom()
    local t = _G.TomTom
    return type(t) == "table" and type(t.AddZWaypoint) == "function"
        and type(t.GetCZ) == "function" and type(t.RemoveWaypoint) == "function"
end

function Waypoint.HasCarbonite()
    local nx = _G.Nx
    if type(nx) ~= "table" or type(nx.TTSTCZXY) ~= "function" then return false end
    if type(nx.Map) ~= "table" or type(nx.Map.GeM) ~= "function" then return false end
    local ok, map = pcall(nx.Map.GeM, nx.Map, 1)
    return ok and map ~= nil
end

local function mapOpen()
    local f = _G.WorldMapFrame
    return f ~= nil and type(f.IsShown) == "function" and f:IsShown() and true or false
end

-- Weltkarte einmal durchgehen: mapFile -> c,z. Nur bei geschlossener Karte; die vorherige
-- Kartenansicht wird danach wiederhergestellt.
local function buildCache()
    if mapOpen() then return nil end
    if type(GetMapContinents) ~= "function" or type(SetMapZoom) ~= "function"
        or type(GetMapInfo) ~= "function" then
        return nil
    end
    local oldC = type(GetCurrentMapContinent) == "function" and GetCurrentMapContinent() or nil
    local oldZ = type(GetCurrentMapZone) == "function" and GetCurrentMapZone() or nil
    -- Stockwerk mitsichern: SetMapZoom setzt mehrstoeckige Karten (Dalaran/Unterstadt) auf Ebene 1
    local oldLevel = type(GetCurrentMapDungeonLevel) == "function" and GetCurrentMapDungeonLevel() or 0
    local cache = {}
    local ok = pcall(function()
        for c = 1, select("#", GetMapContinents()) do
            for z = 1, select("#", GetMapZones(c)) do
                SetMapZoom(c, z)
                local file = GetMapInfo()
                if file and not cache[file] then cache[file] = { c, z } end
            end
        end
    end)
    if oldC and oldC > 0 then
        pcall(SetMapZoom, oldC, oldZ or 0)
        if oldLevel and oldLevel > 0 and type(SetDungeonMapLevel) == "function" then
            pcall(SetDungeonMapLevel, oldLevel)
        end
    elseif type(SetMapToCurrentZone) == "function" then
        pcall(SetMapToCurrentZone)
    end
    if not ok then return nil end
    czCache = cache
    return cache
end

-- Nur fuer Tests: Sitzungszustand zuruecksetzen
function Waypoint._Reset()
    czCache = nil
    last.provider, last.uid, last.key = nil, nil, nil
end

-- mapFile (sprachneutral) -> Kontinent- und Zonenindex der laufenden Sitzung.
-- Der Zonenindex ist sprachabhaengig (GetMapZones sortiert nach lokalisiertem Namen).
function Waypoint.ResolveCZ(c, mapFile, zoneName)
    if mapFile and Waypoint.HasTomTom() then
        local ok, rc, rz = pcall(_G.TomTom.GetCZ, _G.TomTom, mapFile)
        if ok and rc and rz and rz > 0 then return rc, rz end
    end
    if mapFile then
        local cache = czCache or buildCache()
        local e = cache and cache[mapFile]
        if e then return e[1], e[2] end
    end
    if c and zoneName and type(GetMapZones) == "function" then
        local zones = { GetMapZones(c) }
        for i = 1, #zones do
            if zones[i] == zoneName then return c, i end
        end
    end
    return nil
end

local function stillValid()
    if not last.uid then return false end
    if last.provider == "tomtom" and Waypoint.HasTomTom() then
        local t = _G.TomTom
        if type(t.IsValidWaypoint) ~= "function" then return false end
        local ok, valid = pcall(t.IsValidWaypoint, t, last.uid)
        return ok and valid and true or false
    elseif last.provider == "carbonite" and Waypoint.HasCarbonite() then
        local ok, map = pcall(_G.Nx.Map.GeM, _G.Nx.Map, 1)
        if not ok or not map or type(map.FiT) ~= "function" then return false end
        local ok2, found = pcall(map.FiT, map, last.uid)
        return ok2 and found ~= nil
    end
    return false
end

local function removeLast()
    if last.uid then
        if last.provider == "tomtom" and Waypoint.HasTomTom() then
            pcall(_G.TomTom.RemoveWaypoint, _G.TomTom, last.uid)
        elseif last.provider == "carbonite" and Waypoint.HasCarbonite() and type(_G.Nx.TTRW) == "function" then
            pcall(_G.Nx.TTRW, _G.Nx, last.uid)
        end
    end
    last.provider, last.uid, last.key = nil, nil, nil
end

local function arrival()
    local t = _G.TomTom
    local p = t and t.profile
    return p and p.arrow and p.arrow.arrival or 15
end

local function setArrow(uid, title)
    local t = _G.TomTom
    if type(t.SetCrazyArrow) == "function" then
        pcall(t.SetCrazyArrow, t, uid, arrival(), title)
    end
end

local function tryTomTom(c, z, x, y, title)
    if not Waypoint.HasTomTom() or not c or not z then return nil end
    local t = _G.TomTom
    -- persistent=false, minimap/world/callbacks Default, silent, Pfeil
    local ok, uid = pcall(t.AddZWaypoint, t, c, z, x, y, title, false, nil, nil, nil, true, true)
    if not ok or not uid then return nil end
    -- TomTom gibt bei Dubletten die alte uid zurueck, ohne den Pfeil neu zu setzen
    setArrow(uid, title)
    return uid
end

local function tryCarbonite(c, z, x, y, title)
    if not Waypoint.HasCarbonite() or not c or not z then return nil end
    local nx = _G.Nx
    local cz = nx.Map.CZ2I
    -- unbekannter Zonenindex: Carbonite wuerde das Ziel auf 0,0 setzen
    if type(cz) ~= "table" or type(cz[c]) ~= "table" or not cz[c][z] then return nil end
    local ok, uid = pcall(nx.TTSTCZXY, nx, c, z, x, y, title)
    if ok and uid then return uid end
    return nil
end

local TRY = { tomtom = tryTomTom, carbonite = tryCarbonite }
local NAMES = { tomtom = "TomTom", carbonite = "Carbonite" }

local function chat(info, note)
    local L = PP.L
    PP:Print(L["WAYPOINT_CHAT"]:format(info.title or "", info.zoneName or info.map or "?", info.x, info.y))
    if note then PP:Print(note) end
end

-- info = { c, map, x, y, title, zoneName, forceChat }; x/y in Prozent.
-- Rueckgabe: "tomtom" | "carbonite" | "chat"
function Waypoint.Set(info)
    local L = PP.L
    local pref = PP.db and PP.db.profile and PP.db.profile.waypointTarget or "auto"
    local order = ORDER[pref] or ORDER.auto
    if info.forceChat or #order == 0 then
        chat(info)
        return "chat"
    end

    local key = string.format("%s:%.1f:%.1f:%s", tostring(info.map), info.x, info.y, tostring(info.title))
    if last.key == key and stillValid() then
        if last.provider == "tomtom" then setArrow(last.uid, info.title) end
        PP:Print(L["WAYPOINT_SET"]:format(NAMES[last.provider] or last.provider, info.title or ""))
        return last.provider
    end

    local anyProvider = Waypoint.HasTomTom() or Waypoint.HasCarbonite()
    local c, z
    if anyProvider then c, z = Waypoint.ResolveCZ(info.c, info.map, info.zoneName) end

    if c and z then
        removeLast()
        for _, p in ipairs(order) do
            local uid = TRY[p](c, z, info.x, info.y, info.title)
            if uid then
                last.provider, last.uid, last.key = p, uid, key
                PP:Print(L["WAYPOINT_SET"]:format(NAMES[p], info.title or ""))
                return p
            end
        end
    end

    local note = nil
    if anyProvider and not c and mapOpen() then note = L["WAYPOINT_MAP_OPEN"] end
    chat(info, note)
    return "chat"
end

function Waypoint.Clear()
    removeLast()
end
