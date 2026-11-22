-- Reine Logik der Lehrer-Uebersicht (Core/Trainers.lua) mit kleinen Testdaten.

local PP = _G.ProfessionPilot
local Tr = PP.Trainers
T.ok(Tr ~= nil, "PP.Trainers geladen")
if not Tr then return end

local CAPS = { 75, 150, 225, 300, 375, 450 }

-- NextRank -----------------------------------------------------------------------------------
T.eq(Tr.NextRank(CAPS, 0, 0, 450), 1, "nicht erlernt -> Lehrling")
T.eq(Tr.NextRank(CAPS, nil, nil, 450), 1, "ohne Beruf -> Lehrling")
T.eq(Tr.NextRank(CAPS, 70, 75, 450), 2, "Cap 75 -> Geselle")
T.eq(Tr.NextRank(CAPS, 1, 75, 450), 2, "Cap 75 frisch gelernt -> Geselle")
T.eq(Tr.NextRank(CAPS, 290, 300, 450), 5, "Cap 300 -> Meister")
T.eq(Tr.NextRank(CAPS, 375, 375, 450), 6, "Cap 375 -> Grossmeister")
T.eq(Tr.NextRank(CAPS, 450, 450, 450), nil, "Cap 450 -> nichts mehr")

-- Teaches / MaxRank --------------------------------------------------------------------------
local gm = { id = 1, ranks = { 6 } }
T.ok(Tr.Teaches(gm, 6), "GM-only lehrt Rang 6")
T.ok(not Tr.Teaches(gm, 5), "GM-only lehrt nicht Rang 5")
local daedal = { id = 2, ranks = { 1 } }
T.ok(Tr.Teaches(daedal, 1), "Daedal lehrt Lehrling")
T.ok(not Tr.Teaches(daedal, 2), "Daedal lehrt nicht Geselle")
T.ok(not Tr.Teaches({ ranks = {} }, 1), "Spezialisierungslehrer lehrt keinen Rang")
T.eq(Tr.MaxRank({ ranks = { 1, 2, 3, 4 } }), 4, "MaxRank")
T.eq(Tr.MaxRank({ ranks = {} }), nil, "MaxRank ohne Raenge")

T.eq(Tr.FactionCode("Alliance"), "A", "FactionCode Allianz")
T.eq(Tr.FactionCode("Horde"), "H", "FactionCode Horde")
T.eq(Tr.FactionCode("Neutral"), nil, "FactionCode neutral -> alle")

-- Testdaten ----------------------------------------------------------------------------------
local DATA = {
    rankLevel = { test = { 5, 10, 20, 35, 50, 65 } },
    zones = {
        Stormwind = { c = 2, en = "Stormwind City", de = "Sturmwind", capital = "A" },
        Ironforge = { c = 2, en = "Ironforge", de = "Eisenschmiede", capital = "A" },
        Ogrimmar = { c = 1, en = "Orgrimmar", de = "Orgrimmar", capital = "H" },
        ShattrathCity = { c = 3, en = "Shattrath City", de = "Shattrath", capital = "N" },
        Dalaran = { c = 4, en = "Dalaran", de = "Dalaran", capital = "N" },
        Elwynn = { c = 2, en = "Elwynn Forest", de = "Wald von Elwynn" },
        DunMorogh = { c = 2, en = "Dun Morogh", de = "Dun Morogh" },
        Barrens = { c = 1, en = "The Barrens", de = "Brachland" },
        HowlingFjord = { c = 4, en = "Howling Fjord", de = "Der Heulende Fjord" },
    },
    areas = { [87] = { en = "Goldshire", de = "Goldhain" } },
    trainers = {
        test = {
            { id = 10, name = "Ally Low", nameDe = "Alli Niedrig", f = "A", ranks = { 1, 2, 3, 4 }, map = "Stormwind", x = 1, y = 1 },
            { id = 11, name = "Ally Two", f = "A", ranks = { 1, 2 }, map = "Stormwind", x = 1, y = 1 },
            { id = 12, name = "Dwarf", f = "A", ranks = { 1, 2, 3, 4 }, map = "Ironforge", x = 1, y = 1 },
            { id = 13, name = "Goldshire", f = "A", ranks = { 1, 2, 3 }, map = "Elwynn", x = 1, y = 1, area = 87 },
            { id = 14, name = "Dun", f = "A", ranks = { 1, 2 }, map = "DunMorogh", x = 1, y = 1 },
            { id = 20, name = "Orc", f = "H", ranks = { 1, 2, 3, 4 }, map = "Ogrimmar", x = 1, y = 1 },
            { id = 21, name = "Barrens", f = "H", ranks = { 1, 2 }, map = "Barrens", x = 1, y = 1 },
            { id = 30, name = "Shatt", f = "N", ranks = { 1, 2, 3, 4, 5 }, map = "ShattrathCity", x = 1, y = 1, rep = "aldor" },
            { id = 31, name = "Dala GM", f = "N", ranks = { 6 }, map = "Dalaran", x = 1, y = 1 },
            { id = 32, name = "Dala All", f = "N", ranks = { 1, 2, 3, 4, 5, 6 }, map = "Dalaran", x = 1, y = 1 },
            { id = 33, name = "Fjord", f = "H", ranks = { 1, 2, 3, 4, 5, 6 }, map = "HowlingFjord", x = 1, y = 1 },
            { id = 40, name = "Zspec", f = "A", spec = true, ranks = {}, sub = "Gnomish", map = "Ironforge", x = 1, y = 1 },
            { id = 41, name = "Aspec", f = "N", spec = true, ranks = {}, sub = "Goblin", map = "Barrens", x = 1, y = 1 },
        },
    },
}

