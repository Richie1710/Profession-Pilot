-- Integrity and aggregation tests for Professions/Jewelcrafting.lua.

local PP = _G.ProfessionPilot
local Calc = PP.Calc
local prof = PP:GetProfession("jewelcrafting")

T.ok(prof, "jewelcrafting profession registered")
if not prof then return end

local steps = prof.steps

T.eq(#steps, 27, "27 steps")
T.eq(prof.professionSpellId, 25229, "profession spell id (rank 1)")

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

T.eq(bySpell[25255].craftedItemId, 20816, "Delicate Copper Wire item id")
T.eq(bySpell[25278].craftedItemId, 20817, "Bronze Setting item id")
T.eq(bySpell[25610].source, "vendor", "Pendant of the Agate Shield vendor pattern")
T.eq(bySpell[25610].sourceItemId, 20970, "Agate Shield pattern item")
T.eq(bySpell[25620].materials[2].amount / bySpell[25620].estimatedCrafts, 2,
    "Engraved Truesilver Ring: 2 filigree per craft")
T.eq(bySpell[26880].craftedItemId, 21752, "Thorium Setting item id")
T.eq(bySpell[28903].craftedItemId, 23094,
    "300-325 representative cut: Teardrop Blood Garnet")
T.eq(bySpell[28924].craftedItemId, 23106,
    "335-340 representative cut: Dazzling Deep Peridot")
T.eq(bySpell[53934].craftedItemId, 39919,
    "350-395 representative cut: Solid Chalcedony")
T.ok(bySpell[55402].alternatives and bySpell[55402].alternatives[1]
    and bySpell[55402].alternatives[1].recipeSpellId == 55399,
    "Powerful Earthsiege alternative on Persistent Earthsiege step")
T.ok(bySpell[55394].alternatives and bySpell[55394].alternatives[1]
    and bySpell[55394].alternatives[1].recipeSpellId == 55386,
    "Tireless Skyflare alternative on Swift Skyflare step")
T.eq(bySpell[55402].minSkill, 420, "meta windows are parallel (Earthsiege)")
T.eq(bySpell[55394].minSkill, 420, "meta windows are parallel (Skyflare)")
T.eq(bySpell[62242].estimatedCrafts, 10, "Icy Prism: 10 crafts")
T.eq(#bySpell[62242].materials, 4, "Icy Prism: 4 reagents")
for i = 1, 4 do
    T.eq(bySpell[62242].materials[i].amount / 10, 1,
        "Icy Prism: 1 of each reagent per craft")
end

local vendorCount = 0
for i = 1, #steps do
    if steps[i].source == "vendor" then vendorCount = vendorCount + 1 end
end
T.eq(vendorCount, 1, "one vendor pattern (Agate Shield)")

-- Raw totals across steps (per-step guide data; list deviations documented).
local totals = {}
for i = 1, #steps do
    for _, m in ipairs(steps[i].materials) do
        if not m.craftedBy then
            totals[m.itemId] = (totals[m.itemId] or 0) + m.amount
        end
    end
end
T.eq(totals[2840], 110, "copper bars 110")
T.eq(totals[2841], 120, "bronze bars 120 (100 settings + 20 rings)")
T.eq(totals[3860], 80, "mithril 80 direct (filigree shortfall adds 62 more)")
T.eq(totals[12359], 56, "thorium bars 56")
T.eq(totals[7909], 35, "aquamarine 35 (30 signets + 5 pendants)")
T.eq(totals[23077] + totals[23079], 42,
    "42 TBC uncommon gems in steps (guide list says 45 of any)")
T.eq(totals[36923], 70, "chalcedony 70 (60 window + 10 prism)")
T.eq(totals[43102], 10, "frozen orbs 10 (missing from the guide list entirely)")

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
-- Mithril Filigree: 40 produced, 71 consumed -> 31 extra crafts, +62 mithril.
T.eq(entryFor(r, 20963).need, 71, "filigree consumed 71")
T.eq(entryFor(r, 20963).missing, 31, "filigree shortfall 31")
T.eq(r.crafts[25615], 31, "31 extra filigree crafts")
T.eq(treeSum(r, 3860, "need"), 142, "mithril 80 + 62 via filigree shortfall")
-- The other intermediates balance exactly: no forced extra crafts.
T.eq(treeSum(r, 20816, "missing"), 0, "copper wire 55 produced = 55 consumed")
T.eq(r.crafts[25255], nil, "no extra wire crafts")
T.eq(entryFor(r, 20817).missing, 0, "bronze setting 50 produced = 50 consumed")
T.eq(entryFor(r, 21752).need, 56, "thorium setting consumed 56")
T.eq(r.crafts[26880], nil, "thorium setting production covers demand")
T.eq(r.crafts[38068], nil, "mercurial adamantite production covers demand")

-- 420: both meta windows plus the prism stretch remain.
r = Calc.AggregateMaterials(prof, ctxOf(420))
T.eq(entryFor(r, 41334).need, 10, "10 Earthsiege Diamonds at 420")
T.eq(entryFor(r, 41266).need, 10, "10 Skyflare Diamonds at 420")
T.eq(entryFor(r, 43102).need, 10, "10 Frozen Orbs at 420")

-- 449: one Icy Prism left -> 1 orb + 1 of each uncommon gem.
r = Calc.AggregateMaterials(prof, ctxOf(449))
T.eq(entryFor(r, 43102).need, 1, "1 Frozen Orb at 449")
T.eq(treeSum(r, 36923, "need"), 1, "1 Chalcedony at 449")
T.eq(treeSum(r, 36926, "need"), 1, "1 Shadow Crystal at 449")
T.eq(Calc.GetCurrentStepIndex(steps, 450), nil, "450 -> done")
