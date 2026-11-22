-- Generator der Lehrerdaten (Tools/trainer_gen_lib.lua) und Regenerations-Check:
-- Professions/TrainerData.lua muss exakt der Ausgabe des Generators entsprechen.

local root = ((arg and arg[0] or ""):match("^(.*)[/\\]") or ".") .. "/.."
local Lib = dofile(root .. "/Tools/trainer_gen_lib.lua")
local src = dofile(root .. "/Tools/data/trainer_source.lua")

-- RanksOf ------------------------------------------------------------------------------------
local ranks, levels = Lib.RanksOf(202, { { 4039, 5 }, { 4040, 10 }, { 61464, 65 }, { 99999, 1 }, { 4040, 10 } })
T.eq(#ranks, 3, "RanksOf: unbekannter Spell ignoriert, doppelte entfernt")
T.eq(ranks[1], 1, "RanksOf: Rang 1")
T.eq(ranks[3], 6, "RanksOf: 61464 ist Ingenieur-Grossmeister")
T.eq(levels[6], 65, "RanksOf: ReqLevel je Rang")
local r2 = Lib.RanksOf(171, { { 51303, 65 } })
T.eq(#r2, 1, "RanksOf: GM-only-Lehrer hat genau einen Rang")
T.eq(r2[1], 6, "RanksOf: GM-only = Rang 6")
T.eq(#Lib.RanksOf(171, { { 4039, 5 } }), 0, "RanksOf: Spell eines anderen Berufs zaehlt nicht")
T.eq(#Lib.RanksOf(171, {}), 0, "RanksOf: keine Rang-Spells -> Spezialisierung")

-- SideOf -------------------------------------------------------------------------------------
local ft = {
    [12] = { our = 2, friend = 2, enemy = 4 },
    [29] = { our = 4, friend = 4, enemy = 2 },
    [35] = { our = 0, friend = 1, enemy = 0 },
    [1922] = { our = 0, friend = 4, enemy = 2 },
    [189] = { our = 0, friend = 0, enemy = 0 },
}
T.eq(Lib.SideOf(12, ft), "A", "SideOf: ourMask Allianz")
T.eq(Lib.SideOf(29, ft), "H", "SideOf: ourMask Horde")
T.eq(Lib.SideOf(35, ft), "N", "SideOf: 35 ist neutral")
T.eq(Lib.SideOf(1922, ft), "H", "SideOf: Taunka ueber friendMask Horde")
T.eq(Lib.SideOf(189, ft), "N", "SideOf: Template 189 ohne Override neutral")
T.eq(Lib.SideOf(189, ft, 24868), "A", "SideOf: Override Niobe -> Allianz")
T.eq(Lib.SideOf(77777, ft), "N", "SideOf: unbekanntes Template neutral")
T.eq(Lib.RepOf(1743), "aldor", "RepOf: Aldor")
T.eq(Lib.RepOf(1744), "scryers", "RepOf: Seher")
T.eq(Lib.RepOf(414), "timbermaw", "RepOf: Holzschlundfeste")
T.eq(Lib.RepOf(12), nil, "RepOf: normale Fraktion ohne Ruf")

-- IsPlaceholder / ValidSpawn -----------------------------------------------------------------
T.ok(Lib.IsPlaceholder({ entry = 33608, name = "Alchemy", sub = "", skillLine = 171 }), "Platzhalter 33608")
T.ok(Lib.IsPlaceholder({ entry = 1, name = "Tailoring", sub = "", skillLine = 197 }), "Platzhalter per Namensregel")
T.ok(not Lib.IsPlaceholder({ entry = 2, name = "Tailoring", sub = "Tailoring Trainer", skillLine = 197 }),
    "Name == Beruf mit Untertitel ist kein Platzhalter")
T.ok(not Lib.IsPlaceholder({ entry = 5518, name = "Lilliam Sparkspindle", sub = "", skillLine = 202 }),
    "normaler Lehrer ist kein Platzhalter")
T.ok(Lib.ValidSpawn({ map = 571, phase = 1 }), "ValidSpawn: Nordend Phase 1")
T.ok(not Lib.ValidSpawn({ map = 33, phase = 1 }), "ValidSpawn: Instanz verworfen")
T.ok(not Lib.ValidSpawn({ map = 0, phase = 2 }), "ValidSpawn: andere Phase verworfen")
T.ok(Lib.ValidSpawn({ map = 1, phase = 3 }), "ValidSpawn: Phase-Maske mit Bit 1")

-- ZoneOf (echte Rohdaten) --------------------------------------------------------------------
local spawnOf = {}
for _, t in ipairs(src.trainers) do spawnOf[t.entry] = t.spawns[1] end
local function copy(s, patch)
    local c = {}
    for k, v in pairs(s) do c[k] = v end
    for k, v in pairs(patch or {}) do c[k] = v end
    return c
end

local timofey = spawnOf[28697]
T.ok(timofey ~= nil, "Rohdaten: Timofey vorhanden")
if timofey then
    T.eq((Lib.ZoneOf(timofey, src)), "Dalaran", "ZoneOf: Timofey (z 642) in Dalaran")
    local file, sub = Lib.ZoneOf(copy(timofey, { z = 150 }), src)
    T.eq(file, "CrystalsongForest", "ZoneOf: gleiche Stelle bei z 150 ist Kristallsangwald")
    T.ok(sub ~= nil, "ZoneOf: Kristallsangwald mit Unterzone")
end

-- ein Lehrer in Unterstadt: unter der Erde Stadt, an der Oberflaeche Tirisfal
local uc
for _, t in ipairs(src.trainers) do
    local s = t.spawns[1]
    if s and Lib.ValidSpawn(s) and Lib.ZoneOf(s, src) == "Undercity" then uc = s break end
end
T.ok(uc ~= nil, "Rohdaten: mindestens ein Lehrer in Unterstadt")
if uc then
    T.ok(uc.z < 0, "Unterstadt-Lehrer liegt unter der Erde")
    T.eq((Lib.ZoneOf(copy(uc, { z = 60 }), src)), "Tirisfal", "ZoneOf: gleiche Stelle an der Oberflaeche ist Tirisfal")
end

local spring = spawnOf[5174]
if spring then
    T.eq(Lib.RootOf(spring.adtArea, src.areas), 1, "Sprungspindel: ADT meldet Dun Morogh")
    T.eq((Lib.ZoneOf(spring, src)), "Ironforge", "ZoneOf: Eisenschmiede aus Dun-Morogh-ADT")
end

local sinbei = spawnOf[33634]
if sinbei then
    local file, sub = Lib.ZoneOf(sinbei, src)
    T.eq(file, "ShattrathCity", "ZoneOf: Sinbei in Shattrath")
    T.eq(sub, 3898, "ZoneOf: Unterzone Sehertreppe")
end
T.eq((Lib.ZoneOf({ map = 0, x = 0, y = 0, z = 0, adtArea = 0 }, src)), nil, "ZoneOf: ohne ADT-Area keine Zone")

-- ToMapXY: Verifikationspunkte (Formel-Ist aus der Recherche, Toleranz 0.1) -------------------
local POINTS = {
    { "Stormwind", -8347.0, 644.134, 62.09, 30.32 },
    { "Dalaran", 5923.3, 733.456, 38.44, 25.91 },
    { "Ogrimmar", 2038.4, -4748.98, 76.17, 25.17 },
    { "ShattrathCity", -2041.29, 5561.97, 43.89, 65.15 },
    { "SilvermoonCity", 9822.16, -7333.16, 76.97, 41.10 },
    { "DunMorogh", -5531.17, -669.07, 50.18, 50.38 },
    { "HowlingFjord", 1904.8, -6137.54, 78.39, 30.06 },
}
for _, p in ipairs(POINTS) do
    local z = src.zones[p[1]]
    T.ok(z ~= nil, "Zone in Rohdaten: " .. p[1])
    if z then
        local x, y = Lib.ToMapXY(z, p[2], p[3])
        T.ok(math.abs(x - p[4]) <= 0.1 and math.abs(y - p[5]) <= 0.1,
            string.format("ToMapXY %s: %.1f/%.1f ~ %.2f/%.2f", p[1], x, y, p[4], p[5]))
    end
end
-- vertauschte Achsen wuerden auffallen
local zx, zy = Lib.ToMapXY({ left = 100, right = 0, top = 200, bottom = 0 }, 150, 25)
T.eq(zx, 75, "ToMapXY: x aus Welt-Y")
T.eq(zy, 25, "ToMapXY: y aus Welt-X")

-- Quote / Serialize --------------------------------------------------------------------------
T.eq(Lib.Quote("\195\164\"\\"), '"\\195\\164\\"\\\\"', "Quote: Nicht-ASCII als \\ddd, Escape von \" und \\")

local data, report = Lib.Build(src)
local text1 = Lib.Serialize(data)
local text2 = Lib.Serialize((Lib.Build(src)))
T.eq(text1, text2, "Serialize ist deterministisch")
T.ok(not text1:find("[\128-\255]"), "Serialize schreibt nur ASCII")

local excluded = 0
for _, line in ipairs(report) do
    if line:find("^Platzhalter") then excluded = excluded + 1 end
end
T.eq(excluded, 8, "Report: 8 Platzhalter ausgeschlossen")

-- Regenerations-Check ------------------------------------------------------------------------
local f = io.open(root .. "/Professions/TrainerData.lua", "rb")
T.ok(f ~= nil, "Professions/TrainerData.lua vorhanden")
if f then
    local committed = f:read("*a")
    f:close()
    T.ok(committed == text1,
        "TrainerData.lua entspricht dem Generator (lua5.1 Tools/gen_trainers.lua neu ausfuehren)")
end
