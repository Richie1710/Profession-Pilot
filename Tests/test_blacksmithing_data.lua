-- Integrity and aggregation tests for Professions/Blacksmithing.lua.

local PP = _G.ProfessionPilot
local Calc = PP.Calc
local prof = PP:GetProfession("blacksmithing")

T.ok(prof, "blacksmithing profession registered")
if not prof then return end

local steps = prof.steps

T.eq(#steps, 44, "44 steps")
T.eq(prof.professionSpellId, 2018, "profession spell id (rank 1)")

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

T.eq(bySpell[2660].craftedItemId, 2862, "Rough Sharpening Stone item id")
T.eq(bySpell[3320].craftedItemId, 3470, "Rough Grinding Stone item id")
T.eq(bySpell[7818].materials[2].amount / bySpell[7818].estimatedCrafts, 2,
    "Silver Rod: 2 rough grinding stones per craft")
T.eq(bySpell[7818].materials[2].craftedBy, 3320,
    "Silver Rod consumes the saved rough grinding stones")
T.eq(bySpell[9935].materials[3].craftedBy, 9920,
    "Steel Plate Helm consumes the saved solid grinding stones")
T.eq(bySpell[16649].source, "quest",
    "Imperial Plate Bracers plans are a quest reward (guide + AtlasLoot)")
T.eq(bySpell[16649].sourceItemId, 12690, "Imperial Plate Bracers plans item")
T.eq(bySpell[29728].source, "vendor",
    "Lesser Ward of Shielding plans are vendor-sold in Outland")
T.eq(bySpell[29728].sourceItemId, 23638, "Lesser Ward of Shielding plans item")
T.ok(bySpell[9961].alternatives and bySpell[9961].alternatives[1]
    and bySpell[9961].alternatives[1].recipeSpellId == 9964,
    "Mithril Spurs alternative on Mithril Coif step")
T.eq(bySpell[55206].craftedItemId, 41245, "Deadly Saronite Dirk item id")
T.eq(bySpell[55656].craftedItemId, 41611, "Eternal Belt Buckle item id")
T.eq(bySpell[59406].craftedItemId, 43853, "Titanium Skeleton Key item id")
T.eq(bySpell[55303].craftedItemId, 41345, "Daunting Legplates item id")

-- Repeated recipes: Runed Copper Belt twice (guide rows 90-100 and 105-110)
-- and Cobalt Gauntlets twice (the 375-380 row links spell=41975, which is
-- the gauntlets' ITEM id -- broken guide link, repaired to 55835).
T.eq(steps[5].recipeSpellId, 2666, "Runed Copper Belt first step")
T.eq(steps[7].recipeSpellId, 2666, "Runed Copper Belt second step")
T.eq(steps[33].recipeSpellId, 55835, "Cobalt Gauntlets first step")
T.eq(steps[34].recipeSpellId, 55835,
    "Cobalt Gauntlets second step (guide's spell=41975 is the item id)")
T.eq(steps[34].craftedItemId, 41975, "Cobalt Gauntlets item id is 41975")

local vendorCount, questCount = 0, 0
for i = 1, #steps do
    if steps[i].source == "vendor" then vendorCount = vendorCount + 1 end
    if steps[i].source == "quest" then questCount = questCount + 1 end
end
T.eq(vendorCount, 1, "one vendor plan (Lesser Ward of Shielding)")
T.eq(questCount, 1, "one quest plan (Imperial Plate Bracers)")

-- The four "Save These for Later" grinding stone steps.
T.ok(bySpell[3320].saveForLater, "rough grinding stones saved for later")
T.ok(bySpell[3326].saveForLater, "coarse grinding stones saved for later")
T.ok(bySpell[3337].saveForLater, "heavy grinding stones saved for later")
T.ok(bySpell[9920].saveForLater, "solid grinding stones saved for later")

-- Trainer milestones sit on the step before each trainer visit.
T.eq(bySpell[2665].notesKey, "NOTE_LEARN_JOURNEYMAN", "journeyman note at 65-75")
T.eq(bySpell[2668].notesKey, "NOTE_LEARN_EXPERT", "expert note at 110-125")
T.eq(bySpell[9928].notesKey, "NOTE_LEARN_ARTISAN", "artisan note at 210-225")
T.eq(bySpell[16652].notesKey, "NOTE_LEARN_MASTER", "master note at 290-300")
T.eq(bySpell[29728].notesKey, "NOTE_LEARN_GRANDMASTER",
    "grand master note at 340-350")

-- Raw totals across steps (per-step guide data; list deviations documented).
local totals = {}
for i = 1, #steps do
    for _, m in ipairs(steps[i].materials) do
        if not m.craftedBy then
            totals[m.itemId] = (totals[m.itemId] or 0) + m.amount
        end
    end
end
T.eq(totals[2835], 160, "rough stone 160")
T.eq(totals[12359], 420, "thorium bars 420")
T.eq(totals[23445], 166, "fel iron bars 166")
T.eq(totals[36916], 320, "cobalt bars 320")
T.eq(totals[36913], 578, "saronite bars 578")
T.eq(totals[41163], 22, "titanium bars 22 (guide list wrongly says 7)")
T.eq(totals[35624], 38, "eternal earth 38 (guide list wrongly says 53)")

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

-- From skill 1 every grinding stone need is covered by the leveling path's
-- own production (all four intermediates run a surplus) -> no extra crafts.
local r = Calc.AggregateMaterials(prof, ctxOf(1))
T.eq(r.crafts[3320], nil, "no extra rough grinding crafts (surplus +50)")
T.eq(r.crafts[3326], nil, "no extra coarse grinding crafts (surplus +5)")
T.eq(r.crafts[3337], nil, "no extra heavy grinding crafts (surplus +5)")
T.eq(r.crafts[9920], nil, "no extra solid grinding crafts (surplus +20)")
T.eq(entryFor(r, 3470).missing, 0, "rough grinding covered by production")
T.eq(entryFor(r, 3470).have, 10, "10 of 60 produced rough grinding used")
T.eq(treeSum(r, 2835, "need"), 160, "rough stone stays 160 (no expansion)")
T.eq(treeSum(r, 36913, "need"), 578, "saronite 578 from skill 1")

-- Starting at 100 the stone steps are done: the Silver Rod's 10 rough
-- grinding stones and 30 coarse grinding stones expand into extra crafts.
r = Calc.AggregateMaterials(prof, ctxOf(100))
T.eq(r.crafts[3320], 10, "10 extra rough grinding crafts at 100")
T.eq(r.crafts[3326], 30, "30 extra coarse grinding crafts at 100")
T.eq(treeSum(r, 2835, "need"), 20, "20 rough stone via expansion at 100")
T.eq(treeSum(r, 2836, "need"), 60, "60 coarse stone via expansion at 100")
T.eq(r.crafts[3337], nil, "heavy grinding still covered at 100")

-- Starting at 210 the solid grinding step is done -> Steel Plate Helm's
-- 10 stones become 10 extra crafts = 40 solid stone.
r = Calc.AggregateMaterials(prof, ctxOf(210))
T.eq(entryFor(r, 7966).need, 10, "10 solid grinding stones at 210")
T.eq(r.crafts[9920], 10, "10 extra solid grinding crafts at 210")
T.eq(treeSum(r, 7912, "need"), 40, "40 solid stone via expansion at 210")

-- 449: 3 Daunting Legplates left (ceil of the prorated remainder).
r = Calc.AggregateMaterials(prof, ctxOf(449))
T.eq(entryFor(r, 36913).need, 42, "42 saronite at 449")
T.eq(entryFor(r, 35624).need, 3, "3 eternal earth at 449")
T.eq(Calc.GetCurrentStepIndex(steps, 450), nil, "450 -> done")
