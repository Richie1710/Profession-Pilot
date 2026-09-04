-- Integrity and aggregation tests for Professions/Leatherworking.lua.

local PP = _G.ProfessionPilot
local Calc = PP.Calc
local prof = PP:GetProfession("leatherworking")

T.ok(prof, "leatherworking profession registered")
if not prof then return end

local steps = prof.steps

T.eq(#steps, 31, "31 steps")
T.eq(prof.professionSpellId, 2108, "profession spell id (rank 1)")

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

-- Anchor checks (AtlasLoot 3.3.5a / Wowhead spell pages).
local bySpell = {}
for i = 1, #steps do bySpell[steps[i].recipeSpellId] = steps[i] end

T.eq(bySpell[2881].craftedItemId, 2318, "Light Leather conversion item id")
T.eq(bySpell[7135].materials[1].amount / bySpell[7135].estimatedCrafts, 12,
    "Dark Leather Pants: 12 medium leather per craft (verified)")
T.eq(bySpell[50965].estimatedCrafts, 5,
    "Frosthide: 5 crafts (guide's ~7 conflicts with its own materials)")
T.eq(bySpell[50965].materials[1].amount / 5, 2, "Frosthide: 2 fur per craft")
T.eq(bySpell[60720].source, "vendor", "Overcast Bracers vendor pattern")
T.eq(bySpell[60720].sourceItemId, 44524, "Overcast Bracers pattern item")
T.eq(bySpell[60759].source, "vendor",
    "Trollwoven Girdle IS a vendor pattern (guide fails to flag it)")
T.ok(bySpell[60601].alternatives and bySpell[60601].alternatives[1]
    and bySpell[60601].alternatives[1].recipeSpellId == 60611,
    "Iceborne alternative on Frostscale step")
T.ok(bySpell[50965].alternatives and bySpell[50965].alternatives[1]
    and bySpell[50965].alternatives[1].recipeSpellId == 50967,
    "Icescale alternative on Frosthide step")

local vendorCount = 0
for i = 1, #steps do
    if steps[i].source == "vendor" then vendorCount = vendorCount + 1 end
end
T.eq(vendorCount, 3, "three vendor patterns (both Overcast + Trollwoven)")

-- Raw totals across steps (per-step guide data; list deviations documented).
local totals = {}
for i = 1, #steps do
    for _, m in ipairs(steps[i].materials) do
        if not m.craftedBy then
            totals[m.itemId] = (totals[m.itemId] or 0) + m.amount
        end
    end
end
T.eq(totals[2319], 415, "medium leather 415 (guide list wrongly says 345)")
T.eq(totals[4289], 60, "salt 60 (missing from the guide list entirely)")
T.eq(totals[33568], 2183, "borean leather 2183 direct (chain adds 132 more)")
T.eq(totals[2318], 380, "light leather 380 as farm material")

-- Aggregation ---------------------------------------------------------------
local function ctxOf(skill)
    return { skill = skill, cap = 450, known = {}, counts = {}, maxSkill = 450 }
end
local function entryFor(result, itemId)
    for _, e in ipairs(result.entries) do
        if e.itemId == itemId then return e end
    end
    return nil
end
local function treeSum(result, itemId, field)
    local total = 0
    Calc.WalkTree(result.entries, function(n)
        if n.itemId == itemId then total = total + n[field] end
    end)
    return total
end

local r = Calc.AggregateMaterials(prof, ctxOf(1))
T.eq(treeSum(r, 33568, "need"), 2315,
    "borean 2183 + 132 via heavy-borean shortfall")
T.eq(r.crafts[50936], 22, "22 extra heavy borean crafts")
-- Light leather is deliberately NOT expanded into scraps: the conversion
-- step's output feeds the pool, the rest counts as farm material.
T.eq(entryFor(r, 2318).missing, 361, "light leather: 380 needed, 19 produced")
T.eq(treeSum(r, 2934, "need"), 57, "scraps stay at 57 (no chain expansion)")
T.eq(r.crafts[2881], nil, "no forced scrap-conversion crafts")

-- 449: one Trollwoven Girdle left -> 10 heavy borean -> 60 borean via chain.
r = Calc.AggregateMaterials(prof, ctxOf(449))
T.eq(entryFor(r, 38425).need, 10, "10 heavy borean at 449")
T.eq(treeSum(r, 33568, "need"), 60, "60 borean via expansion at 449")
T.eq(Calc.GetCurrentStepIndex(steps, 450), nil, "450 -> done")
