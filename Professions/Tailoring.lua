-- ProfessionPilot Professions/Tailoring.lua
-- Static leveling data for Tailoring 1-450 on WotLK 3.3.5a.
--
-- Source: Wowhead WotLK Tailoring Leveling 1-450 guide (DOM-extracted
-- 2026-08-08, same method as Engineering.lua). All 40 recipe spells
-- (36 steps + 4 cloth alternatives) cross-checked against AtlasLoot_Crafting
-- data for this exact client: spell id -> crafted item id confirmed.
-- learnAtSkill for classic/TBC recipes comes from AtlasLoot (#sr# values);
-- Northrend recipes are trainer-taught without a skill rating in AtlasLoot,
-- so learnAtSkill conservatively equals the step's minSkill there.
-- Reagent ratios verified by spot check: Bolt of Runecloth = 4x Runecloth
-- (WotLK value, reduced from classic 5), Bolt of Frostweave = 5x Frostweave.
--
-- Guide inconsistencies NOT carried over (totals always computed from steps):
--   * bolts of linen: 102 produced but 103 consumed (+1 bolt = +2 linen),
--   * bolts of frostweave: 595 produced but 810 consumed -> the real
--     frostweave total is 4050, not the guide's 2975,
--   * ebonweave: shopping list says 12, steps consume 56.

local PP = _G.ProfessionPilot

PP:RegisterProfession({
    key = "tailoring",
    professionSpellId = 3908,  -- rank-1 spell; name equals the skill line name
    maxSkill = 450,
    ranks = { 75, 150, 225, 300, 375, 450 },

    steps = {
        -- === Apprentice (cap 75) ===
        { minSkill = 1, maxSkill = 45, recipeSpellId = 2963, craftedItemId = 2996,
          learnAtSkill = 1, estimatedCrafts = 102, saveForLater = true,
          materials = { { itemId = 2589, amount = 204 } } },             -- Linen Cloth

        { minSkill = 45, maxSkill = 67, recipeSpellId = 8776, craftedItemId = 7026,
          learnAtSkill = 15, estimatedCrafts = 35, approximate = true,
          materials = {
              { itemId = 2996, amount = 35, craftedBy = 2963 },
              { itemId = 2320, amount = 35 },                           -- Coarse Thread
          } },

        { minSkill = 67, maxSkill = 75, recipeSpellId = 2397, craftedItemId = 2580,
          learnAtSkill = 60, estimatedCrafts = 8,
          notesKey = "NOTE_LEARN_JOURNEYMAN",
          materials = {
              { itemId = 2996, amount = 16, craftedBy = 2963 },
              { itemId = 2320, amount = 24 },
          } },

        -- === Journeyman (cap 150) ===
        { minSkill = 75, maxSkill = 100, recipeSpellId = 2964, craftedItemId = 2997,
          learnAtSkill = 75, estimatedCrafts = 45, saveForLater = true,
          materials = { { itemId = 2592, amount = 135 } } },             -- Wool Cloth

        { minSkill = 100, maxSkill = 110, recipeSpellId = 12046, craftedItemId = 10047,
          learnAtSkill = 75, estimatedCrafts = 13, approximate = true,
          materials = {
              { itemId = 2996, amount = 52, craftedBy = 2963 },
              { itemId = 2321, amount = 13 },                           -- Fine Thread
          } },

        { minSkill = 110, maxSkill = 125, recipeSpellId = 3848, craftedItemId = 4314,
          learnAtSkill = 110, estimatedCrafts = 15,
          notesKey = "NOTE_LEARN_EXPERT",
          materials = {
              { itemId = 2997, amount = 45, craftedBy = 2964 },
              { itemId = 2321, amount = 30 },
          } },

        -- === Expert (cap 225) ===
        { minSkill = 125, maxSkill = 145, recipeSpellId = 3839, craftedItemId = 4305,
          learnAtSkill = 125, estimatedCrafts = 201, saveForLater = true,
          materials = { { itemId = 4306, amount = 804 } } },             -- Silk Cloth

        { minSkill = 145, maxSkill = 160, recipeSpellId = 8760, craftedItemId = 7048,
          learnAtSkill = 145, estimatedCrafts = 18,
          materials = {
              { itemId = 4305, amount = 36, craftedBy = 3839 },
              { itemId = 6260, amount = 36 },                           -- Blue Dye
              { itemId = 2321, amount = 18 },
          } },

        { minSkill = 160, maxSkill = 170, recipeSpellId = 8762, craftedItemId = 7050,
          learnAtSkill = 160, estimatedCrafts = 10,
          materials = {
              { itemId = 4305, amount = 30, craftedBy = 3839 },
              { itemId = 2321, amount = 20 },
          } },

        { minSkill = 170, maxSkill = 175, recipeSpellId = 3871, craftedItemId = 4334,
          learnAtSkill = 170, estimatedCrafts = 5,
          materials = {
              { itemId = 4305, amount = 15, craftedBy = 3839 },
              { itemId = 2324, amount = 10 },                           -- Bleach
              { itemId = 2321, amount = 5 },
          } },

        { minSkill = 175, maxSkill = 185, recipeSpellId = 3865, craftedItemId = 4339,
          learnAtSkill = 175, estimatedCrafts = 94, saveForLater = true,
          materials = { { itemId = 4338, amount = 376 } } },             -- Mageweave

        { minSkill = 185, maxSkill = 205, recipeSpellId = 8791, craftedItemId = 7058,
          learnAtSkill = 185, estimatedCrafts = 20,
          notesKey = "NOTE_LEARN_ARTISAN",
          materials = {
              { itemId = 4305, amount = 80, craftedBy = 3839 },
              { itemId = 2604, amount = 40 },                           -- Red Dye
              { itemId = 2321, amount = 40 },
          } },

        -- === Artisan (cap 300) ===
        { minSkill = 205, maxSkill = 215, recipeSpellId = 8799, craftedItemId = 7062,
          learnAtSkill = 195, estimatedCrafts = 10,
          materials = {
              { itemId = 4305, amount = 40, craftedBy = 3839 },
              { itemId = 2604, amount = 20 },
              { itemId = 4291, amount = 20 },                           -- Silken Thread
          } },

        { minSkill = 215, maxSkill = 220, recipeSpellId = 12061, craftedItemId = 10056,
          learnAtSkill = 215, estimatedCrafts = 5,
          materials = {
              { itemId = 4339, amount = 5, craftedBy = 3865 },
              { itemId = 6261, amount = 5 },                            -- Orange Dye
              { itemId = 8343, amount = 5 },                            -- Heavy Silken Thread
          } },

        { minSkill = 220, maxSkill = 230, recipeSpellId = 12053, craftedItemId = 10003,
          learnAtSkill = 215, estimatedCrafts = 10,
          materials = {
              { itemId = 4339, amount = 20, craftedBy = 3865 },
              { itemId = 8343, amount = 20 },
          } },

        { minSkill = 230, maxSkill = 250, recipeSpellId = 12072, craftedItemId = 10024,
          learnAtSkill = 230, estimatedCrafts = 23, approximate = true,
          materials = {
              { itemId = 4339, amount = 69, craftedBy = 3865 },
              { itemId = 8343, amount = 46 },
          } },

        { minSkill = 250, maxSkill = 260, recipeSpellId = 18401, craftedItemId = 14048,
          learnAtSkill = 250, estimatedCrafts = 200, saveForLater = true,
          materials = { { itemId = 14047, amount = 800 } } },            -- Runecloth

        { minSkill = 260, maxSkill = 280, recipeSpellId = 18402, craftedItemId = 13856,
          learnAtSkill = 255, estimatedCrafts = 25, approximate = true,
          materials = {
              { itemId = 14048, amount = 75, craftedBy = 18401 },
              { itemId = 14341, amount = 25 },                          -- Rune Thread
          } },

        { minSkill = 280, maxSkill = 300, recipeSpellId = 18417, craftedItemId = 13863,
          learnAtSkill = 275, estimatedCrafts = 25, approximate = true,
          notesKey = "NOTE_LEARN_MASTER",
          materials = {
              { itemId = 14048, amount = 125, craftedBy = 18401 },
              { itemId = 14341, amount = 50 },
          } },

        -- === Master (cap 375) ===
        { minSkill = 300, maxSkill = 325, recipeSpellId = 26745, craftedItemId = 21840,
          learnAtSkill = 300, estimatedCrafts = 140, saveForLater = true,
          materials = { { itemId = 21877, amount = 700 } } },            -- Netherweave

        { minSkill = 325, maxSkill = 331, recipeSpellId = 26747, craftedItemId = 21842,
          learnAtSkill = 325, estimatedCrafts = 6,
          source = "vendor", sourceItemId = 21892,
          vendorNoteKey = "NOTE_VENDOR_IMBUED",
          materials = {
              { itemId = 21840, amount = 18, craftedBy = 26745 },
              { itemId = 22445, amount = 12 },                          -- Arcane Dust
          } },

        { minSkill = 331, maxSkill = 336, recipeSpellId = 26771, craftedItemId = 21852,
          learnAtSkill = 325, estimatedCrafts = 5,
          materials = {
              { itemId = 21840, amount = 30, craftedBy = 26745 },
              { itemId = 14341, amount = 5 },
          } },

        { minSkill = 336, maxSkill = 346, recipeSpellId = 26772, craftedItemId = 21853,
          learnAtSkill = 335, estimatedCrafts = 10,
          materials = {
              { itemId = 21840, amount = 60, craftedBy = 26745 },
              { itemId = 21887, amount = 20 },                          -- Knothide Leather
              { itemId = 14341, amount = 10 },
          } },

        { minSkill = 346, maxSkill = 350, recipeSpellId = 26774, craftedItemId = 21855,
          learnAtSkill = 345, estimatedCrafts = 4,
          notesKey = "NOTE_LEARN_GRANDMASTER",
          materials = {
              { itemId = 21840, amount = 32, craftedBy = 26745 },
              { itemId = 14341, amount = 8 },
          } },

        -- === Grand Master (cap 450) ===
        { minSkill = 350, maxSkill = 375, recipeSpellId = 55899, craftedItemId = 41510,
          learnAtSkill = 350, estimatedCrafts = 595, saveForLater = true,
          notesKey = "NOTE_FROSTWEAVE_STOCK",
          materials = { { itemId = 33470, amount = 2975 } } },           -- Frostweave

        { minSkill = 375, maxSkill = 380, recipeSpellId = 55908, craftedItemId = 41522,
          learnAtSkill = 375, estimatedCrafts = 5,
          materials = {
              { itemId = 41510, amount = 15, craftedBy = 55899 },
              { itemId = 38426, amount = 5 },                           -- Eternium Thread
          } },

        { minSkill = 380, maxSkill = 385, recipeSpellId = 55906, craftedItemId = 41520,
          learnAtSkill = 380, estimatedCrafts = 5,
          materials = {
              { itemId = 41510, amount = 20, craftedBy = 55899 },
              { itemId = 38426, amount = 5 },
          } },

        { minSkill = 385, maxSkill = 395, recipeSpellId = 55907, craftedItemId = 41521,
          learnAtSkill = 385, estimatedCrafts = 13, approximate = true,
          materials = {
              { itemId = 41510, amount = 65, craftedBy = 55899 },
              { itemId = 38426, amount = 13 },
          } },

        { minSkill = 395, maxSkill = 400, recipeSpellId = 55914, craftedItemId = 41543,
          learnAtSkill = 395, estimatedCrafts = 5,
          materials = {
              { itemId = 41510, amount = 35, craftedBy = 55899 },
              { itemId = 38426, amount = 5 },
          } },

        { minSkill = 400, maxSkill = 405, recipeSpellId = 55900, craftedItemId = 41511,
          learnAtSkill = 400, estimatedCrafts = 230, saveForLater = true,
          materials = {
              { itemId = 41510, amount = 460, craftedBy = 55899 },
              { itemId = 34054, amount = 460 },                         -- Infinite Dust
          } },

        { minSkill = 405, maxSkill = 410, recipeSpellId = 55920, craftedItemId = 41551,
          learnAtSkill = 405, estimatedCrafts = 5,
          materials = {
              { itemId = 41510, amount = 40, craftedBy = 55899 },
              { itemId = 38426, amount = 5 },
          } },

        { minSkill = 410, maxSkill = 415, recipeSpellId = 55922, craftedItemId = 41545,
          learnAtSkill = 410, estimatedCrafts = 5,
          materials = {
              { itemId = 41510, amount = 45, craftedBy = 55899 },
              { itemId = 38426, amount = 5 },
          } },

        { minSkill = 415, maxSkill = 425, recipeSpellId = 55924, craftedItemId = 41544,
          learnAtSkill = 415, estimatedCrafts = 13, approximate = true,
          materials = {
              { itemId = 41510, amount = 130, craftedBy = 55899 },
              { itemId = 38426, amount = 13 },
          } },

        { minSkill = 425, maxSkill = 440, recipeSpellId = 56007, craftedItemId = 41599,
          learnAtSkill = 425, estimatedCrafts = 20, approximate = true,
          materials = {
              { itemId = 41511, amount = 120, craftedBy = 55900 },
              { itemId = 38426, amount = 40 },
          } },

        { minSkill = 440, maxSkill = 446, recipeSpellId = 56027, craftedItemId = 42111,
          learnAtSkill = 440, estimatedCrafts = 6,
          alternatives = {
              { recipeSpellId = 56025, condKey = "ALT_CLOTH_CHOICE" },  -- Moonshroud
              { recipeSpellId = 56029, condKey = "ALT_CLOTH_CHOICE" },  -- Spellweave
          },
          materials = {
              { itemId = 41593, amount = 24 },                          -- Ebonweave
              { itemId = 41511, amount = 24, craftedBy = 55900 },
              { itemId = 38426, amount = 6 },
              { itemId = 43102, amount = 6 },                           -- Frozen Orb
          } },

        { minSkill = 446, maxSkill = 450, recipeSpellId = 56026, craftedItemId = 42101,
          learnAtSkill = 446, estimatedCrafts = 4,
          alternatives = {
              { recipeSpellId = 56024, condKey = "ALT_CLOTH_CHOICE" },  -- Moonshroud
              { recipeSpellId = 56028, condKey = "ALT_CLOTH_CHOICE" },  -- Spellweave
          },
          materials = {
              { itemId = 41593, amount = 32 },
              { itemId = 41511, amount = 24, craftedBy = 55900 },
              { itemId = 38426, amount = 4 },
              { itemId = 43102, amount = 4 },
          } },
    },
})
