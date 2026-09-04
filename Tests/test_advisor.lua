-- Tests for Core/Advisor.lua: recipe-alternative cost comparison and
-- buy-vs-craft verdicts. Pure logic, stub price tables only.

local PP = _G.ProfessionPilot
local Advisor = PP.Advisor

-- === CompareCosts ===========================================================

-- Cheapest strictly-cheaper alternative wins; saving math exact.
local best = Advisor.CompareCosts(1000, {
    { spellId = 10, cost = 800 },
    { spellId = 11, cost = 600 },
    { spellId = 12, cost = 700 },
})
T.ok(best, "compare: cheaper alt found")
T.eq(best.spellId, 11, "compare: cheapest alt wins")
T.eq(best.cost, 600, "compare: winner cost carried")
T.eq(best.saving, 400, "compare: saving = main - alt, exact")

-- nil main cost -> no advice (nothing to compare against).
T.eq(Advisor.CompareCosts(nil, { { spellId = 10, cost = 1 } }), nil,
    "compare: nil main cost -> nil")

-- No alternative cheaper -> nil; equal cost is NOT a saving.
T.eq(Advisor.CompareCosts(500, { { spellId = 10, cost = 500 } }), nil,
    "compare: equal alt -> nil")
T.eq(Advisor.CompareCosts(500, { { spellId = 10, cost = 900 } }), nil,
    "compare: pricier alt -> nil")

-- Empty / nil alternative lists.
T.eq(Advisor.CompareCosts(500, {}), nil, "compare: empty alts -> nil")
T.eq(Advisor.CompareCosts(500, nil), nil, "compare: nil alts -> nil")

-- Alternatives without a computable cost are skipped, not treated as free.
best = Advisor.CompareCosts(1000, {
    { spellId = 10 },                    -- cost unknown
    { spellId = 11, cost = 900 },
})
T.eq(best and best.spellId, 11, "compare: nil-cost alt skipped")
T.eq(best and best.saving, 100, "compare: saving vs known alt only")
T.eq(Advisor.CompareCosts(1000, { { spellId = 10 } }), nil,
    "compare: only unknown-cost alts -> nil")

-- === BuyVsCraft =============================================================

local prices
local function priceFn(itemId) return prices[itemId] end

-- Node shape as produced by Calc.BuildMaterialTree: children scaled to the
-- missing portion. 10 missing widgets; ingredients 20x itemA + 10x itemB.
local function widgetNode()
    return {
        itemId = 100, need = 12, have = 2, missing = 10, crafts = 10,
        children = {
            { itemId = 11, need = 20, have = 0, missing = 20 },
            { itemId = 12, need = 10, have = 0, missing = 10 },
        },
    }
end

-- Craft cheaper: ingredients 20*3 + 10*7 = 130 vs buy 10*50 = 500.
prices = { [100] = 50, [11] = 3, [12] = 7 }
local res = Advisor.BuyVsCraft(widgetNode(), priceFn)
T.ok(res, "bvc: verdict on complete prices")
T.eq(res.verdict, "craft", "bvc: craft cheaper -> craft")
T.eq(res.buyTotal, 500, "bvc: buyTotal = missing * unit, exact")
T.eq(res.craftTotal, 130, "bvc: craftTotal = sum child need * unit, exact")
T.eq(res.saving, 370, "bvc: craft saving exact")

-- Buy cheaper: unit 10 -> 100 vs 130.
prices = { [100] = 10, [11] = 3, [12] = 7 }
res = Advisor.BuyVsCraft(widgetNode(), priceFn)
T.eq(res.verdict, "buy", "bvc: buy cheaper -> buy")
T.eq(res.buyTotal, 100, "bvc: buy buyTotal exact")
T.eq(res.craftTotal, 130, "bvc: buy craftTotal exact")
T.eq(res.saving, 30, "bvc: buy saving exact")

-- Equal totals -> no advice (10 * 13 = 130 = craftTotal).
prices = { [100] = 13, [11] = 3, [12] = 7 }
T.eq(Advisor.BuyVsCraft(widgetNode(), priceFn), nil, "bvc: equal -> nil")

-- Incomplete child price -> nil (partial sums must never advise).
prices = { [100] = 50, [11] = 3 }  -- item 12 unknown
T.eq(Advisor.BuyVsCraft(widgetNode(), priceFn), nil,
    "bvc: unknown child price -> nil")

-- Unknown price of the intermediate itself -> nil.
prices = { [11] = 3, [12] = 7 }
T.eq(Advisor.BuyVsCraft(widgetNode(), priceFn), nil,
    "bvc: unknown parent price -> nil")

-- Nothing missing -> nothing to advise.
prices = { [100] = 50, [11] = 3, [12] = 7 }
local covered = widgetNode()
covered.missing = 0
T.eq(Advisor.BuyVsCraft(covered, priceFn), nil, "bvc: missing 0 -> nil")

-- Leaf nodes (no children) are not intermediates.
T.eq(Advisor.BuyVsCraft({ itemId = 11, need = 5, missing = 5 }, priceFn), nil,
    "bvc: leaf node -> nil")
T.eq(Advisor.BuyVsCraft({ itemId = 11, missing = 5, children = {} }, priceFn),
    nil, "bvc: empty children -> nil")

-- Fractional child needs (glyph-style ink shares) keep exact math:
-- 3 missing, children 1.5x itemA(4c) + 3x itemB(2c) = 12 vs buy 3*5 = 15.
prices = { [200] = 5, [21] = 4, [22] = 2 }
res = Advisor.BuyVsCraft({
    itemId = 200, need = 3, have = 0, missing = 3, crafts = 3,
    children = {
        { itemId = 21, need = 1.5 },
        { itemId = 22, need = 3 },
    },
}, priceFn)
T.eq(res.verdict, "craft", "bvc: fractional needs -> craft")
T.eq(res.craftTotal, 12, "bvc: fractional craftTotal exact")
T.eq(res.saving, 3, "bvc: fractional saving exact")
