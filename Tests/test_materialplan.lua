-- Tests fuer Core/MaterialPlan.lua: flache Blattliste, Zwischenprodukte,
-- Bestand ohne Doppelzaehlung, Fehlerfaelle, Stringform (Rundlauf, Format).

local PP = _G.ProfessionPilot
local MP = PP.MaterialPlan
local leather = PP:GetProfession("leatherworking")

local function planOf(skill, toSkill, counts, includeBank, extra)
    local input = { skill = skill, cap = 300, counts = counts or {},
        includeBank = includeBank, countsReady = true, toSkill = toSkill }
    for k, v in pairs(extra or {}) do input[k] = v end
    return MP.Build(leather, input)
end

local function leafOf(plan, itemId)
    for _, e in ipairs(plan.leaves) do
        if e.itemId == itemId then return e end
    end
    return nil
end

-- Unabhaengiges Orakel: Rohsumme der Schrittmengen eines Items ueber alle
-- Schritte, die zwischen skill und toSkill liegen (gilt, wenn skill auf einer
-- Schrittgrenze steht, sonst wird der erste Schritt anteilig gerechnet).
local function rawSum(prof, itemId, skill, toSkill)
    local sum = 0
    for _, s in ipairs(prof.steps) do
        if s.maxSkill > skill and s.minSkill < toSkill then
            for _, m in ipairs(s.materials) do
                if m.itemId == itemId then sum = sum + m.amount end
            end
        end
    end
    return sum
end

-- Lederverarbeitung 290 -> 450 ohne Bestand -----------------------------------

local p = planOf(290, 450)
T.ok(p.ok, "Plan 290->450 ist ok")
T.eq(p.apiVersion, 1, "apiVersion 1")
T.eq(PP.API_VERSION, 1, "PP.API_VERSION 1")
T.eq(p.profession, "leatherworking", "Berufsschluessel im Plan")
T.eq(p.skill, 290, "Skill im Plan")
T.eq(p.cap, 300, "Rang-Maximum im Plan")
T.eq(p.maxSkill, 450, "Berufsmaximum im Plan")
T.eq(p.toSkill, 450, "Zielskill im Plan")
T.eq(p.coveredToSkill, 450, "abgedeckt bis 450")
T.eq(p.countsReady, true, "countsReady durchgereicht")
T.eq(p.includeBank, false, "Bank standardmaessig aus")

-- Rugged / Knothide: Blaetter entsprechen den Rohsummen der Schritte.
for _, id in ipairs({ 8170, 21887, 2325, 14341, 38558, 44128 }) do
    local e = leafOf(p, id)
    T.ok(e ~= nil, "Blatt " .. id .. " vorhanden")
    if e then
        T.eq(e.need, rawSum(leather, id, 290, 450), "Bedarf " .. id .. " = Rohsumme")
        T.eq(e.missing, e.need, "ohne Bestand fehlt alles: " .. id)
        T.eq(e.bags, 0, "bags 0: " .. id)
        T.eq(e.bank, 0, "bank 0: " .. id)
        T.eq(e.have, 0, "have 0: " .. id)
    end
end
T.eq(leafOf(p, 8170).need, 120, "Rugged Leather 290->450: 120")
T.eq(leafOf(p, 21887).need, 450, "Knothide Leather 290->450: 450")

-- Zwischenprodukte sind keine Blaetter und werden zu ihren Rohstoffen aufgeloest.
T.eq(leafOf(p, 38425), nil, "Heavy Borean Leather ist kein Blatt")
T.eq(leafOf(p, 23793), nil, "Heavy Knothide Leather ist kein Blatt")
local heavyBorean = leather.producers[50936]
local perCraft
for _, m in ipairs(heavyBorean.materials) do
    if m.itemId == 33568 then perCraft = m.amount / heavyBorean.estimatedCrafts end
