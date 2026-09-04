-- Tests for Calc.AggregateMaterials: hierarchical totals with projected
-- production, inventory application and expansion of intermediate shortfalls
-- attached as children of the intermediate (no flat double counting).

local PP = _G.ProfessionPilot
local Calc = PP.Calc

local function ctxOf(skill, counts, includeBank)
    return { skill = skill, cap = 450, known = {}, counts = counts or {},
        includeBank = includeBank }
end

-- Top-level node for an item.
local function entryFor(result, itemId)
    for _, e in ipairs(result.entries) do
        if e.itemId == itemId then return e end
    end
    return nil
end

local function childOf(node, itemId)
    for _, c in ipairs((node and node.children) or {}) do
        if c.itemId == itemId then return c end
    end
    return nil
end

-- Sum of a field for an item across the whole tree (top + all children).
local function treeSum(result, itemId, field)
    local total = 0
    Calc.WalkTree(result.entries, function(n)
        if n.itemId == itemId then total = total + n[field] end
    end)
    return total
end

-- Mini fixture: powder (2 stone each) -> bomb consumes 2 powder/craft ----------
local mini = PP:RegisterProfession({
    key = "mini", professionSpellId = 999, maxSkill = 60,
    ranks = { 60 },
    steps = {
        { minSkill = 1, maxSkill = 30, recipeSpellId = 100, craftedItemId = 1001,
          learnAtSkill = 1, estimatedCrafts = 10,
          materials = { { itemId = 11, amount = 20 } } },      -- 10x powder from 20 stone
        { minSkill = 30, maxSkill = 60, recipeSpellId = 200, craftedItemId = 2001,
          learnAtSkill = 30, estimatedCrafts = 10,
          materials = {
              { itemId = 1001, amount = 20, craftedBy = 100 }, -- 2 powder per bomb
              { itemId = 12, amount = 10 },                    -- 1 cloth per bomb
          } },
    },
})

-- From skill 1, empty bags: step 1 produces 10 powder, bombs need 20 ->
-- shortfall 10 -> 10 extra crafts -> 20 stone hang UNDER the powder node.
local r = Calc.AggregateMaterials(mini, ctxOf(1))
T.eq(entryFor(r, 11).need, 20, "mini: direct stone at top level")
T.eq(treeSum(r, 11, "need"), 40, "mini: stone total doubles via expansion")
T.eq(treeSum(r, 11, "missing"), 40, "mini: all stone missing with empty bags")
T.eq(entryFor(r, 12).need, 10, "mini: cloth direct need")
T.eq(r.crafts[100], 10, "mini: 10 extra powder crafts recorded")
local powder = entryFor(r, 1001)
T.eq(powder.need, 20, "mini: powder demand visible")
T.eq(powder.missing, 10, "mini: production covers half the powder")
T.eq(powder.crafts, 10, "mini: crafts stored on the node")
T.eq(childOf(powder, 11).need, 20, "mini: expansion stone under powder")

-- 20 powder already in bags: no expansion, no children.
r = Calc.AggregateMaterials(mini, ctxOf(1, { [1001] = { bags = 20, bank = 0 } }))
T.eq(treeSum(r, 11, "need"), 20, "mini: no expansion when powder on hand")
T.eq(r.crafts[100], nil, "mini: no extra crafts when powder on hand")
T.eq(entryFor(r, 1001).children, nil, "mini: no children when covered")

-- Overshoot credit: producer makes 8 per craft, only 3 needed -> 1 craft,
-- leftovers cover a later consumer of the same intermediate.
local batch = PP:RegisterProfession({
    key = "batch", professionSpellId = 998, maxSkill = 40,
    ranks = { 40 },
    steps = {
        { minSkill = 1, maxSkill = 20, recipeSpellId = 300, craftedItemId = 3001,
          learnAtSkill = 1, estimatedCrafts = 1, numMade = 8,
          materials = { { itemId = 21, amount = 5 } } },
        { minSkill = 20, maxSkill = 30, recipeSpellId = 301, craftedItemId = 3002,
          learnAtSkill = 20, estimatedCrafts = 1,
          materials = { { itemId = 3001, amount = 11, craftedBy = 300 } } },
        { minSkill = 30, maxSkill = 40, recipeSpellId = 302, craftedItemId = 3003,
          learnAtSkill = 30, estimatedCrafts = 1,
          materials = { { itemId = 3001, amount = 4, craftedBy = 300 } } },
    },
})
r = Calc.AggregateMaterials(batch, ctxOf(1))
T.eq(r.crafts[300], 1, "batch: single extra craft despite two consumers")
T.eq(treeSum(r, 21, "need"), 10, "batch: base cost of 2 total crafts")

