-- Integritaet der generierten Lehrerdaten (Professions/TrainerData.lua).

local PP = _G.ProfessionPilot
local D = PP.TrainerData
T.ok(D ~= nil, "PP.TrainerData geladen")
if not D then return end

local EXPECTED = {
    alchemy = 34, blacksmithing = 43, enchanting = 27, engineering = 38,
    inscription = 18, jewelcrafting = 15, leatherworking = 42, tailoring = 31,
}
local keys = 0
for key in pairs(D.trainers) do keys = keys + 1 end
T.eq(keys, 8, "8 Berufe")

local byId = {}
for key, n in pairs(EXPECTED) do
    local list = D.trainers[key]
    T.ok(list ~= nil, "Lehrerliste fuer " .. key)
    T.eq(list and #list or 0, n, "Anzahl Lehrer " .. key)
    T.ok(PP:GetProfession(key) ~= nil, "Key existiert in der Registry: " .. key)
end

local bad = {}
local function fail(msg) bad[#bad + 1] = msg end
for key, list in pairs(D.trainers) do
    local seen = {}
    for _, t in ipairs(list) do
        byId[t.id] = byId[t.id] or t
        local tag = key .. "/" .. tostring(t.id)
        if type(t.id) ~= "number" then fail(tag .. " id") end
        if type(t.name) ~= "string" or t.name == "" then fail(tag .. " name") end
        if t.nameDe ~= nil and type(t.nameDe) ~= "string" then fail(tag .. " nameDe") end
        if t.f ~= "A" and t.f ~= "H" and t.f ~= "N" then fail(tag .. " f") end
        if type(t.ranks) ~= "table" then fail(tag .. " ranks") else
            local last = 0
            for _, r in ipairs(t.ranks) do
                if r <= last or r > 6 then fail(tag .. " ranks Reihenfolge") end
                last = r
            end
            if t.spec and #t.ranks > 0 then fail(tag .. " spec mit Raengen") end
            if not t.spec and #t.ranks == 0 then fail(tag .. " ohne Raenge und nicht spec") end
        end
        if not D.zones[t.map] then fail(tag .. " Zone fehlt " .. tostring(t.map)) end
        if not (t.x > 0 and t.x <= 100 and t.y > 0 and t.y <= 100) then fail(tag .. " Koordinate") end
        if t.area and not D.areas[t.area] then fail(tag .. " Area fehlt") end
        if t.id >= 33608 and t.id <= 33615 then fail(tag .. " Platzhalter") end
        local k = t.id .. "@" .. t.map
        if seen[k] then fail(tag .. " doppelt") end
        seen[k] = true
    end
end
T.eq(#bad, 0, "Felder/Typen ok" .. (#bad > 0 and (": " .. table.concat(bad, ", ")) or ""))

for map, z in pairs(D.zones) do
    T.ok(z.c >= 1 and z.c <= 4, "Kontinent 1..4: " .. map)
    T.ok(z.en ~= "" and z.de ~= "", "Zonennamen en/de: " .. map)
end
T.eq(D.zones.Stormwind.capital, "A", "Sturmwind ist Allianz-Hauptstadt")
T.eq(D.zones.Ogrimmar.capital, "H", "Orgrimmar ist Horde-Hauptstadt")
T.eq(D.zones.ShattrathCity.capital, "N", "Shattrath ist neutral")
T.eq(D.zones.Dalaran.capital, "N", "Dalaran ist neutral")
T.eq(D.zones.SilvermoonCity.c, 2, "Silbermond liegt auf Kontinent 2")
T.eq(D.zones.TheExodar.c, 1, "Exodar liegt auf Kontinent 1")

-- Mindeststufen je Beruf
for key in pairs(EXPECTED) do
    local lv = D.rankLevel[key]
    T.ok(lv ~= nil and #lv == 6, "rankLevel hat 6 Eintraege: " .. key)
end
T.eq(D.rankLevel.engineering[6], 65, "Ingenieur-GM ab Stufe 65")
T.eq(D.rankLevel.blacksmithing[6], 60, "Schmied-GM ab Stufe 60 (DB)")

-- Stichproben (Soll = Formel aus Client-DBC, gegengeprueft mit Wowhead)
local function near(t, map, x, y, label)
    T.ok(t ~= nil, label .. " vorhanden")
    if not t then return end
    T.eq(t.map, map, label .. " Zone")
    T.ok(math.abs(t.x - x) <= 0.15 and math.abs(t.y - y) <= 0.15,
        string.format("%s Position %.1f/%.1f ~ %.1f/%.1f", label, t.x, t.y, x, y))
end
near(byId[5518], "Stormwind", 62.1, 30.3, "Lilliam")
near(byId[28697], "Dalaran", 38.4, 25.9, "Timofey")
near(byId[11017], "Ogrimmar", 76.2, 25.2, "Roxxik")
near(byId[33634], "ShattrathCity", 43.9, 65.2, "Sinbei")
near(byId[5499], "Stormwind", 55.7, 86.1, "Lilyssia (Alchemie Sturmwind)")
near(byId[5174], "Ironforge", 68.5, 43.5, "Sprungspindel (Ingenieur Eisenschmiede)")
near(byId[3363], "Ogrimmar", 63.6, 49.9, "Magar (Schneider Orgrimmar)")
T.eq(byId[33634] and byId[33634].rep, "scryers", "Sinbei braucht Seher-Ruf")
T.eq(byId[16667] and byId[16667].map, "SilvermoonCity", "Danwe in Silbermond")
T.eq(byId[26955] and byId[26955].map, "HowlingFjord", "Jamesina im Heulenden Fjord")
T.eq(byId[24868] and byId[24868].f, "A", "Niobe Allianz (Override)")
T.eq(byId[17215] and #byId[17215].ranks, 1, "Daedal lehrt nur Lehrling")
T.eq(byId[21209] and byId[21209].ranks[#byId[21209].ranks], 4, "Dumphry bis Fachmann")
T.eq(byId[19063] and byId[19063].ranks[#byId[19063].ranks], 6, "Hamanar bis Grossmeister")
T.eq(byId[5518] and byId[5518].nameDe, "Lilliam Spindelfunks", "deutscher Name aus der DB")
T.eq(byId[11073], nil, "Annora (Uldaman) fehlt")

-- GM-only-Lehrer (Alchemie/Verzauberkunst in Dalaran) lehren nur Rang 6
local gmOnly = 0
for _, key in ipairs({ "alchemy", "enchanting" }) do
    for _, t in ipairs(D.trainers[key]) do
        if #t.ranks == 1 and t.ranks[1] == 6 then gmOnly = gmOnly + 1 end
    end
end
T.ok(gmOnly >= 2, "GM-only-Lehrer vorhanden (ranks == {6})")

-- Jeder Rang ist fuer beide Fraktionen bei mindestens einem Lehrer lernbar
local missing = {}
for key, list in pairs(D.trainers) do
    for _, side in ipairs({ "A", "H" }) do
        for r = 1, 6 do
            local ok = false
            for _, t in ipairs(list) do
                if (t.f == side or t.f == "N") and PP.Trainers.Teaches(t, r) then ok = true break end
            end
            if not ok then missing[#missing + 1] = key .. "/" .. side .. "/" .. r end
        end
    end
end
T.eq(#missing, 0, "alle Raenge je Fraktion erreichbar" .. (#missing > 0 and (": " .. table.concat(missing, ", ")) or ""))
