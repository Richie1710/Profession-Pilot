-- ProfessionPilot Professions/Engineering.lua
-- Static leveling data for Engineering 1-450 on WotLK 3.3.5a.
--
-- Source: Wowhead WotLK Engineering Leveling 1-450 guide (DOM-extracted
-- 2026-08-08; the page is JS-rendered, so ids were taken from the rendered
-- guide links). Every recipeSpellId -> craftedItemId -> learnAtSkill triple
-- was cross-checked against AtlasLoot_Crafting data built for this exact
-- client. Reagent ratios spot-checked against Wowhead spell pages.
--
-- Deliberate deviations from the guide's own aggregate shopping list (it is
-- internally inconsistent): totals are always computed from these steps,
-- including recursive expansion of missing intermediates (see Core/Calc.lua).
--
-- estimatedCrafts values marked approximate=true are guide estimates for
-- yellow/green recipe ranges and depend on luck/server rates.
--
-- Only ids here; localized names come from GetSpellInfo/GetItemInfo at runtime.

local PP = _G.ProfessionPilot

PP:RegisterProfession({
    key = "engineering",
    professionSpellId = 4036,  -- rank-1 spell; its name equals the skill line name
    maxSkill = 450,
    ranks = { 75, 150, 225, 300, 375, 450 },
    -- Trainer visits required before these skill caps unlock further progress.
    -- Rank names are UI strings (Locales); caps are client constants.

    steps = {
        -- === Apprentice (cap 75) ===
        { minSkill = 1, maxSkill = 30, recipeSpellId = 3918, craftedItemId = 4357,
          learnAtSkill = 1, estimatedCrafts = 60, saveForLater = true,
          materials = { { itemId = 2835, amount = 60 } } },              -- Rough Stone

        { minSkill = 30, maxSkill = 50, recipeSpellId = 3922, craftedItemId = 4359,
          learnAtSkill = 30, estimatedCrafts = 30, saveForLater = true,
          materials = { { itemId = 2840, amount = 30 } } },              -- Copper Bar

        { minSkill = 50, maxSkill = 51, recipeSpellId = 7430, craftedItemId = 6219,
          learnAtSkill = 50, estimatedCrafts = 1, saveForLater = true,
          notesKey = "NOTE_TOOL",
          materials = { { itemId = 2840, amount = 6 } } },

        { minSkill = 51, maxSkill = 75, recipeSpellId = 3923, craftedItemId = 4360,
          learnAtSkill = 30, estimatedCrafts = 30, approximate = true,
          notesKey = "NOTE_LEARN_JOURNEYMAN",
          materials = {
              { itemId = 2840, amount = 30 },
              { itemId = 4359, amount = 30, craftedBy = 3922 },
              { itemId = 4357, amount = 60, craftedBy = 3918 },
              { itemId = 2589, amount = 30 },                            -- Linen Cloth
          } },

        -- === Journeyman (cap 150) ===
        { minSkill = 75, maxSkill = 90, recipeSpellId = 3929, craftedItemId = 4364,
          learnAtSkill = 75, estimatedCrafts = 60, approximate = true, saveForLater = true,
          materials = { { itemId = 2836, amount = 60 } } },              -- Coarse Stone

        { minSkill = 90, maxSkill = 100, recipeSpellId = 3931, craftedItemId = 4365,
          learnAtSkill = 75, estimatedCrafts = 20, approximate = true,
          materials = {
              { itemId = 4364, amount = 60, craftedBy = 3929 },
              { itemId = 2589, amount = 20 },
          } },

        { minSkill = 100, maxSkill = 105, recipeSpellId = 3973, craftedItemId = 4404,
          learnAtSkill = 90, estimatedCrafts = 5,
          materials = { { itemId = 2842, amount = 5 } } },               -- Silver Bar

        { minSkill = 105, maxSkill = 125, recipeSpellId = 3938, craftedItemId = 4371,
          learnAtSkill = 105, estimatedCrafts = 25, saveForLater = true,
          materials = {
              { itemId = 2841, amount = 50 },                           -- Bronze Bar
              { itemId = 2880, amount = 25 },                           -- Weak Flux
          } },

        { minSkill = 125, maxSkill = 135, recipeSpellId = 3978, craftedItemId = 4406,
          learnAtSkill = 110, estimatedCrafts = 10,
          notesKey = "NOTE_LEARN_EXPERT",
          materials = {
              { itemId = 4371, amount = 10, craftedBy = 3938 },
              { itemId = 1206, amount = 10 },                           -- Moss Agate
          } },

        -- === Expert (cap 225) ===
        { minSkill = 135, maxSkill = 150, recipeSpellId = 3945, craftedItemId = 4377,
          learnAtSkill = 125, estimatedCrafts = 30, saveForLater = true,
          materials = { { itemId = 2838, amount = 30 } } },              -- Heavy Stone

        { minSkill = 135, maxSkill = 150, recipeSpellId = 3942, craftedItemId = 4375,
          learnAtSkill = 125, estimatedCrafts = 15, saveForLater = true,
          materials = {
              { itemId = 2841, amount = 30 },
              { itemId = 2592, amount = 15 },                           -- Wool Cloth
          } },

        { minSkill = 150, maxSkill = 160, recipeSpellId = 3953, craftedItemId = 4382,
          learnAtSkill = 145, estimatedCrafts = 15, saveForLater = true,
          materials = {
              { itemId = 2841, amount = 30 },
              { itemId = 2319, amount = 15 },                           -- Medium Leather
              { itemId = 2592, amount = 15 },
          } },

        { minSkill = 160, maxSkill = 175, recipeSpellId = 3955, craftedItemId = 4384,
          learnAtSkill = 150, estimatedCrafts = 15,
          materials = {
              { itemId = 4382, amount = 15, craftedBy = 3953 },
              { itemId = 4375, amount = 15, craftedBy = 3942 },
              { itemId = 4377, amount = 30, craftedBy = 3945 },
              { itemId = 2592, amount = 30 },
          } },

        { minSkill = 175, maxSkill = 176, recipeSpellId = 12590, craftedItemId = 10498,
          learnAtSkill = 175, estimatedCrafts = 1, saveForLater = true,
          notesKey = "NOTE_TOOL",
          materials = { { itemId = 3859, amount = 4 } } },               -- Steel Bar

        { minSkill = 176, maxSkill = 195, recipeSpellId = 12585, craftedItemId = 10505,
          learnAtSkill = 175, estimatedCrafts = 60, saveForLater = true,
          materials = { { itemId = 7912, amount = 120 } } },             -- Solid Stone

        { minSkill = 195, maxSkill = 200, recipeSpellId = 12589, craftedItemId = 10559,
          learnAtSkill = 195, estimatedCrafts = 7, approximate = true,
          notesKey = "NOTE_LEARN_ARTISAN_ENG",
          materials = { { itemId = 3860, amount = 21 } } },              -- Mithril Bar

        -- === Artisan (cap 300) ===
        { minSkill = 200, maxSkill = 215, recipeSpellId = 12591, craftedItemId = 10560,
          learnAtSkill = 200, estimatedCrafts = 20, saveForLater = true,
          materials = {
              { itemId = 3860, amount = 20 },
              { itemId = 4338, amount = 20 },                           -- Mageweave Cloth
              { itemId = 10505, amount = 20, craftedBy = 12585 },
          } },

        { minSkill = 215, maxSkill = 238, recipeSpellId = 12599, craftedItemId = 10561,
          learnAtSkill = 215, estimatedCrafts = 40, saveForLater = true,
          materials = { { itemId = 3860, amount = 120 } } },

        { minSkill = 238, maxSkill = 250, recipeSpellId = 12619, craftedItemId = 10562,
          learnAtSkill = 235, estimatedCrafts = 20,
          materials = {
              { itemId = 10561, amount = 40, craftedBy = 12599 },
              { itemId = 10560, amount = 20, craftedBy = 12591 },
              { itemId = 10505, amount = 40, craftedBy = 12585 },
          } },

        { minSkill = 250, maxSkill = 260, recipeSpellId = 19788, craftedItemId = 15992,
          learnAtSkill = 250, estimatedCrafts = 30, approximate = true, saveForLater = true,
          materials = { { itemId = 12365, amount = 60 } } },             -- Dense Stone

        { minSkill = 260, maxSkill = 285, recipeSpellId = 19791, craftedItemId = 15994,
          learnAtSkill = 260, estimatedCrafts = 35, approximate = true,
          materials = {
              { itemId = 12359, amount = 105 },                         -- Thorium Bar
              { itemId = 14047, amount = 35 },                          -- Runecloth
          } },

        { minSkill = 285, maxSkill = 300, recipeSpellId = 19800, craftedItemId = 15997,
          learnAtSkill = 285, estimatedCrafts = 15,
          notesKey = "NOTE_LEARN_MASTER",
          materials = {
              { itemId = 12359, amount = 30 },
              { itemId = 15992, amount = 15, craftedBy = 19788 },
          } },

        -- === Master (cap 375) ===
        { minSkill = 300, maxSkill = 320, recipeSpellId = 30305, craftedItemId = 23783,
          learnAtSkill = 300, estimatedCrafts = 40, saveForLater = true,
          materials = { { itemId = 23445, amount = 40 } } },             -- Fel Iron Bar

        { minSkill = 300, maxSkill = 320, recipeSpellId = 30303, craftedItemId = 23781,
          learnAtSkill = 300, estimatedCrafts = 20, saveForLater = true,
          materials = {
              { itemId = 22574, amount = 20 },                          -- Mote of Fire
              { itemId = 22573, amount = 40 },                          -- Mote of Earth
          } },

        { minSkill = 300, maxSkill = 320, recipeSpellId = 30304, craftedItemId = 23782,
          learnAtSkill = 300, estimatedCrafts = 10, saveForLater = true,
          materials = { { itemId = 23445, amount = 30 } } },

        { minSkill = 320, maxSkill = 325, recipeSpellId = 30310, craftedItemId = 23736,
          learnAtSkill = 300, estimatedCrafts = 10, approximate = true,
          materials = {
              { itemId = 23782, amount = 10, craftedBy = 30304 },
              { itemId = 23783, amount = 20, craftedBy = 30305 },
              { itemId = 23781, amount = 10, craftedBy = 30303 },
          } },

        { minSkill = 325, maxSkill = 335, recipeSpellId = 30311, craftedItemId = 23737,
          learnAtSkill = 325, estimatedCrafts = 10,
          materials = {
              { itemId = 23446, amount = 40 },                          -- Adamantite Bar
              { itemId = 23783, amount = 20, craftedBy = 30305 },
              { itemId = 23781, amount = 10, craftedBy = 30303 },
          } },

        { minSkill = 335, maxSkill = 350, recipeSpellId = 30341, craftedItemId = 23768,
          learnAtSkill = 335, estimatedCrafts = 60, approximate = true,
          source = "vendor", sourceItemId = 23811,
          vendorNoteKey = "NOTE_VENDOR_WSF",
          notesKey = "NOTE_LEARN_GRANDMASTER",
          materials = {
              { itemId = 23781, amount = 60, craftedBy = 30303 },
              { itemId = 21877, amount = 60 },                          -- Netherweave Cloth
          } },

        -- === Grand Master (cap 450) ===
        { minSkill = 350, maxSkill = 375, recipeSpellId = 56349, craftedItemId = 39681,
          learnAtSkill = 350, estimatedCrafts = 35, saveForLater = true,
          materials = { { itemId = 36916, amount = 70 } } },             -- Cobalt Bar

        { minSkill = 350, maxSkill = 375, recipeSpellId = 53281, craftedItemId = 39690,
          learnAtSkill = 350, estimatedCrafts = 14, saveForLater = true,
          materials = {
              { itemId = 36916, amount = 42 },
              { itemId = 37705, amount = 14 },                          -- Crystallized Water
          } },

        { minSkill = 375, maxSkill = 385, recipeSpellId = 56464, craftedItemId = 39682,
          learnAtSkill = 375, estimatedCrafts = 10, saveForLater = true,
          materials = {
              { itemId = 36916, amount = 40 },
              { itemId = 37701, amount = 10 },                          -- Crystallized Earth
          } },

        { minSkill = 385, maxSkill = 390, recipeSpellId = 56463, craftedItemId = 40536,
          learnAtSkill = 375, estimatedCrafts = 7, approximate = true,
          materials = {
              { itemId = 33470, amount = 7 },                           -- Frostweave Cloth
              { itemId = 39690, amount = 21, craftedBy = 53281 },
          } },

        { minSkill = 390, maxSkill = 400, recipeSpellId = 56471, craftedItemId = 39683,
          learnAtSkill = 390, estimatedCrafts = 15, saveForLater = true,
          materials = {
              { itemId = 36916, amount = 120 },
              { itemId = 37705, amount = 15 },
          } },

        { minSkill = 400, maxSkill = 405, recipeSpellId = 61471, craftedItemId = 44739,
          learnAtSkill = 390, estimatedCrafts = 5,
          materials = {
              { itemId = 39683, amount = 5, craftedBy = 56471 },
              { itemId = 39681, amount = 10, craftedBy = 56349 },
          } },

        { minSkill = 405, maxSkill = 410, recipeSpellId = 56468, craftedItemId = 44951,
          learnAtSkill = 405, estimatedCrafts = 5,
          materials = {
              { itemId = 36913, amount = 25 },                          -- Saronite Bar
              { itemId = 39690, amount = 5, craftedBy = 53281 },
          } },

        { minSkill = 410, maxSkill = 415, recipeSpellId = 67326, craftedItemId = 47828,
          learnAtSkill = 400, estimatedCrafts = 5,
          materials = {
              { itemId = 36913, amount = 30 },
              { itemId = 37702, amount = 15 },                          -- Crystallized Fire
              { itemId = 37705, amount = 15 },
          } },

        { minSkill = 415, maxSkill = 425, recipeSpellId = 56477, craftedItemId = 42546,
          learnAtSkill = 415, estimatedCrafts = 12, approximate = true, numMade = 8,
          materials = {
              { itemId = 36913, amount = 144 },
              { itemId = 37705, amount = 24 },
          } },

        { minSkill = 425, maxSkill = 430, recipeSpellId = 61483, craftedItemId = 44742,
          learnAtSkill = 420, estimatedCrafts = 7, approximate = true,
          alternatives = { { recipeSpellId = 56514, condKey = "ALT_REQ_GOBLIN" } },
          materials = {
              { itemId = 36913, amount = 56 },
              { itemId = 33568, amount = 14 },                          -- Borean Leather
              { itemId = 35627, amount = 7 },                           -- Eternal Shadow
          } },

        { minSkill = 430, maxSkill = 435, recipeSpellId = 56467, craftedItemId = 40865,
          learnAtSkill = 420, estimatedCrafts = 5,
          materials = {
              { itemId = 39683, amount = 10, craftedBy = 56471 },
              { itemId = 39682, amount = 10, craftedBy = 56464 },
              { itemId = 39681, amount = 40, craftedBy = 56349 },
          } },

        { minSkill = 435, maxSkill = 450, recipeSpellId = 56462, craftedItemId = 40772,
          learnAtSkill = 435, estimatedCrafts = 30, approximate = true,
          materials = {
              { itemId = 36913, amount = 300 },
              { itemId = 7005, amount = 30 },                           -- Skinning Knife
              { itemId = 2901, amount = 30 },                           -- Mining Pick
              { itemId = 5956, amount = 30 },                           -- Blacksmith Hammer
          } },
    },
})