-- Engineering regressions -----------------------------------------------------
local eng = PP:GetProfession("engineering")

-- Guide shopping list is wrong for motes: full path needs 80 fire / 160 earth.
r = Calc.AggregateMaterials(eng, ctxOf(300))
T.eq(treeSum(r, 22574, "need"), 80, "eng: mote of fire 80 (guide list says 20)")
T.eq(entryFor(r, 22574).need, 20, "eng: 20 fire direct at top level")
T.eq(childOf(entryFor(r, 23781), 22574).need, 60, "eng: 60 fire under powder")
T.eq(treeSum(r, 22573, "need"), 160, "eng: mote of earth 160 (guide list says 40)")
T.eq(r.crafts[30303], 60, "eng: 60 extra elemental powder crafts")

-- Same totals when starting from scratch.
r = Calc.AggregateMaterials(eng, ctxOf(1))
T.eq(treeSum(r, 22574, "need"), 80, "eng: fire total from skill 1")
T.eq(entryFor(r, 2840).need, 66, "eng: copper 66, no double count via bolts")
T.eq(treeSum(r, 36916, "need"), 338,
    "eng: cobalt 272 + 30 (bolt shortfall) + 36 (trigger shortfall)")
T.eq(r.crafts[53281], 12, "eng: 12 extra volatile trigger crafts")

-- Overproduction must not go negative: at 125 only 10 of 25 tubes are used.
r = Calc.AggregateMaterials(eng, ctxOf(125, { [4371] = { bags = 25, bank = 0 } }))
T.eq(entryFor(r, 4371).missing, 0, "eng: tubes on hand cover scope step")
T.eq(r.crafts[3938], nil, "eng: no tube crafts needed")
T.eq(treeSum(r, 2841, "need"), 60, "eng: bronze only for gizmo+framework")

-- Without tubes the scope step expands into bronze+flux under the tube node.
r = Calc.AggregateMaterials(eng, ctxOf(125))
T.eq(treeSum(r, 2841, "need"), 80, "eng: +20 bronze via tube expansion")
T.eq(childOf(entryFor(r, 4371), 2841).need, 20, "eng: bronze under tube node")
T.eq(treeSum(r, 2880, "need"), 10, "eng: flux only via tube expansion")
T.eq(r.crafts[3938], 10, "eng: 10 tube crafts recorded")

-- Noise machine chain at 430 with empty bags: cobalt only via children.
r = Calc.AggregateMaterials(eng, ctxOf(430))
T.eq(treeSum(r, 36916, "need"), 200, "eng: 200 cobalt via full chain expansion")
T.eq(entryFor(r, 36916), nil, "eng: no direct cobalt at top level")
T.eq(r.crafts[56471], 10, "eng: 10 froststeel tubes to craft")
T.eq(r.crafts[56349], 40, "eng: 40 bolt crafts to craft")
T.eq(treeSum(r, 36913, "need"), 300, "eng: saronite for army knife only")

-- Bank toggle.
r = Calc.AggregateMaterials(eng, ctxOf(30, { [2840] = { bags = 0, bank = 100 } }, true))
T.eq(entryFor(r, 2840).missing, 0, "eng: bank copper counts with includeBank")
r = Calc.AggregateMaterials(eng, ctxOf(30, { [2840] = { bags = 0, bank = 100 } }, false))
T.eq(entryFor(r, 2840).need, entryFor(r, 2840).missing,
    "eng: bank ignored without includeBank")

-- Skill 449: only the last sliver of army knife remains.
r = Calc.AggregateMaterials(eng, ctxOf(449))
T.eq(entryFor(r, 36913).need, 20, "eng: 2 crafts x 10 saronite at 449")
T.eq(entryFor(r, 7005).need, 2, "eng: 2 skinning knives at 449")

-- Skill 450: nothing left.
r = Calc.AggregateMaterials(eng, ctxOf(450))
T.eq(#r.entries, 0, "eng: empty aggregate at 450")