-- Filter -------------------------------------------------------------------------------------
local function ids(list)
    local s = {}
    for _, t in ipairs(list) do s[t.id] = true end
    return s
end
local a = ids(Tr.Filter(DATA.trainers.test, { faction = "A" }))
T.ok(a[10] and a[30] and a[31], "Allianz sieht Allianz + neutral")
T.ok(not a[20] and not a[33], "Allianz sieht keine Horde")
local h = ids(Tr.Filter(DATA.trainers.test, { faction = "H" }))
T.ok(h[20] and h[33] and h[30], "Horde sieht Horde + neutral")
T.ok(not h[10], "Horde sieht keine Allianz")
T.eq(#Tr.Filter(DATA.trainers.test, {}), 13, "ohne Fraktion alle")
local o6 = ids(Tr.Filter(DATA.trainers.test, { faction = "A", onlyRank = 6 }))
T.ok(o6[31] and o6[32], "onlyRank 6: GM-Lehrer")
T.ok(not o6[30] and not o6[40] and not o6[41], "onlyRank 6: ohne Meister und Spezialisierung")

-- Build: Reihenfolge -------------------------------------------------------------------------
local groups = Tr.Build(DATA, "test", { faction = "A", nextRank = 4, locale = "enUS" })
local order = {}
for i, g in ipairs(groups) do order[i] = g.kind .. ":" .. (g.map or "-") end
T.eq(table.concat(order, " "),
    "capital:Stormwind capital:Ironforge hub:ShattrathCity hub:Dalaran zone:DunMorogh zone:Elwynn spec:-",
    "Gruppenreihenfolge Allianz (Spezialisierungslehrer bilden keine Zonengruppe)")

local hg = Tr.Build(DATA, "test", { faction = "H", locale = "enUS" })
local horder = {}
for i, g in ipairs(hg) do horder[i] = g.kind .. ":" .. (g.map or "-") end
T.eq(table.concat(horder, " "),
    "capital:Ogrimmar hub:ShattrathCity hub:Dalaran zone:Barrens zone:HowlingFjord spec:-",
    "Gruppenreihenfolge Horde (keine Allianz-Hauptstadt)")

local only = Tr.Build(DATA, "test", { faction = "A", onlyRank = 6, nextRank = 6, locale = "enUS" })
T.eq(#only, 1, "onlyRank 6 (Allianz): nur Dalaran")
T.eq(only[1] and only[1].map, "Dalaran", "onlyRank 6: Gruppe Dalaran")

-- Hervorhebung und Sortierung ----------------------------------------------------------------
local sw = groups[1]
T.eq(sw.rows[1].trainer.id, 10, "Sturmwind: Lehrer mit Rang 4 hervorgehoben und oben")
T.ok(sw.rows[1].highlight, "Ally Low hervorgehoben")
T.ok(not sw.rows[2].highlight, "Ally Two (bis Rang 2) nicht hervorgehoben")
local dal = groups[4]
T.eq(dal.rows[1].trainer.id, 32, "Dalaran: hoechster Rang zuerst, dann Name")
local g6 = Tr.Build(DATA, "test", { faction = "A", nextRank = 6, locale = "enUS" })
local d6 = g6[4]
T.ok(d6.rows[1].highlight and d6.rows[2].highlight, "Rang 6: beide Dalaran-Lehrer hervorgehoben")
T.eq(d6.rows[1].trainer.id, 32, "gleiche Hervorhebung -> hoechster Rang zuerst")
T.eq(d6.rows[2].trainer.id, 31, "GM-only danach")
local g5 = Tr.Build(DATA, "test", { faction = "A", nextRank = 5, locale = "enUS" })
T.ok(not g5[4].rows[2].highlight, "GM-only nicht hervorgehoben fuer Rang 5")
T.eq(g5[4].rows[1].trainer.id, 32, "Rang 5: Lehrer mit Rang 5 vor GM-only")
local spec = groups[#groups]
T.eq(spec.kind, "spec", "Spezialisierung zuletzt")
T.eq(spec.rows[1].trainer.id, 41, "Spezialisierung nach Name sortiert")
T.ok(not spec.rows[1].highlight, "Spezialisierung nie hervorgehoben")
T.eq(Tr.Count(groups), 10, "Count Allianz")
T.eq(Tr.HighlightCount(groups), 4, "HighlightCount Rang 4")

local all = Tr.Build(DATA, "test", { locale = "enUS" })
local allorder = {}
for i, g in ipairs(all) do allorder[i] = g.map or "-" end
T.eq(table.concat(allorder, " ", 1, 3), "Stormwind Ironforge Ogrimmar", "ohne Fraktion: Allianz- dann Horde-Hauptstaedte")

T.eq(#Tr.Build(DATA, "nope", { faction = "A" }), 0, "unbekannter Beruf -> keine Gruppen")

-- Lokalisierung ------------------------------------------------------------------------------
local t10 = DATA.trainers.test[1]
T.eq(Tr.LocalName(t10, "deDE"), "Alli Niedrig", "deDE-Name")
T.eq(Tr.LocalName(t10, "enUS"), "Ally Low", "enUS-Name")
T.eq(Tr.LocalName(DATA.trainers.test[2], "deDE"), "Ally Two", "deDE-Fallback auf englisch")
T.eq(Tr.ZoneName(DATA, "Stormwind", "deDE"), "Sturmwind", "Zonenname deDE")
T.eq(Tr.ZoneName(DATA, "Stormwind", "frFR"), "Stormwind City", "andere Sprache -> englisch")
T.eq(Tr.ZoneName(DATA, "Unknown", "deDE"), "Unknown", "unbekannte Zone -> mapFile")
T.eq(Tr.AreaName(DATA, 87, "deDE"), "Goldhain", "Unterzone deDE")
T.eq(Tr.AreaName(DATA, nil, "deDE"), nil, "keine Unterzone")
local gDe = Tr.Build(DATA, "test", { faction = "A", locale = "deDE" })
T.eq(gDe[1].title, "Sturmwind", "Gruppentitel lokalisiert")
local elwynn
for _, g in ipairs(gDe) do if g.map == "Elwynn" then elwynn = g end end
T.eq(elwynn and elwynn.rows[1].sub, "Goldhain", "Zeile mit lokalisierter Unterzone")
T.eq(Tr.RankLevel(DATA, "test", 6), 65, "RankLevel")
T.eq(Tr.RankLevel(DATA, "nope", 6), nil, "RankLevel unbekannt")

local flat = Tr.Flatten(groups)
T.ok(flat[1].header == groups[1], "Flatten: erst Kopf")
T.ok(flat[2].row == groups[1].rows[1], "Flatten: dann Zeilen")
T.eq(#flat, #groups + Tr.Count(groups), "Flatten: Koepfe + Zeilen")