end
local chainCrafts = 322 - 300  -- 322 verbraucht, 300 hergestellt (Kopfkommentar der Datendatei)
T.eq(#p.intermediates, 1, "genau ein Zwischenprodukt mit zusaetzlichen Crafts")
T.eq(p.intermediates[1].itemId, 38425, "Zwischenprodukt Heavy Borean Leather")
T.eq(p.intermediates[1].recipeSpellId, 50936, "Rezept 50936")
T.eq(p.intermediates[1].crafts, chainCrafts, "22 zusaetzliche Crafts")
T.eq(leafOf(p, 33568).need, rawSum(leather, 33568, 290, 450) + chainCrafts * perCraft,
    "Borean Leather = Rohsumme + aufgeloeste Kette")

-- Alle Blaetter haben kein craftedBy-Feld und sind nach itemId sortiert.
local sorted = true
for i = 2, #p.leaves do
    if p.leaves[i - 1].itemId >= p.leaves[i].itemId then sorted = false end
end
T.ok(sorted, "Blaetter nach itemId sortiert und eindeutig")

-- Thick Leather: nur bei niedrigerem Startskill im Plan (Orakel gegen Rohsumme).
local low = planOf(205, 450)
for _, id in ipairs({ 4304, 8170, 21887 }) do
    local e = leafOf(low, id)
    T.ok(e ~= nil, "205->450 Blatt " .. id)
    if e then T.eq(e.need, rawSum(leather, id, 205, 450), "205->450 Bedarf " .. id .. " = Rohsumme") end
end
T.eq(leafOf(p, 4304), nil, "290->450 braucht kein Thick Leather")

-- Zielskill frei waehlbar, schrittgenau ----------------------------------------

local mid = planOf(290, 375)
T.eq(mid.toSkill, 375, "Zielskill 375")
T.eq(mid.coveredToSkill, 380, "375 liegt im Schritt 350-380: abgedeckt bis 380")
T.eq(leafOf(mid, 38558), nil, "Nerubian Chitin erst nach 375 noetig")
T.eq(leafOf(mid, 21887).need, 450, "Knothide Leather liegt komplett vor 380")
T.eq(#mid.intermediates, 0, "bis 375 keine Kette")
T.ok(leafOf(mid, 8170).need == 120, "Rugged bis 375 unveraendert 120")
T.ok(#mid.leaves < #p.leaves, "kuerzerer Plan hat weniger Blaetter")

local one = planOf(290, 300)
T.eq(one.coveredToSkill, 300, "290->300 genau ein Schritt")
T.ok(leafOf(one, 8170).need > 0, "Schritt 290-300 braucht Rugged Leather")

local reached = planOf(290, 290)
T.ok(reached.ok, "Ziel = Skill ist ok")
T.eq(#reached.leaves, 0, "nichts zu farmen")
T.eq(reached.coveredToSkill, 290, "abgedeckt bis zum Skill")
T.eq(planOf(290, 100).coveredToSkill, 290, "Ziel unter Skill: nichts zu tun")
T.eq(#planOf(290, 100).leaves, 0, "Ziel unter Skill: leere Liste")

T.eq(planOf(290, 9999).toSkill, 450, "Zielskill ueber dem Maximum wird begrenzt")
T.eq(planOf(290, nil).toSkill, 450, "ohne Zielskill: Berufsmaximum")
T.eq(planOf(290, 375.9).toSkill, 375, "Zielskill wird abgerundet")
T.eq(planOf(450, 450).coveredToSkill, 450, "Skill 450: leerer Plan")
T.eq(#planOf(450, 450).leaves, 0, "Skill 450: nichts zu farmen")

-- Bestand: Taschen, Bank, keine Doppelzaehlung ---------------------------------

local counts = { [8170] = { bags = 12, bank = 100 }, [21887] = { bags = 500, bank = 0 } }
local bagsOnly = planOf(290, 450, counts, false)
local withBank = planOf(290, 450, counts, true)
T.eq(leafOf(bagsOnly, 8170).missing, 108, "Rugged ohne Bank: 120 - 12")
T.eq(leafOf(withBank, 8170).missing, 8, "Rugged mit Bank: 120 - 112")
T.eq(leafOf(bagsOnly, 8170).bags, 12, "bags unabhaengig von includeBank")
T.eq(leafOf(bagsOnly, 8170).bank, 100, "bank wird auch ohne includeBank gemeldet")
T.eq(leafOf(bagsOnly, 8170).have, 12, "have ohne Bank = Taschen")
T.eq(leafOf(withBank, 8170).have, 112, "have mit Bank = Taschen + Bank")
T.eq(withBank.includeBank, true, "includeBank im Plan")
T.eq(leafOf(bagsOnly, 21887).missing, 0, "Ueberschuss: missing nie negativ")
T.eq(leafOf(bagsOnly, 21887).have, 500, "have meldet den echten Bestand")

-- Sonderfall ohne Herstellung im Bereich: Wird ein Item von keinem Levelschritt
-- zwischen Skill und Ziel hergestellt, gilt missing == max(0, need - have). Der
-- Bestand eines Items wird genau einmal abgezogen, egal an wie vielen Stellen
-- im Baum es vorkommt (direkter Bedarf + Kettenzutaten). Allgemein gilt das
-- NICHT (siehe unten): verbindlich ist immer missing, nie need - have.
local function checkInvariant(plan, label)
    for _, e in ipairs(plan.leaves) do
        local expect = e.need - e.have
        if expect < 0 then expect = 0 end
        T.eq(e.missing, expect, label .. " missing == max(0, need - have) ohne Herstellung " .. e.itemId)
    end
end
checkInvariant(p, "leer")
checkInvariant(bagsOnly, "bags")
checkInvariant(withBank, "bank")
local big = {}
for _, s in ipairs(leather.steps) do
    for _, m in ipairs(s.materials) do big[m.itemId] = { bags = 37, bank = 5 } end
end
checkInvariant(planOf(290, 450, big, true), "viel")
checkInvariant(planOf(205, 450, big, false), "viel 205")
checkInvariant(planOf(325, 410, { [33568] = { bags = 1000, bank = 0 } }, false), "borean")

-- Grenze der Gleichung: Light Leather (2318) wird vom Levelschritt 1-20 selbst
-- hergestellt und gutgeschrieben. Lederverarbeitung 1 -> 100 mit 39 Light Leather:
-- need 230, aber missing 172 (nicht 230 - 39 = 191), ohne Bestand missing 211.
local lw0 = planOf(1, 100, {}, false, { cap = 75 })
local lw39 = planOf(1, 100, { [2318] = { bags = 39, bank = 0 } }, false, { cap = 75 })
T.eq(leafOf(lw0, 2318).need, 230, "1->100 ohne Bestand: need 230")
T.eq(leafOf(lw0, 2318).missing, 211, "1->100 ohne Bestand: missing 211 (Ausbeute des Schritts 1-20)")
T.eq(leafOf(lw39, 2318).need, 230, "1->100 mit 39: need unveraendert 230")
T.eq(leafOf(lw39, 2318).have, 39, "1->100 mit 39: have 39")
T.eq(leafOf(lw39, 2318).missing, 172, "1->100 mit 39: missing 172")
T.ok(leafOf(lw39, 2318).missing ~= leafOf(lw39, 2318).need - leafOf(lw39, 2318).have,
    "need - have (191) ist hier NICHT missing")
-- Allgemeine Schranken: 0 <= missing <= need und missing <= max(0, need - have).
local function checkBounds(plan, label)
    for _, e in ipairs(plan.leaves) do
        T.ok(e.missing >= 0 and e.missing <= e.need, label .. " 0 <= missing <= need " .. e.itemId)
        T.ok(e.missing <= math.max(0, e.need - e.have), label .. " missing <= need - have " .. e.itemId)
    end
end
checkBounds(lw0, "1->100")
checkBounds(lw39, "1->100 mit Bestand")
checkBounds(planOf(1, 450, big, true), "1->450 viel")
checkBounds(planOf(1, 450, {}, false), "1->450 leer")

-- need haengt vom Bestand an Zwischenprodukten ab (kein stabiler Bruttobedarf).
local needLeer = leafOf(planOf(290, 450), 33568).need
local needHeavy = leafOf(planOf(290, 450, { [38425] = { bags = 10, bank = 0 } }), 33568).need
T.eq(needLeer, 2315, "Borean need ohne Zwischenprodukt-Bestand")
T.eq(needHeavy, 2255, "Borean need mit 10 Heavy Borean: 12 statt 22 Crafts")

-- Borean Leather kommt direkt und ueber die Kette vor: 1000 im Beutel decken
-- die Rohsumme, der Rest geht in die Kette -- insgesamt nie mehr als need - Bestand.
local boreanBag = planOf(290, 450, { [33568] = { bags = 1000, bank = 0 } }, false)
T.eq(leafOf(boreanBag, 33568).need, 2315, "Borean-Bedarf unabhaengig vom Bestand")
T.eq(leafOf(boreanBag, 33568).missing, 1315, "Borean: 2315 - 1000, einmal abgezogen")

-- Besitzt der Spieler die Zwischenprodukte, entfaellt die Kette.
local hasHeavy = planOf(290, 450, { [38425] = { bags = 22, bank = 0 } }, false)
T.eq(#hasHeavy.intermediates, 0, "22 Heavy Borean Leather im Beutel: keine Kette")
T.eq(leafOf(hasHeavy, 33568).need, rawSum(leather, 33568, 290, 450),
    "Borean ohne Kettenzuschlag")
-- Teilbestand: nur die Differenz wird hergestellt.
local halfHeavy = planOf(290, 450, { [38425] = { bags = 11, bank = 0 } }, false)
T.eq(halfHeavy.intermediates[1].crafts, 11, "11 Heavy Borean fehlen noch")
T.eq(leafOf(halfHeavy, 33568).need, rawSum(leather, 33568, 290, 450) + 11 * perCraft,
    "halbe Kette halber Zuschlag")

-- countsReady / bankScanned ----------------------------------------------------

T.eq(planOf(290, 450, {}, false, { countsReady = false }).countsReady, false,
    "countsReady false bleibt false")
T.eq(MP.Build(leather, { skill = 290, counts = {} }).countsReady, false,
    "fehlendes countsReady zaehlt als false")
T.eq(planOf(290, 450, {}, false, { bankScanned = true }).bankScanned, true,
    "bankScanned durchgereicht")
T.eq(planOf(290, 450).bankScanned, false, "bankScanned Standard false")
-- includeBank ohne gelesene Bank: bank bleibt 0, der Plan sagt es ehrlich.
local noBank = planOf(290, 450, { [8170] = { bags = 12, bank = 0 } }, true)
T.eq(noBank.includeBank, true, "includeBank true ohne gelesene Bank")
T.eq(noBank.bankScanned, false, "bankScanned false: Bank nie gelesen")
T.eq(leafOf(noBank, 8170).missing, 108, "ohne gelesene Bank zaehlt nur die Tasche")
T.eq(MP.ToString(noBank):match("^v1|%a+|%a+|%d+|%d+|%d+|%d+|(%d)|(%d)|"), "1",
    "String: includeBank 1")

-- Fehlerfaelle -----------------------------------------------------------------

local function errOf(prof, input) local r = MP.Build(prof, input) return r.ok, r.error end
local ok, e = errOf(nil, { skill = 10 })
T.eq(ok, false, "kein Beruf: nicht ok")
T.eq(e, "unknown_profession", "kein Beruf: unknown_profession")
ok, e = errOf({}, { skill = 10 })
T.eq(e, "unknown_profession", "Beruf ohne Schritte: unknown_profession")
ok, e = errOf(leather, { skill = 0 })
T.eq(e, "no_profession", "Skill 0: no_profession")
ok, e = errOf(leather, {})
T.eq(e, "no_profession", "Skill fehlt: no_profession")
ok, e = errOf(leather, { skill = "290" })
T.eq(e, "no_profession", "Skill als String: no_profession")
ok, e = errOf(leather, nil)
T.eq(e, "bad_args", "kein input: bad_args")
ok, e = errOf(leather, { skill = 290, toSkill = "375" })
T.eq(e, "bad_args", "Zielskill als String: bad_args")
ok, e = errOf(leather, { skill = 290, toSkill = 0 })
T.eq(e, "bad_args", "Zielskill 0: bad_args")
ok, e = errOf(leather, { skill = 290, toSkill = -5 })
T.eq(e, "bad_args", "Zielskill negativ: bad_args")
ok, e = errOf(leather, { skill = 290, toSkill = 0 / 0 })
T.eq(e, "bad_args", "Zielskill NaN: bad_args")
T.eq(MP.Build(leather, { skill = 290, toSkill = 375 }).leaves ~= nil, true,
    "counts darf fehlen")
T.ok(MP.Fail("not_ready").apiVersion == 1, "Fail traegt apiVersion")
T.eq(#MP.ERRORS, 4, "vier dokumentierte Fehlercodes")

-- Mini-Beruf: numMade > 1, Ueberschuss wird gutgeschrieben ----------------------
-- Pulver (numMade 2, 3 Stein je Craft); Verbraucher braucht 5 + 1 Pulver.
-- 5 fehlen -> 3 Crafts = 6 Pulver, 1 Rest deckt den zweiten Verbraucher.
local mini = PP:RegisterProfession({
    key = "mp_mini", professionSpellId = 9001, maxSkill = 40, ranks = { 40 },
    steps = {
        { minSkill = 1, maxSkill = 10, recipeSpellId = 7001, craftedItemId = 7101,
          numMade = 2, learnAtSkill = 1, estimatedCrafts = 5,
          materials = { { itemId = 7201, amount = 15 } } },
        { minSkill = 10, maxSkill = 20, recipeSpellId = 7002, craftedItemId = 7102,
          learnAtSkill = 10, estimatedCrafts = 5,
          materials = { { itemId = 7101, amount = 5, craftedBy = 7001 },
                        { itemId = 7202, amount = 5 } } },
        { minSkill = 20, maxSkill = 30, recipeSpellId = 7003, craftedItemId = 7103,
          learnAtSkill = 20, estimatedCrafts = 1,
          materials = { { itemId = 7101, amount = 1, craftedBy = 7001 } } },
    },
})
local m = MP.Build(mini, { skill = 10, counts = {}, toSkill = 30, countsReady = true })
T.eq(leafOf(m, 7201).need, 9, "Stein: 3 Crafts * 3, Rest des 2. Verbrauchers aus dem Ueberschuss")
T.eq(leafOf(m, 7201).missing, 9, "Stein fehlt komplett")
T.eq(leafOf(m, 7202).need, 5, "direkte Zutat")
T.eq(leafOf(m, 7101), nil, "Pulver ist kein Blatt")
T.eq(m.intermediates[1].crafts, 3, "3 Crafts")
T.eq(m.intermediates[1].itemId, 7101, "Zwischenprodukt Pulver")
local m2 = MP.Build(mini, { skill = 10, counts = { [7201] = { bags = 4, bank = 0 } },
    toSkill = 30, countsReady = true })
T.eq(leafOf(m2, 7201).missing, 5, "Stein 9 - 4")
local m3 = MP.Build(mini, { skill = 10, counts = { [7101] = { bags = 6, bank = 0 } },
    toSkill = 30, countsReady = true })
T.eq(#m3.intermediates, 0, "6 Pulver im Beutel: keine Kette")
T.eq(leafOf(m3, 7201), nil, "ohne Kette kein Stein")
T.eq(MP.Build(mini, { skill = 10, toSkill = 15 }).coveredToSkill, 20, "Mini: 15 liegt im Schritt 10-20")

-- Stringform ---------------------------------------------------------------------

-- Goldener String: Aenderungen am Format muessen API_VERSION erhoehen.
T.eq(MP.ToString(planOf(290, 450)),
    "v1|ready|leatherworking|290|300|450|450|0|0|"
    .. "2325:10:0:0:10;8170:120:0:0:120;14341:32:0:0:32;21887:450:0:0:450;"
    .. "33568:2315:0:0:2315;35622:18:0:0:18;35627:50:0:0:50;36860:50:0:0:50;"
    .. "37705:65:0:0:65;38558:10:0:0:10;43102:15:0:0:15;44128:10:0:0:10"
    .. "|38425:50936:22",
    "goldener String Lederverarbeitung 290->450")
T.eq(MP.ToString(planOf(290, 450, counts, true)):match("8170:%d+:%d+:%d+:%d+"),
    "8170:120:12:100:8", "Leaf-Feld mit Taschen, Bank und fehlender Menge")
T.eq(MP.ToString(planOf(290, 450, {}, false, { countsReady = false })):sub(1, 11),
    "v1|notready", "notready im String")
T.eq(MP.ToString(planOf(290, 450, {}, true)):match("^v1|%a+|%a+|%d+|%d+|%d+|%d+|(%d)|"),
    "1", "includeBank-Flag im String")
T.eq(MP.ToString(planOf(290, 450, {}, true, { bankScanned = true })):match("^v1|%a+|%a+|%d+|%d+|%d+|%d+|%d|(%d)|"),
    "1", "bankScanned-Flag im String")
local sTo, sCov = MP.ToString(planOf(290, 375)):match("^v1|%a+|%a+|%d+|%d+|(%d+)|(%d+)|")
T.eq(sTo, "375", "toSkill 375 im String")
T.eq(sCov, "380", "coveredToSkill 380 im String")
T.eq(MP.ToString(planOf(290, 290)), "v1|ready|leatherworking|290|300|290|290|0|0||",
    "leere Listen sind leere Felder")
T.eq(MP.ToString(MP.Fail("no_profession")), "v1|err|no_profession", "Fehlerstring")
T.eq(MP.ToString(nil), "v1|err|bad_args", "ToString(nil)")
T.eq(MP.ToString({ ok = false }), "v1|err|bad_args", "Fehler ohne Code")

-- Keine Itemnamen, nur [a-z0-9_|:;] -- leicht parsebar.
T.ok(not MP.ToString(planOf(290, 450, counts, true)):find("[^%l%d_|:;]"),
    "String enthaelt nur Kleinbuchstaben, Ziffern, _ | : ;")
T.ok(not MP.ToString(planOf(290, 450, counts, true)):find("%-"),
    "String enthaelt keine negative Null")

-- Rundlauf: Parse(ToString(plan)) liefert dieselben Werte.
local function roundTrip(plan, label)
    local back = MP.Parse(MP.ToString(plan))
    T.ok(back.ok, label .. ": Parse ok")
    T.eq(back.profession, plan.profession, label .. ": Beruf")
    T.eq(back.skill, plan.skill, label .. ": Skill")
    T.eq(back.cap, plan.cap, label .. ": Cap")
    T.eq(back.toSkill, plan.toSkill, label .. ": Zielskill")
    T.eq(back.coveredToSkill, plan.coveredToSkill, label .. ": coveredToSkill")
    T.eq(back.bankScanned, plan.bankScanned, label .. ": bankScanned")
    T.eq(back.includeBank, plan.includeBank, label .. ": includeBank")
    T.eq(back.countsReady, plan.countsReady, label .. ": countsReady")
    T.eq(#back.leaves, #plan.leaves, label .. ": Anzahl Blaetter")
    T.eq(#back.intermediates, #plan.intermediates, label .. ": Anzahl Zwischenprodukte")
    for i = 1, #plan.leaves do
        local a, b = plan.leaves[i], back.leaves[i]
        T.ok(b and a.itemId == b.itemId and a.need == b.need and a.bags == b.bags
            and a.bank == b.bank and a.missing == b.missing and a.have == b.have,
            label .. ": Blatt " .. a.itemId)
    end
    for i = 1, #plan.intermediates do
        local a, b = plan.intermediates[i], back.intermediates[i]
        T.ok(b and a.itemId == b.itemId and a.recipeSpellId == b.recipeSpellId
            and a.crafts == b.crafts, label .. ": Zwischenprodukt " .. a.recipeSpellId)
    end
end
roundTrip(planOf(290, 450), "leer")
roundTrip(planOf(290, 450, counts, false), "bags")
roundTrip(planOf(290, 450, counts, true), "bank")
roundTrip(planOf(290, 450, counts, true, { bankScanned = true }), "bank gelesen")
roundTrip(planOf(290, 375), "Ziel 375 (covered 380)")
roundTrip(planOf(290, 450, big, true), "viel")
roundTrip(planOf(205, 450, {}, false, { countsReady = false }), "notready")
roundTrip(planOf(290, 290), "leere Listen")
roundTrip(m, "mini")

-- Parse: Fehlerstring und kaputte Eingaben.
local pe = MP.Parse("v1|err|unknown_profession")
T.eq(pe.ok, false, "Parse Fehlerstring: nicht ok")
T.eq(pe.error, "unknown_profession", "Parse Fehlerstring: Code")
local function bad(s, label)
    local r = MP.Parse(s)
    T.eq(r.ok, false, "Parse lehnt ab: " .. label)
    T.eq(r.error, "bad_format", "Parse bad_format: " .. label)
end
bad(nil, "nil")
bad("", "leer")
bad("garbage", "Muell")
bad("v2|ready|leatherworking|290|300|450|450|0|0||", "andere Version")
bad("v1|ready|leatherworking|290|300|450|450|0|0|", "zu wenige Felder")
bad("v1|ready|leatherworking|290|300|450|0|", "altes 9-Felder-Format")
bad("v1|maybe|leatherworking|290|300|450|450|0|0||", "unbekannter Zustand")
bad("v1|ready||290|300|450|450|0|0||", "leerer Berufsschluessel")
bad("v1|ready|leatherworking|x|300|450|450|0|0||", "Skill nicht numerisch")
bad("v1|ready|leatherworking|290|300|450|x|0|0||", "covered nicht numerisch")
bad("v1|ready|leatherworking|290|300|450|450|2|0||", "includeBank nicht 0/1")
bad("v1|ready|leatherworking|290|300|450|450|0|2||", "bankScanned nicht 0/1")
bad("v1|ready|leatherworking|290|300|450|450|0|0|8170:1:2:3|", "Blatt mit 4 Feldern")
bad("v1|ready|leatherworking|290|300|450|450|0|0|8170:1:2:3:x|", "Blatt nicht numerisch")
bad("v1|ready|leatherworking|290|300|450|450|0|0||38425:50936", "Zwischenprodukt mit 2 Feldern")

-- Zusaetzliche Felder am Ende werden ignoriert (Vorwaertskompatibilitaet innerhalb von v1).
local extra = MP.Parse("v1|ready|leatherworking|290|300|450|450|0|1|8170:120:12:0:108||futurefield|more")
T.ok(extra.ok, "Parse ignoriert zusaetzliche Felder am Ende")
T.eq(extra.coveredToSkill, 450, "Parse: covered")
T.eq(extra.bankScanned, true, "Parse: bankScanned")
T.eq(extra.leaves[1].missing, 108, "Parse: Blatt trotz Zusatzfeldern")

