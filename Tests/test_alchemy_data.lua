-- Integrity and aggregation tests for Professions/Alchemy.lua.

local PP = _G.ProfessionPilot
local Calc = PP.Calc
local prof = PP:GetProfession("alchemy")

T.ok(prof, "alchemy profession registered")
if not prof then return end

local steps = prof.steps

T.eq(#steps, 30, "30 steps")
T.eq(prof.professionSpellId, 2259, "profession spell id (rank 1)")

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

-- Anchor checks (AtlasLoot 3.3.5a).
local bySpell = {}
for i = 1, #steps do bySpell[steps[i].recipeSpellId] = steps[i] end

T.eq(bySpell[2330].craftedItemId, 118, "Minor Healing Potion item id")
T.ok(bySpell[2330].saveForLater, "minor healing potions saved for later")
T.eq(bySpell[2337].materials[1].craftedBy, 2330,
    "Lesser Healing consumes the saved step-1 potions")
T.eq(bySpell[3173].craftedItemId, 3385,
    "'Geringer Manatrank' is LESSER Mana Potion (AtlasLoot s3173 -> 3385)")
T.eq(bySpell[11459].estimatedCrafts, 1, "Philosopher's Stone: single craft")
T.ok(bySpell[11459].saveForLater, "Philosopher's Stone kept as transmute tool")
T.eq(bySpell[11459].notesKey, "NOTE_TOOL", "Philosopher's Stone note")
T.eq(bySpell[11459].source, "vendor",
    "Philosopher's Stone recipe is vendor-sold in Tanaris (AtlasLoot)")
T.eq(bySpell[28555].source, "vendor",
    "Super Mana Potion IS a vendor recipe (guide fails to flag it)")
T.eq(bySpell[17553].materials[1].amount / bySpell[17553].estimatedCrafts, 2,
    "Superior Mana Potion: 2 sungrass per craft")
T.eq(bySpell[17556].materials[1].amount / bySpell[17556].estimatedCrafts, 2,
    "Major Healing Potion: 2 golden sansam per craft")
T.eq(bySpell[60350].materials[1].amount / bySpell[60350].estimatedCrafts, 8,
    "Transmute Titanium: 8 saronite bars per transmute")
T.eq(bySpell[60350].craftedItemId, 41163, "Transmute Titanium -> Titanium Bar")
T.eq(bySpell[57427].craftedItemId, 41334, "Earthsiege Diamond item id")
T.eq(bySpell[53903].materials[1].amount / bySpell[53903].estimatedCrafts, 7,
    "Flask of Endless Rage: 7 lichbloom per craft")
T.ok(bySpell[53903].alternatives and bySpell[53903].alternatives[1]
    and bySpell[53903].alternatives[1].recipeSpellId == 53901,
    "Frost Wyrm alternative on the flask step")
T.ok(bySpell[53903].alternatives and bySpell[53903].alternatives[2]
    and bySpell[53903].alternatives[2].recipeSpellId == 53902,
    "Stoneblood alternative on the flask step")

local vendorCount = 0
for i = 1, #steps do
    if steps[i].source == "vendor" then vendorCount = vendorCount + 1 end
end
T.eq(vendorCount, 2, "two vendor recipes (Philosopher's Stone + Super Mana)")

-- Raw totals across steps (per-step guide data; list deviations documented).
local totals = {}
for i = 1, #steps do
    for _, m in ipairs(steps[i].materials) do
        if not m.craftedBy then
            totals[m.itemId] = (totals[m.itemId] or 0) + m.amount
        end
    end
end
T.eq(totals[2450], 85, "briarthorn 85 (guide list wrongly says 95)")
T.eq(totals[785], 15, "mageroyal 15 (guide list says 20)")
T.eq(totals[3372], 95, "leaded vials 95 (guide list UNDERSTATES: 65)")
T.eq(totals[18256], 131, "imbued vials 131 (guide list says 163)")
T.eq(totals[4625], 4, "firebloom 4 (missing from the guide list entirely)")
T.eq(totals[36901], 136, "goldclover 136 (guide list understates: 130)")
T.eq(totals[36905], 149, "lichbloom 149 (guide list understates: 145)")
T.eq(totals[13464], 61, "golden sansam 61 (guide list says 70)")
T.eq(totals[22785], 25, "felweed 25 (guide list says 35)")
T.eq(totals[3371], 74, "empty vials 74 (matches list)")
T.eq(totals[8925], 97, "crystal vials 97 (matches list)")
T.eq(totals[118], nil, "minor healing potions come from step 1, not farming")

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

-- From 1 the step-1 output projection fully covers the 50 potions consumed
-- by Lesser Healing (59 produced, 9 spare) -> no chain expansion.
local r = Calc.AggregateMaterials(prof, ctxOf(1))
T.eq(entryFor(r, 118).have, 50, "50 minor healing potions from projection")
T.eq(entryFor(r, 118).missing, 0, "no missing minor healing potions from 1")
T.eq(r.crafts[2330], nil, "no extra minor-healing crafts from 1")
T.eq(treeSum(r, 2447, "need"), 59, "peacebloom 59 from 1")
T.eq(treeSum(r, 3371, "need"), 74, "empty vials 74 from 1")

-- At 60 the saved potions no longer come from leveling: the 50 consumed by
-- Lesser Healing must be re-crafted, expanding into base herbs and vials.
r = Calc.AggregateMaterials(prof, ctxOf(60))
T.eq(entryFor(r, 118).missing, 50, "50 minor healing potions missing at 60")
T.eq(r.crafts[2330], 50, "50 extra minor-healing crafts at 60")
T.eq(treeSum(r, 2447, "need"), 50, "peacebloom 50 via chain expansion at 60")
T.eq(treeSum(r, 3371, "need"), 65, "empty vials 50 via chain + 15 direct at 60")

-- 449: one flask left -> 7 lichbloom, 3 goldclover, 1 lotus, 1 vial.
r = Calc.AggregateMaterials(prof, ctxOf(449))
T.eq(entryFor(r, 36905).need, 7, "7 lichbloom at 449")
T.eq(entryFor(r, 36901).need, 3, "3 goldclover at 449")
T.eq(entryFor(r, 36908).need, 1, "1 frost lotus at 449")
T.eq(Calc.GetCurrentStepIndex(steps, 450), nil, "450 -> done")
