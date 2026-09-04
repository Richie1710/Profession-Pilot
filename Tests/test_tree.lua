-- Tests for Calc.BuildMaterialTree: nested breakdown of the current step's
-- materials into craftable intermediates and base resources.

local PP = _G.ProfessionPilot
local Calc = PP.Calc

local mini = PP:GetProfession("mini")     -- powder(10 from 20 stone) -> bomb
local eng = PP:GetProfession("engineering")

local function ctxOf(skill, counts, includeBank)
    return { skill = skill, cap = 450, known = {}, counts = counts or {},
        includeBank = includeBank, maxSkill = 450 }
end

local function rootFor(roots, itemId)
    for _, n in ipairs(roots) do
        if n.itemId == itemId then return n end
    end
    return nil
end

local function childOf(node, itemId)
    for _, c in ipairs(node.children or {}) do
        if c.itemId == itemId then return c end
    end
    return nil
end

-- Mini: bomb step (30-60) needs 20 powder (craftedBy) + 10 cloth.
-- Empty bags: powder root expands into 40 stone (20 crafts x 2).
local roots = Calc.BuildMaterialTree(mini, mini.steps[2], ctxOf(30))
T.eq(#roots, 2, "mini: powder and cloth roots")
T.eq(roots[1].itemId, 1001, "mini: powder root first")
T.eq(roots[1].need, 20, "mini: 20 powder needed")
T.eq(roots[1].missing, 20, "mini: all powder missing")
T.eq(roots[1].crafts, 20, "mini: 20 powder crafts")
T.eq(#roots[1].children, 1, "mini: one child under powder")
T.eq(roots[1].children[1].itemId, 11, "mini: stone child")
T.eq(roots[1].children[1].need, 40, "mini: 40 stone for 20 crafts")
T.eq(roots[2].itemId, 12, "mini: cloth root second")

-- Powder partially in bags: children scale to the missing portion only.
roots = Calc.BuildMaterialTree(mini, mini.steps[2],
    ctxOf(30, { [1001] = { bags = 15, bank = 0 } }))
T.eq(roots[1].missing, 5, "mini: 15 on hand -> 5 missing")
T.eq(roots[1].crafts, 5, "mini: only 5 crafts needed")
T.eq(roots[1].children[1].need, 10, "mini: stone scaled to missing crafts")

-- Fully covered intermediate produces no children.
roots = Calc.BuildMaterialTree(mini, mini.steps[2],
    ctxOf(30, { [1001] = { bags = 20, bank = 0 } }))
T.eq(roots[1].children, nil, "mini: no children when powder covered")

-- Engineering: Explosive Sheep (step 13) at 160, empty bags.
roots = Calc.BuildMaterialTree(eng, eng.steps[13], ctxOf(160))
T.eq(#roots, 4, "eng: framework, gizmo, powder, wool roots")
local framework = rootFor(roots, 4382)
T.eq(framework.need, 15, "eng: 15 frameworks")
T.eq(framework.crafts, 15, "eng: 15 framework crafts")
T.eq(childOf(framework, 2319).need, 15, "eng: leather under framework")
local powder = rootFor(roots, 4377)
T.eq(powder.need, 30, "eng: 30 heavy powder")
T.eq(childOf(powder, 2838).need, 30, "eng: heavy stone under powder")
T.eq(rootFor(roots, 2592).need, 30, "eng: wool as direct root material")

-- Shared base material must not be double-counted as available: 30 bronze
-- in bags cover the framework's 30 but NOT also the gizmo's 30.
roots = Calc.BuildMaterialTree(eng, eng.steps[13],
    ctxOf(160, { [2841] = { bags = 30, bank = 0 } }))
T.eq(childOf(rootFor(roots, 4382), 2841).missing, 0,
    "eng: framework bronze covered by bags")
T.eq(childOf(rootFor(roots, 4375), 2841).missing, 30,
    "eng: gizmo bronze still missing")

-- Bank toggle respected.
roots = Calc.BuildMaterialTree(mini, mini.steps[2],
    ctxOf(30, { [1001] = { bags = 0, bank = 20 } }, true))
T.eq(roots[1].missing, 0, "mini: bank powder counts with includeBank")
roots = Calc.BuildMaterialTree(mini, mini.steps[2],
    ctxOf(30, { [1001] = { bags = 0, bank = 20 } }, false))
T.eq(roots[1].missing, 20, "mini: bank ignored without includeBank")

-- Completed step -> empty tree.
roots = Calc.BuildMaterialTree(mini, mini.steps[2], ctxOf(60))
T.eq(#roots, 0, "mini: no tree when step completed")

-- numMade overshoot: batch profession (makes 8 per craft).
local batch = PP:GetProfession("batch")
roots = Calc.BuildMaterialTree(batch, batch.steps[2], ctxOf(20))
T.eq(roots[1].need, 11, "batch: 11 intermediates needed")
T.eq(roots[1].crafts, 2, "batch: ceil(11/8) = 2 crafts")
T.eq(roots[1].children[1].need, 10, "batch: base cost of 2 crafts")

-- WalkTree visits every node exactly once, pre-order.
roots = Calc.BuildMaterialTree(eng, eng.steps[13], ctxOf(160))
local visits = 0
Calc.WalkTree(roots, function() visits = visits + 1 end)
T.eq(visits, 4 + 3 + 2 + 1, "walk: 4 roots + framework 3 + gizmo 2 + powder 1")
