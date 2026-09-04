-- Integrity and aggregation tests for Professions/Tailoring.lua.

local PP = _G.ProfessionPilot
local Calc = PP.Calc
local prof = PP:GetProfession("tailoring")

T.ok(prof, "tailoring profession registered")
if not prof then return end

local steps = prof.steps

T.eq(#steps, 36, "36 steps")
T.eq(prof.professionSpellId, 3908, "profession spell id (rank 1)")
T.eq(prof.maxSkill, 450, "max skill 450")

-- Every skill point 1..449 lies inside at least one step window.
local uncovered = 0
for s = 1, 449 do
    local covered = false
    for i = 1, #steps do
        if steps[i].minSkill <= s and s < steps[i].maxSkill then
            covered = true
            break
        end
    end
    if not covered then uncovered = uncovered + 1 end
end
T.eq(uncovered, 0, "no skill gaps between 1 and 449")
T.eq(steps[1].minSkill, 1, "path starts at 1")
T.eq(steps[#steps].maxSkill, 450, "path ends at 450")

-- Anchor checks (verified against AtlasLoot 3.3.5a / Wowhead spell pages).
local bySpell = {}
for i = 1, #steps do bySpell[steps[i].recipeSpellId] = steps[i] end

T.eq(bySpell[2963].craftedItemId, 2996, "Bolt of Linen item id")
T.eq(bySpell[2963].learnAtSkill, 1, "Bolt of Linen learnable at 1")
T.eq(bySpell[18401].craftedItemId, 14048, "Bolt of Runecloth item id")
T.eq(bySpell[18401].materials[1].amount / bySpell[18401].estimatedCrafts, 4,
    "4 runecloth per bolt (WotLK value, verified)")
T.eq(bySpell[55899].materials[1].amount / bySpell[55899].estimatedCrafts, 5,
    "5 frostweave per bolt (verified)")
T.eq(bySpell[26747].source, "vendor", "Imbued Netherweave is a vendor recipe")
T.eq(bySpell[26747].sourceItemId, 21892, "vendor pattern item id")
T.eq(bySpell[56026].craftedItemId, 42101, "Ebonweave Robe item id")
T.eq(#bySpell[56027].alternatives, 2, "gloves step: moonshroud+spellweave alts")
T.eq(#bySpell[56026].alternatives, 2, "robe step: moonshroud+spellweave alts")

-- Raw totals across steps (per-step guide data).
local totals = {}
for i = 1, #steps do
    for _, m in ipairs(steps[i].materials) do
        if not m.craftedBy then
            totals[m.itemId] = (totals[m.itemId] or 0) + m.amount
        end
    end
end
T.eq(totals[2589], 204, "linen in steps: 204 (chain adds 2 more)")
T.eq(totals[4306], 804, "silk total 804")
T.eq(totals[33470], 2975, "frostweave in steps: 2975 (chain adds 1075 more)")
T.eq(totals[41593], 56, "ebonweave 56 (guide list wrongly says 12)")

-- Aggregation regressions -----------------------------------------------------
local function ctxOf(skill)
    return { skill = skill, cap = 450, known = {}, counts = {}, maxSkill = 450 }
end
local function treeSum(result, itemId, field)
    local total = 0
    Calc.WalkTree(result.entries, function(n)
        if n.itemId == itemId then total = total + n[field] end
    end)
    return total
end

local r = Calc.AggregateMaterials(prof, ctxOf(1))
T.eq(treeSum(r, 2589, "need"), 206, "linen 206: guide underproduces 1 bolt")
T.eq(r.crafts[2963], 1, "1 extra linen bolt craft")
T.eq(treeSum(r, 33470, "need"), 4050,
    "frostweave 4050: 595 bolts made, 810 consumed (guide list says 2975)")
T.eq(r.crafts[55899], 215, "215 extra frostweave bolt crafts")
T.eq(treeSum(r, 4306, "need"), 804, "silk exact: production matches consumption")
T.eq(r.crafts[3839], nil, "no extra silk bolt crafts")
T.eq(r.crafts[2964], nil, "no extra wool bolt crafts")
T.eq(r.crafts[55900], nil, "imbued frostweave overproduced, no extra crafts")

-- Boundaries.
T.eq(Calc.GetCurrentStepIndex(steps, 449), 36, "449 -> ebonweave robe step")
T.eq(Calc.GetCurrentStepIndex(steps, 450), nil, "450 -> done")
T.eq(Calc.GetRemainingCrafts(steps[36], 449), 1, "one robe left at 449")
