-- ProfessionPilot Core/Advisor.lua
-- Pure cost-advice logic: recipe-alternative comparison and buy-vs-craft
-- verdicts for craftable intermediates. No WoW API calls, no UI, no state --
-- prices and reagent costs come in through arguments/injected callbacks,
-- which keeps this file testable under plain Lua 5.1 (Tests/test_advisor.lua).
-- The runtime feeder lives in Modules/AltAdvisor.lua.

local PP = _G.ProfessionPilot
local Advisor = {}
PP.Advisor = Advisor

-- Compare the current recipe's reagent cost against its alternatives.
--   mainCost  copper per craft of the step's main recipe, or nil (unknown)
--   altCosts  array of { spellId = n, cost = copper } -- entries with a
--             missing/non-numeric cost are skipped (recipe not comparable)
-- Returns { spellId, cost, saving } for the cheapest alternative that is
-- STRICTLY cheaper than the main recipe (saving = mainCost - cost > 0),
-- or nil when the main cost is unknown or no alternative beats it.
function Advisor.CompareCosts(mainCost, altCosts)
    if type(mainCost) ~= "number" then return nil end

    local best
    for i = 1, #(altCosts or {}) do
        local alt = altCosts[i]
        if alt and alt.spellId and type(alt.cost) == "number" then
            if not best or alt.cost < best.cost then
                best = alt
            end
        end
    end

    if not best or best.cost >= mainCost then return nil end
    return {
        spellId = best.spellId,
        cost = best.cost,
        saving = mainCost - best.cost,
    }
end

-- Buy-vs-craft advice for one material-tree intermediate (a node as built by
-- Calc.BuildMaterialTree/AggregateMaterials: { itemId, missing, crafts,
-- children = { {itemId, need}, ... } }; child needs are already scaled to
-- the missing portion of the parent).
--   priceFn(itemId) -> copper | nil
-- Compares buying node.missing units outright against buying the children's
-- ingredients and crafting. Any unknown price (parent or child) means no
-- advice -- a partial sum would look cheaper than it is. Equal totals give
-- no advice either. Returns { verdict = "buy"|"craft", buyTotal, craftTotal,
-- saving } or nil.
function Advisor.BuyVsCraft(node, priceFn)
    if type(node) ~= "table" or not node.children or #node.children == 0 then
        return nil
    end
    local missing = node.missing or 0
    if missing <= 0 then return nil end

    local unitBuy = priceFn(node.itemId)
    if type(unitBuy) ~= "number" then return nil end

    local craftTotal = 0
    for i = 1, #node.children do
        local child = node.children[i]
        local unit = priceFn(child.itemId)
        if type(unit) ~= "number" then return nil end
        craftTotal = craftTotal + (child.need or 0) * unit
    end

    local buyTotal = missing * unitBuy
    if buyTotal == craftTotal then return nil end

    if buyTotal < craftTotal then
        return { verdict = "buy", buyTotal = buyTotal,
            craftTotal = craftTotal, saving = craftTotal - buyTotal }
    end
    return { verdict = "craft", buyTotal = buyTotal,
        craftTotal = craftTotal, saving = buyTotal - craftTotal }
end

return Advisor
