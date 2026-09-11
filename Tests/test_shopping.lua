-- Tests fuer Core/Shopping.lua: Fehlmengen aus dem Materialbaum sammeln,
-- Kaeufe gegen das Haendlersortiment planen, ausstehende Mengen.

local PP = _G.ProfessionPilot
local S = PP.Shopping
local Calc = PP.Calc

local function node(itemId, missing, craftedBy, children)
    return { itemId = itemId, need = missing, have = 0, missing = missing,
        craftedBy = craftedBy, children = children }
end

local function join(t) return table.concat(t, ",") end

local function offer(index, itemId, price, lot, available, maxStack, ext)
    return { index = index, itemId = itemId, price = price, lot = lot or 1,
        available = available or -1, maxStack = maxStack or 20,
        extendedCost = ext }
end

-- CollectMissing ------------------------------------------------------------

-- Basismaterial oben und unter einem Zwischenprodukt: summiert, in
-- Erstverwendungs-Reihenfolge. Das Zwischenprodukt selbst zaehlt nicht.
local roots = {
    node(1, 10),                   -- Faden, direkt
    node(2, 5, 900, {              -- Zwischenprodukt (wird hergestellt)
        node(3, 20),               -- Stoff
        node(1, 4),                -- Faden unter dem Zwischenprodukt
    }),
    node(4, 0),                    -- vorhanden, faellt raus
}
local m = S.CollectMissing(roots)
T.eq(#m, 2, "collect: zwei Basismaterialien")
T.eq(m[1].itemId, 1, "collect: Erstverwendung zuerst")
T.eq(m[1].missing, 14, "collect: Faden ueber alle Ebenen summiert (10 + 4)")
T.eq(m[2].itemId, 3, "collect: Kind des Zwischenprodukts")
T.eq(m[2].missing, 20, "collect: Kindmenge")
T.eq(#S.CollectMissing(nil), 0, "collect: nil -> leer")
T.eq(#S.CollectMissing({}), 0, "collect: leerer Baum -> leer")

-- Zusammenspiel mit Calc.AggregateMaterials: Schritt A stellt Ballen her
-- (10 Crafts, 20 Stoff), Schritt B braucht 20 Ballen + 10 Faden. A liefert
-- nur 10 Ballen -> 10 Extra-Crafts -> 20 Stoff mehr. 4 Faden liegen in
-- den Taschen.
local stepA = { minSkill = 1, maxSkill = 10, recipeSpellId = 900,
    learnAtSkill = 1, estimatedCrafts = 10, craftedItemId = 50,
    materials = { { itemId = 3, amount = 20 } } }
local stepB = { minSkill = 10, maxSkill = 20, recipeSpellId = 901,
    learnAtSkill = 10, estimatedCrafts = 10,
    materials = { { itemId = 50, amount = 20, craftedBy = 900 },
                  { itemId = 1, amount = 10 } } }
local prof = { maxSkill = 450, steps = { stepA, stepB },
    producers = { [900] = stepA } }
local ctx = { skill = 1, cap = 450, known = {}, includeBank = true,
    maxSkill = 450, counts = { [1] = { bags = 4, bank = 0 } } }
m = S.CollectMissing(Calc.AggregateMaterials(prof, ctx).entries)
T.eq(#m, 2, "calc: Stoff + Faden")
T.eq(m[1].itemId, 3, "calc: Stoff zuerst (Schritt A)")
T.eq(m[1].missing, 40, "calc: 20 direkt + 20 fuer fehlende Ballen")
T.eq(m[2].itemId, 1, "calc: Faden")
T.eq(m[2].missing, 6, "calc: 10 gebraucht - 4 vorhanden")

-- BuildCalls ----------------------------------------------------------------

T.eq(join(S.BuildCalls(45, 1, 20)), "20,20,5", "calls: Einzelware in Stapeln")
T.eq(join(S.BuildCalls(20, 1, 20)), "20", "calls: genau ein Stapel")
T.eq(join(S.BuildCalls(3, 1, nil)), "1,1,1", "calls: ohne maxStack einzeln")
T.eq(join(S.BuildCalls(3, 5, 1)), "1,1,1", "calls: ein Buendel pro Aufruf")
T.eq(#S.BuildCalls(0, 1, 20), 0, "calls: nichts zu kaufen")

-- PlanPurchases -------------------------------------------------------------

-- Grundfall: Einzelware, unbegrenzt, genug Gold.
local plan = S.PlanPurchases({ { itemId = 1, missing = 45 } },
    { offer(3, 1, 100) }, { money = 1000000 })
T.eq(#plan.items, 1, "plan: ein Item")
local it = plan.items[1]
T.eq(it.index, 3, "plan: Haendler-Index")
T.eq(it.count, 45, "plan: Stueckzahl")
T.eq(it.lots, 45, "plan: Buendel = Stueck bei Einzelware")
T.eq(it.cost, 4500, "plan: Kosten")
T.eq(join(it.calls), "20,20,5", "plan: Aufrufe nach maxStack")
T.eq(it.capped, nil, "plan: ungedeckelt")
T.eq(plan.total, 4500, "plan: Summe")

-- Items, die der Haendler nicht fuehrt, fallen still heraus.
plan = S.PlanPurchases({ { itemId = 7, missing = 3 } }, { offer(1, 1, 100) }, {})
T.eq(#plan.items + #plan.skipped, 0, "plan: nicht gefuehrt -> nichts")

-- Buendelware: aufrunden, ein Buendel pro Aufruf.
plan = S.PlanPurchases({ { itemId = 1, missing = 12 } },
    { offer(2, 1, 250, 5) }, {})
it = plan.items[1]
T.eq(it.lots, 3, "buendel: 12 Stueck -> 3 Buendel a 5")
T.eq(it.count, 15, "buendel: Ueberschuss unter einem Buendel")
T.eq(it.cost, 750, "buendel: Preis gilt pro Buendel")
T.eq(join(it.calls), "1,1,1", "buendel: je Aufruf ein Buendel")

-- Begrenzter Vorrat.
plan = S.PlanPurchases({ { itemId = 1, missing = 10 } },
    { offer(1, 1, 100, 1, 4) }, {})
T.eq(plan.items[1].count, 4, "vorrat: nur 4 da")
T.eq(plan.items[1].capped, "stock", "vorrat: als gedeckelt markiert")
plan = S.PlanPurchases({ { itemId = 1, missing = 10 } },
    { offer(1, 1, 100, 1, 0) }, {})
T.eq(#plan.items, 0, "ausverkauft: kein Kauf")
T.eq(plan.skipped[1] and plan.skipped[1].reason, "stock",
    "ausverkauft: Grund stock")

-- Gold: der Reihe nach; der Rest wird gedeckelt bzw. uebersprungen.
plan = S.PlanPurchases(
    { { itemId = 1, missing = 10 }, { itemId = 2, missing = 10 },
      { itemId = 3, missing = 1 } },
    { offer(1, 1, 100), offer(2, 2, 100), offer(3, 3, 5000) },
    { money = 1500 })
T.eq(plan.items[1].count, 10, "gold: erstes Item voll")
T.eq(plan.items[1].capped, nil, "gold: erstes ungedeckelt")
T.eq(plan.items[2].count, 5, "gold: zweites nur so weit das Gold reicht")
T.eq(plan.items[2].capped, "money", "gold: zweites gedeckelt")
T.eq(plan.skipped[1] and plan.skipped[1].itemId, 3, "gold: drittes uebersprungen")
T.eq(plan.skipped[1] and plan.skipped[1].reason, "money", "gold: Grund money")
T.eq(plan.total, 1500, "gold: Summe = verfuegbares Gold")

-- money = nil heisst unbegrenzt.
plan = S.PlanPurchases({ { itemId = 1, missing = 1000 } },
    { offer(1, 1, 100) }, {})
T.eq(plan.items[1].count, 1000, "gold: ohne Angabe unbegrenzt")

-- Sonderwaehrung wird uebersprungen; ein Goldangebot gewinnt trotzdem.
plan = S.PlanPurchases({ { itemId = 1, missing = 2 } },
    { offer(1, 1, 0, 1, -1, 20, true) }, {})
T.eq(#plan.items, 0, "waehrung: kein Kauf")
T.eq(plan.skipped[1] and plan.skipped[1].reason, "currency",
    "waehrung: Grund currency")
plan = S.PlanPurchases({ { itemId = 1, missing = 2 } },
    { offer(1, 1, 0, 1, -1, 20, true), offer(4, 1, 300) }, {})
T.eq(plan.items[1] and plan.items[1].index, 4,
    "waehrung: Goldangebot wird genommen")
T.eq(#plan.skipped, 0, "waehrung: kein Hinweis, wenn es Gold auch tut")

-- Doppeltes Angebot: guenstigster Stueckpreis (Buendel beruecksichtigt).
plan = S.PlanPurchases({ { itemId = 1, missing = 10 } },
    { offer(1, 1, 120), offer(2, 1, 500, 5) }, {})
T.eq(plan.items[1].index, 2, "doppelt: 100/Stueck im 5er schlaegt 120 einzeln")

-- Ausstehende Kaeufe werden abgezogen.
plan = S.PlanPurchases({ { itemId = 1, missing = 10 } }, { offer(1, 1, 100) },
    { outstanding = { [1] = 6 } })
T.eq(plan.items[1].count, 4, "outstanding: 10 fehlen, 6 unterwegs -> 4")
plan = S.PlanPurchases({ { itemId = 1, missing = 10 } }, { offer(1, 1, 100) },
    { outstanding = { [1] = 10 } })
T.eq(#plan.items + #plan.skipped, 0, "outstanding: alles unterwegs -> nichts")

-- Notes ---------------------------------------------------------------------

plan = {
    items = { { itemId = 1, count = 4, capped = "stock" },
              { itemId = 2, count = 9 } },
    skipped = { { itemId = 3, reason = "money", want = 5 } },
    total = 0,
}
local notes = S.Notes(plan)
T.eq(#notes, 2, "notes: gedeckelt + uebersprungen")
T.eq(notes[1].kind, "capped_stock", "notes: Deckelung zuerst")
T.eq(notes[1].count, 4, "notes: gekaufte Menge")
T.eq(notes[2].kind, "skip_money", "notes: uebersprungen")
T.eq(notes[2].count, 5, "notes: gewollte Menge")

-- Outstanding ---------------------------------------------------------------

local out, any = S.Outstanding({ [1] = 30, [2] = 10 },
    { [1] = { bags = 25, bank = 0 }, [2] = { bags = 12, bank = 0 } })
T.eq(out[1], 5, "outstanding: 5 fehlen noch")
T.eq(out[2], nil, "outstanding: Ziel erreicht -> kein Eintrag")
T.eq(any, true, "outstanding: noch etwas offen")
out, any = S.Outstanding({ [1] = 30 }, { [1] = { bags = 30 } })
T.eq(any, false, "outstanding: alles angekommen")
out, any = S.Outstanding({ [5] = 3 }, {})
T.eq(out[5], 3, "outstanding: ungezaehltes Item zaehlt als 0")
T.eq(any, true, "outstanding: ungezaehltes Item ist offen")
out, any = S.Outstanding(nil, nil)
T.eq(any, false, "outstanding: nil -> nichts offen")
