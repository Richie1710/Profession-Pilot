-- Integrity and aggregation tests for Professions/Inscription.lua.

local PP = _G.ProfessionPilot
local Calc = PP.Calc
local prof = PP:GetProfession("inscription")

T.ok(prof, "inscription profession registered")
if not prof then return end

local steps = prof.steps

T.eq(#steps, 38, "38 steps")
T.eq(prof.professionSpellId, 45357, "profession spell id (rank 1)")

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
-- NOTE: 61177 appears twice (research steps 31/38); bySpell holds the LAST.
local bySpell = {}
for i = 1, #steps do bySpell[steps[i].recipeSpellId] = steps[i] end

T.eq(bySpell[52738].craftedItemId, 37101, "Ivory Ink item id")
T.eq(bySpell[52738].materials[1].amount / bySpell[52738].estimatedCrafts, 1,
    "Ivory Ink: 1 alabaster pigment per craft (guide table)")
T.eq(bySpell[57715].craftedItemId, 43126, "Ink of the Sea item id")
T.eq(bySpell[57715].materials[1].amount / bySpell[57715].estimatedCrafts, 2,
    "Ink of the Sea: 2 azure pigment per craft")
T.eq(bySpell[57716].craftedItemId, 43127, "Snowfall Ink item id")
T.eq(bySpell[57716].materials[1].amount / bySpell[57716].estimatedCrafts, 2,
    "Snowfall Ink: 2 icy pigment per craft")
T.eq(bySpell[52739].craftedItemId, 38682, "Armor Vellum item id (AtlasLoot)")
T.eq(bySpell[59488].craftedItemId, 39350, "Weapon Vellum II item id")
T.eq(bySpell[59488].materials[1].itemId, 43121,
    "Weapon Vellum II consumes Fiery Ink")
T.eq(bySpell[59488].materials[1].craftedBy, nil,
    "Fiery Ink is RAW (guide has no ink step; crafted untracked)")
T.eq(bySpell[59480].craftedItemId, nil,
    "Strange Tarot: random card, no fixed crafted item")
T.eq(bySpell[57712].craftedItemId, 43123, "Ink of the Sky item id")
T.eq(bySpell[57712].saveForLater, nil,
    "Ink of the Sky is skill-only, never saved/consumed")
T.eq(bySpell[56981].materials[1].amount / bySpell[56981].estimatedCrafts, 2,
    "Shimmering glyph window: 2 inks per glyph (guide table)")
T.eq(bySpell[56981].materials[2].amount / bySpell[56981].estimatedCrafts, 2,
    "Shimmering glyph window: 2 heavy parchment per glyph")

-- Research steps share spell 61177 (discovery, 20 h cooldown, random output).
T.eq(steps[31].recipeSpellId, 61177, "step 31 is Northrend research")
T.eq(steps[31].estimatedCrafts, 1, "single research at 385")
T.eq(steps[31].notesKey, "NOTE_INSC_RESEARCH", "research note at 385")
T.eq(steps[31].craftedItemId, nil, "research has no fixed crafted item")
T.eq(steps[38].recipeSpellId, 61177, "step 38 is Northrend research")
T.eq(steps[38].estimatedCrafts, 20, "20 researches for 430-450")
T.eq(steps[38].notesKey, "NOTE_INSC_RESEARCH", "research note at 430")
T.eq(steps[38].craftedItemId, nil, "research has no fixed crafted item")

-- Milestones sit at the trainer-visit steps (125/200/350 shifted onto the
-- ink step so the generic glyph windows keep NOTE_INSC_ANY_GLYPH).
T.eq(bySpell[52739].notesKey, "NOTE_LEARN_JOURNEYMAN", "journeyman note")
T.eq(bySpell[57706].notesKey, "NOTE_LEARN_EXPERT", "expert note (at 125)")
T.eq(bySpell[57709].notesKey, "NOTE_LEARN_ARTISAN", "artisan note (at 200)")
T.eq(bySpell[57712].notesKey, "NOTE_LEARN_MASTER", "master note")
T.eq(bySpell[57715].notesKey, "NOTE_LEARN_GRANDMASTER", "grand master note")
T.eq(steps[1].notesKey, "NOTE_INSC_MILLING", "milling hint on first ink step")

local anyGlyph, saved, vendorCount = 0, 0, 0
for i = 1, #steps do
    if steps[i].notesKey == "NOTE_INSC_ANY_GLYPH" then anyGlyph = anyGlyph + 1 end
    if steps[i].saveForLater then saved = saved + 1 end
    if steps[i].source == "vendor" then vendorCount = vendorCount + 1 end
end
T.eq(anyGlyph, 10, "ten generic 'craft any glyph' windows")
T.eq(saved, 11, "eleven save-for-later ink steps")
T.eq(vendorCount, 0, "all recipes trainer-taught (no vendor patterns)")

-- Raw totals across steps (per-step guide data; list deviations documented).
local totals = {}
for i = 1, #steps do
    for _, m in ipairs(steps[i].materials) do
        if not m.craftedBy then
            totals[m.itemId] = (totals[m.itemId] or 0) + m.amount
        end
    end
end
T.eq(totals[39151], 61, "alabaster pigment 61")
T.eq(totals[39334], 40, "dusky pigment 40")
T.eq(totals[39338], 80, "golden pigment 80 direct (chain adds 10 more)")
T.eq(totals[43104], 10, "burnt pigment 10 (rare milling byproduct)")
T.eq(totals[39339], 94, "emerald pigment 94")
T.eq(totals[39340], 110, "violet pigment 110")
T.eq(totals[39341], 70, "silvery pigment 70")
T.eq(totals[43107], 15, "sapphire pigment 15 (rare milling byproduct)")
T.eq(totals[39342], 90, "nether pigment 90")
T.eq(totals[39343], 180, "azure pigment 180 direct (chain adds 116 more)")
T.eq(totals[43109], 100, "icy pigment 100 (rare milling byproduct)")
T.eq(totals[43121], 5, "fiery ink 5 as raw material")
T.eq(totals[39354], 81, "light parchment 81")
T.eq(totals[10648], 87, "common parchment 87")
T.eq(totals[39501], 90, "heavy parchment 90")
T.eq(totals[39502], 246, "resilient parchment 246")

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

-- From 1: Lion's Ink runs 40 produced vs 45 consumed -> 5 extra crafts
-- (+10 golden pigment); Ink of the Sea runs 90 vs 148 -> 58 extra crafts
-- (+116 azure pigment). All other ink chains are balanced or in surplus.
local r = Calc.AggregateMaterials(prof, ctxOf(1))
T.eq(entryFor(r, 43116).missing, 5, "lion's ink: 45 needed, 40 produced")
T.eq(r.crafts[57704], 5, "5 extra lion's ink crafts")
T.eq(treeSum(r, 39338, "need"), 90, "golden pigment 80 + 10 via shortfall")
T.eq(entryFor(r, 43126).need, 148, "ink of the sea consumed 148")
T.eq(entryFor(r, 43126).missing, 58, "ink of the sea: 90 produced, 58 short")
T.eq(r.crafts[57715], 58, "58 extra ink of the sea crafts")
T.eq(treeSum(r, 39343, "need"), 296, "azure pigment 180 + 116 via shortfall")
T.eq(entryFor(r, 43120).missing, 0, "celestial ink surplus covers demand")
T.eq(r.crafts[57709], nil, "no forced celestial ink crafts")
T.eq(entryFor(r, 43127).missing, 0, "snowfall ink surplus (50 vs 21)")
T.eq(r.crafts[57716], nil, "no forced snowfall ink crafts from 1")
T.eq(entryFor(r, 43121).missing, 5, "fiery ink stays a raw 5x shortfall")

-- 449: one research left -> 3 sea ink + 1 snowfall ink + 3 parchment, both
-- inks now expand into pigments (their production steps are long done).
r = Calc.AggregateMaterials(prof, ctxOf(449))
T.eq(entryFor(r, 43126).need, 3, "3 ink of the sea at 449")
T.eq(r.crafts[57715], 3, "3 ink of the sea crafts at 449")
T.eq(treeSum(r, 39343, "need"), 6, "6 azure pigment via expansion at 449")
T.eq(r.crafts[57716], 1, "1 snowfall ink craft at 449")
T.eq(treeSum(r, 43109, "need"), 2, "2 icy pigment via expansion at 449")
T.eq(entryFor(r, 39502).need, 3, "3 resilient parchment at 449")
T.eq(Calc.GetCurrentStepIndex(steps, 450), nil, "450 -> done")
