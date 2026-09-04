-- Integrity tests for Professions/Engineering.lua (static data).
-- Registration itself already enforces sorting, divisibility and craftedBy
-- references; this file checks path coverage and verified anchor values.

local PP = _G.ProfessionPilot
local prof = PP:GetProfession("engineering")

T.ok(prof, "engineering profession registered")
if not prof then return end

local steps = prof.steps

T.eq(#steps, 40, "40 steps")
T.eq(prof.professionSpellId, 4036, "profession spell id")
T.eq(prof.maxSkill, 450, "max skill 450")

local ranks = prof.ranks
T.eq(#ranks, 6, "six rank caps")
local expectedRanks = { 75, 150, 225, 300, 375, 450 }
for i = 1, 6 do
    T.eq(ranks[i], expectedRanks[i], "rank cap " .. i)
end

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

-- Anchor checks: values verified against AtlasLoot 3.3.5a / Wowhead.
local bySpell = {}
for i = 1, #steps do bySpell[steps[i].recipeSpellId] = steps[i] end

T.ok(bySpell[3923], "Rough Copper Bomb present")
T.eq(bySpell[3923].craftedItemId, 4360, "Rough Copper Bomb item id")
T.eq(bySpell[3923].learnAtSkill, 30, "Rough Copper Bomb learnable at 30")

T.ok(bySpell[56477], "Mana Injector Kit present")
T.eq(bySpell[56477].craftedItemId, 42546, "Injector item id")
T.eq(bySpell[56477].numMade, 8, "Injector crafts 8 per combine (verified)")

T.ok(bySpell[30341], "White Smoke Flare present")
T.eq(bySpell[30341].source, "vendor", "White Smoke Flare is a vendor recipe")
T.eq(bySpell[30341].sourceItemId, 23811, "vendor blueprint item id")

T.ok(bySpell[61483] and bySpell[61483].alternatives
    and bySpell[61483].alternatives[1]
    and bySpell[61483].alternatives[1].recipeSpellId == 56514,
    "Goblin sapper alternative on snow goggles step")

-- All non-vendor steps come from the trainer.
local vendorCount = 0
for i = 1, #steps do
    local src = steps[i].source or "trainer"
    if src == "vendor" then vendorCount = vendorCount + 1 end
    T.ok(src == "trainer" or src == "vendor", "step source valid: " .. i)
end
T.eq(vendorCount, 1, "exactly one vendor recipe in path")

-- Raw material totals across steps (checked against per-step guide data).
local totals = {}
for i = 1, #steps do
    for _, m in ipairs(steps[i].materials) do
        if not m.craftedBy then
            totals[m.itemId] = (totals[m.itemId] or 0) + m.amount
        end
    end
end
T.eq(totals[2840], 66, "copper bars total 66")
T.eq(totals[2841], 110, "bronze bars total 110")
T.eq(totals[3860], 161, "mithril bars total 161 (guide list says 170: buffer)")
T.eq(totals[12359], 135, "thorium bars total 135")
T.eq(totals[36913], 555, "saronite bars total 555")
T.eq(totals[22574], 20, "raw fire particles in steps: 20 (chain adds 60 more)")
T.eq(totals[37701], 10, "crystallized earth total 10 (guide list 68 is wrong)")
