-- ProfessionPilot Professions/Leatherworking.lua
-- Static leveling data for Leatherworking 1-450 on WotLK 3.3.5a.
--
-- Source: Wowhead WotLK Leatherworking Leveling 1-450 guide (DOM-extracted
-- 2026-08-08, same method as Engineering/Tailoring). All 33 recipe spells
-- (31 steps + 2 alternatives) cross-checked against AtlasLoot_Crafting data
-- for this exact client; reagent spot checks against Wowhead spell pages
-- (Dark Leather Pants = 12x Medium Leather, Frosthide Leg Armor =
-- 2 fur + 2 chitin + 1 orb per craft).
--
-- Deliberate decisions / guide deviations (totals always come from steps):
--   * The guide's shopping list omits 60x Salt entirely, lists 345 medium
--     leather where the steps need 415, and misses that Trollwoven Girdle
--     is a Dalaran VENDOR pattern (AtlasLoot confirms; the guide only flags
--     the two Overcast patterns).
--   * Light Leather and Heavy Leather are craftable from scraps/medium, but
--     consumers carry NO craftedBy link on purpose: the guide (and every
--     sane player) farms these directly; the conversion steps still credit
--     their output via the production pool. Cured Heavy Hide, Heavy Knothide
--     and Heavy Borean Leather ARE linked -- those chains are the intended
--     way to obtain them.
--   * Frosthide step: the guide says "~7" crafts but lists materials for
--     exactly 5 (10/10/5 at the verified 2/2/1 per craft); we store 5.
--   * Heavy Borean Leather: 300 produced but 322 consumed -> the chain
--     expansion adds 132 borean leather the guide list ignores.

local PP = _G.ProfessionPilot

PP:RegisterProfession({
    key = "leatherworking",
    professionSpellId = 2108,  -- rank-1 spell; name equals the skill line name
    maxSkill = 450,
    ranks = { 75, 150, 225, 300, 375, 450 },

    steps = {
        -- === Apprentice (cap 75) ===
        { minSkill = 1, maxSkill = 20, recipeSpellId = 2881, craftedItemId = 2318,
          learnAtSkill = 1, estimatedCrafts = 19,
          materials = { { itemId = 2934, amount = 57 } } },              -- Ruined Leather Scraps

        { minSkill = 20, maxSkill = 45, recipeSpellId = 2152, craftedItemId = 2304,
          learnAtSkill = 1, estimatedCrafts = 40,
          materials = { { itemId = 2318, amount = 40 } } },              -- Light Leather

        { minSkill = 45, maxSkill = 55, recipeSpellId = 9058, craftedItemId = 7276,
          learnAtSkill = 1, estimatedCrafts = 20,
          notesKey = "NOTE_LEARN_JOURNEYMAN",
          materials = {
              { itemId = 2318, amount = 40 },
              { itemId = 2320, amount = 20 },                           -- Coarse Thread
          } },

        -- === Journeyman (cap 150) ===
        { minSkill = 55, maxSkill = 100, recipeSpellId = 3756, craftedItemId = 4239,
          learnAtSkill = 55, estimatedCrafts = 50, approximate = true,
          materials = {
              { itemId = 2318, amount = 150 },
              { itemId = 2320, amount = 100 },
          } },

        { minSkill = 100, maxSkill = 120, recipeSpellId = 3763, craftedItemId = 4246,
          learnAtSkill = 80, estimatedCrafts = 25, approximate = true,
          materials = {
              { itemId = 2318, amount = 150 },
              { itemId = 2320, amount = 100 },
          } },

        { minSkill = 120, maxSkill = 135, recipeSpellId = 2167, craftedItemId = 2315,
          learnAtSkill = 100, estimatedCrafts = 20, approximate = true,
          notesKey = "NOTE_LEARN_EXPERT",
          materials = {
              { itemId = 2319, amount = 80 },                           -- Medium Leather
              { itemId = 2321, amount = 40 },                           -- Fine Thread
              { itemId = 4340, amount = 20 },                           -- Gray Dye
          } },

        -- === Expert (cap 225) ===
        { minSkill = 135, maxSkill = 155, recipeSpellId = 7135, craftedItemId = 5961,
          learnAtSkill = 115, estimatedCrafts = 25, approximate = true,
          materials = {
              { itemId = 2319, amount = 300 },                          -- 12/craft (verified)
              { itemId = 4340, amount = 25 },
              { itemId = 2321, amount = 25 },
          } },

        { minSkill = 150, maxSkill = 155, recipeSpellId = 20649, craftedItemId = 4234,
          learnAtSkill = 150, estimatedCrafts = 7, approximate = true,
          materials = { { itemId = 2319, amount = 35 } } },

        { minSkill = 155, maxSkill = 165, recipeSpellId = 3818, craftedItemId = 4236,
          learnAtSkill = 150, estimatedCrafts = 20, approximate = true, saveForLater = true,
          materials = {
              { itemId = 4235, amount = 20 },                           -- Heavy Hide
              { itemId = 4289, amount = 60 },                           -- Salt
          } },

        { minSkill = 165, maxSkill = 180, recipeSpellId = 3780, craftedItemId = 4265,
          learnAtSkill = 150, estimatedCrafts = 15,
          materials = {
              { itemId = 4234, amount = 75 },                           -- Heavy Leather
              { itemId = 2321, amount = 15 },
          } },

        { minSkill = 180, maxSkill = 190, recipeSpellId = 7151, craftedItemId = 5964,
          learnAtSkill = 175, estimatedCrafts = 10,
          materials = {
              { itemId = 4234, amount = 80 },
              { itemId = 4236, amount = 10, craftedBy = 3818 },
              { itemId = 2321, amount = 20 },
          } },

        { minSkill = 190, maxSkill = 200, recipeSpellId = 7156, craftedItemId = 5966,
          learnAtSkill = 190, estimatedCrafts = 10,
          materials = {
              { itemId = 4234, amount = 40 },
              { itemId = 4236, amount = 10, craftedBy = 3818 },
              { itemId = 4291, amount = 10 },                           -- Silken Thread
          } },

        { minSkill = 200, maxSkill = 205, recipeSpellId = 10487, craftedItemId = 8173,
          learnAtSkill = 200, estimatedCrafts = 7, approximate = true,
          notesKey = "NOTE_LEARN_ARTISAN",
          materials = {
              { itemId = 4304, amount = 35 },                           -- Thick Leather
              { itemId = 4291, amount = 7 },
          } },

        -- === Artisan (cap 300) ===
        { minSkill = 205, maxSkill = 235, recipeSpellId = 10507, craftedItemId = 8176,
          learnAtSkill = 205, estimatedCrafts = 40, approximate = true,
          materials = {
              { itemId = 4304, amount = 200 },
              { itemId = 4291, amount = 80 },
          } },

        { minSkill = 235, maxSkill = 250, recipeSpellId = 10548, craftedItemId = 8193,
          learnAtSkill = 230, estimatedCrafts = 15,
          materials = {
              { itemId = 4304, amount = 210 },
              { itemId = 4291, amount = 60 },
          } },

        { minSkill = 250, maxSkill = 265, recipeSpellId = 19058, craftedItemId = 15564,
          learnAtSkill = 250, estimatedCrafts = 25, approximate = true,
          materials = { { itemId = 8170, amount = 125 } } },             -- Rugged Leather

        { minSkill = 265, maxSkill = 290, recipeSpellId = 19052, craftedItemId = 15084,
          learnAtSkill = 265, estimatedCrafts = 28, approximate = true,
          materials = {
              { itemId = 8170, amount = 224 },
              { itemId = 2325, amount = 28 },                           -- Black Dye
              { itemId = 14341, amount = 28 },                          -- Rune Thread
          } },

        { minSkill = 290, maxSkill = 300, recipeSpellId = 19071, craftedItemId = 15086,
          learnAtSkill = 280, estimatedCrafts = 10,
          notesKey = "NOTE_LEARN_MASTER",
          materials = {
              { itemId = 8170, amount = 120 },
              { itemId = 2325, amount = 10 },
              { itemId = 14341, amount = 10 },
          } },

        -- === Master (cap 375) ===
        { minSkill = 300, maxSkill = 325, recipeSpellId = 32456, craftedItemId = 25650,
          learnAtSkill = 300, estimatedCrafts = 30, approximate = true,
          materials = { { itemId = 21887, amount = 120 } } },            -- Knothide Leather

        { minSkill = 325, maxSkill = 335, recipeSpellId = 32455, craftedItemId = 23793,
          learnAtSkill = 325, estimatedCrafts = 66, saveForLater = true,
          materials = { { itemId = 21887, amount = 330 } } },

        { minSkill = 335, maxSkill = 350, recipeSpellId = 32473, craftedItemId = 25671,
          learnAtSkill = 330, estimatedCrafts = 22, approximate = true,
          notesKey = "NOTE_LEARN_GRANDMASTER",
          materials = {
              { itemId = 23793, amount = 66, craftedBy = 32455 },
              { itemId = 14341, amount = 22 },
          } },

        -- === Grand Master (cap 450) ===
        { minSkill = 350, maxSkill = 380, recipeSpellId = 50962, craftedItemId = 38375,
          learnAtSkill = 350, estimatedCrafts = 35, approximate = true,
          materials = { { itemId = 33568, amount = 175 } } },            -- Borean Leather

        { minSkill = 380, maxSkill = 386, recipeSpellId = 50948, craftedItemId = 38404,
          learnAtSkill = 380, estimatedCrafts = 6,
          materials = { { itemId = 33568, amount = 48 } } },

        { minSkill = 386, maxSkill = 390, recipeSpellId = 50947, craftedItemId = 38403,
          learnAtSkill = 386, estimatedCrafts = 4,
          materials = { { itemId = 33568, amount = 40 } } },

        { minSkill = 390, maxSkill = 405, recipeSpellId = 50936, craftedItemId = 38425,
          learnAtSkill = 390, estimatedCrafts = 300, saveForLater = true,
          materials = { { itemId = 33568, amount = 1800 } } },

        { minSkill = 405, maxSkill = 410, recipeSpellId = 51571, craftedItemId = 38433,
          learnAtSkill = 405, estimatedCrafts = 10,
          materials = { { itemId = 33568, amount = 120 } } },

        { minSkill = 410, maxSkill = 420, recipeSpellId = 60601, craftedItemId = 44436,
          learnAtSkill = 410, estimatedCrafts = 13, approximate = true,
          alternatives = { { recipeSpellId = 60611, condKey = "ALT_MAT_CHOICE" } },
          materials = {
              { itemId = 38425, amount = 52, craftedBy = 50936 },
              { itemId = 37705, amount = 65 },                          -- Crystallized Water
          } },

        { minSkill = 420, maxSkill = 425, recipeSpellId = 60720, craftedItemId = 43264,
          learnAtSkill = 420, estimatedCrafts = 5,
          source = "vendor", sourceItemId = 44524,
          vendorNoteKey = "NOTE_VENDOR_DALARAN",
          materials = {
              { itemId = 38425, amount = 40, craftedBy = 50936 },
              { itemId = 35622, amount = 5 },                           -- Eternal Water
          } },

        { minSkill = 425, maxSkill = 435, recipeSpellId = 60721, craftedItemId = 43265,
          learnAtSkill = 425, estimatedCrafts = 13, approximate = true,
          source = "vendor", sourceItemId = 44525,
          vendorNoteKey = "NOTE_VENDOR_DALARAN",
          materials = {
              { itemId = 38425, amount = 130, craftedBy = 50936 },
              { itemId = 35622, amount = 13 },
          } },

        { minSkill = 435, maxSkill = 440, recipeSpellId = 50965, craftedItemId = 38373,
          learnAtSkill = 435, estimatedCrafts = 5, approximate = true,
          alternatives = { { recipeSpellId = 50967, condKey = "ALT_MAT_CHOICE" } },
          materials = {
              { itemId = 44128, amount = 10 },                          -- Arctic Fur
              { itemId = 38558, amount = 10 },                          -- Nerubian Chitin
              { itemId = 43102, amount = 5 },                           -- Frozen Orb
          } },

        { minSkill = 440, maxSkill = 450, recipeSpellId = 60759, craftedItemId = 43484,
          learnAtSkill = 440, estimatedCrafts = 10,
          source = "vendor",                    -- Dalaran pattern (AtlasLoot;
          vendorNoteKey = "NOTE_VENDOR_DALARAN", -- the guide fails to flag it)
          materials = {
              { itemId = 38425, amount = 100, craftedBy = 50936 },
              { itemId = 36860, amount = 50 },                          -- Eternal Fire
              { itemId = 35627, amount = 50 },                          -- Eternal Shadow
              { itemId = 43102, amount = 10 },
          } },
    },
})
