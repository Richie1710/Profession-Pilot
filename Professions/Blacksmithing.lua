-- ProfessionPilot Professions/Blacksmithing.lua
-- Static leveling data for Blacksmithing 1-450 on WotLK 3.3.5a.
--
-- Source: Wowhead WotLK Blacksmithing Leveling 1-450 guide (DOM-extracted
-- 2026-08-08, same method as Engineering/Tailoring/Leatherworking). All 44
-- recipe spells (44 steps with 43 distinct recipes + 1 alternative) were
-- cross-checked against AtlasLoot_Crafting data for this exact client:
-- spell id -> crafted item id confirmed for every entry. learnAtSkill for
-- classic/TBC recipes comes from AtlasLoot (#sr# values); Northrend recipes
-- are trainer-taught without a skill rating in AtlasLoot, so learnAtSkill
-- conservatively equals the step's minSkill there. Smelting (ore -> bar) is
-- Mining, NOT Blacksmithing, and is not modeled -- bars are raw materials.
--
-- Guide link repair: the 375-380 row links spell=41975 ("Heldenhafter
-- Stoss"), which is no blacksmithing recipe at all -- 41975 is the ITEM id
-- of Cobalt Gauntlets, crafted by spell 55835 (the 370-375 step), and the
-- row's materials (25 bars for 5 crafts = 5/craft) match Cobalt Gauntlets
-- exactly. Modeled as a second Cobalt Gauntlets step, like the guide's own
-- repeated Runed Copper Belt (90-100 and 105-110).
--
-- Intermediate balance (grinding stones; produced vs consumed by this path):
--   * Rough Grinding Stone  (3470): 60 made / 10 used (Silver Rod)   -> +50
--   * Coarse Grinding Stone (3478): 35 made / 30 used (Patterned
--     Bronze Bracers 20 + Golden Rod 10)                             -> +5
--   * Heavy Grinding Stone  (3486): 35 made / 30 used (Green Iron
--     Leggings 10 + Golden Scale Bracers 20)                         -> +5
--   * Solid Grinding Stone  (7966): 30 made / 10 used (Steel Plate
--     Helm)                                                          -> +20
-- All surpluses -- the stones are themselves the skill-up fodder ("Save
-- These for Later"). Mid-path starts create shortfalls instead; those are
-- auto-expanded into extra crafts by Core/Calc.lua (exactly like
-- Engineering's blasting powders).
--
-- Guide inconsistencies NOT carried over (totals always computed from steps):
--   * shopping list says 7 Titanium Bars, the steps consume 22
--     (7 Titanium Weapon Chain + 15 Titanium Skeleton Key),
--   * shopping list says 53 Eternal Earth, the steps consume 38
--     (13 Eternal Belt Buckle + 25 Daunting Legplates).
--   Both errors are consistent with a shopping list that assumed Titanium
--   Skeleton Key = 4 saronite + 1 eternal earth, while the step table says
--   4 saronite + 1 titanium bar per key. Step values are stored here.
--
-- Recipe acquisition notes (AtlasLoot-confirmed where possible):
--   * Plans: Imperial Plate Bracers (item 12690) come from the repeatable
--     thorium turn-in quest "Imperial Plate Bracers" in Gadgetzan
--     -> source = "quest" (the UI currently renders unknown sources as
--     trainer; the notesKey explains the quest).
--   * Plans: Lesser Ward of Shielding (item 23638) are vendor-sold in
--     Shadowmoon Valley / Hellfire Peninsula -> source = "vendor".
--   * Mithril Spurs (9964) is a guide alternative to Mithril Coif "if you
--     have the recipe".
--
-- Only ids here; localized names come from GetSpellInfo/GetItemInfo at runtime.

local PP = _G.ProfessionPilot

PP:RegisterProfession({
    key = "blacksmithing",
    professionSpellId = 2018,  -- rank-1 spell; name equals the skill line name
    maxSkill = 450,
    ranks = { 75, 150, 225, 300, 375, 450 },

    steps = {
        -- === Apprentice (cap 75) ===
        { minSkill = 1, maxSkill = 30, recipeSpellId = 2660, craftedItemId = 2862,
          learnAtSkill = 1, estimatedCrafts = 40, approximate = true,
          materials = { { itemId = 2835, amount = 40 } } },              -- Rough Stone

        { minSkill = 30, maxSkill = 65, recipeSpellId = 3320, craftedItemId = 3470,
          learnAtSkill = 25, estimatedCrafts = 60, approximate = true, saveForLater = true,
          materials = { { itemId = 2835, amount = 120 } } },

        { minSkill = 65, maxSkill = 75, recipeSpellId = 2665, craftedItemId = 2863,
          learnAtSkill = 65, estimatedCrafts = 25, approximate = true,
          notesKey = "NOTE_LEARN_JOURNEYMAN",
          materials = { { itemId = 2836, amount = 25 } } },              -- Coarse Stone

        -- === Journeyman (cap 150) ===
        { minSkill = 75, maxSkill = 90, recipeSpellId = 3326, craftedItemId = 3478,
          learnAtSkill = 75, estimatedCrafts = 35, approximate = true, saveForLater = true,
          materials = { { itemId = 2836, amount = 70 } } },

        { minSkill = 90, maxSkill = 100, recipeSpellId = 2666, craftedItemId = 2857,
          learnAtSkill = 70, estimatedCrafts = 10,
          materials = { { itemId = 2840, amount = 100 } } },             -- Copper Bar

        { minSkill = 100, maxSkill = 105, recipeSpellId = 7818, craftedItemId = 6338,
          learnAtSkill = 100, estimatedCrafts = 5,
          materials = {
              { itemId = 2842, amount = 5 },                            -- Silver Bar
              { itemId = 3470, amount = 10, craftedBy = 3320 },
          } },

        { minSkill = 105, maxSkill = 110, recipeSpellId = 2666, craftedItemId = 2857,
          learnAtSkill = 70, estimatedCrafts = 5,
          materials = { { itemId = 2840, amount = 50 } } },

        { minSkill = 110, maxSkill = 125, recipeSpellId = 2668, craftedItemId = 2865,
          learnAtSkill = 105, estimatedCrafts = 15,
          notesKey = "NOTE_LEARN_EXPERT",
          materials = { { itemId = 2841, amount = 90 } } },              -- Bronze Bar

        -- === Expert (cap 225) ===
        { minSkill = 125, maxSkill = 140, recipeSpellId = 3337, craftedItemId = 3486,
          learnAtSkill = 125, estimatedCrafts = 35, approximate = true, saveForLater = true,
          materials = { { itemId = 2838, amount = 105 } } },             -- Heavy Stone

        { minSkill = 140, maxSkill = 150, recipeSpellId = 2672, craftedItemId = 2868,
          learnAtSkill = 120, estimatedCrafts = 10,
          materials = {
              { itemId = 2841, amount = 50 },
              { itemId = 3478, amount = 20, craftedBy = 3326 },
          } },

        { minSkill = 150, maxSkill = 155, recipeSpellId = 14379, craftedItemId = 11128,
          learnAtSkill = 150, estimatedCrafts = 5,
          materials = {
              { itemId = 3577, amount = 5 },                            -- Gold Bar
              { itemId = 3478, amount = 10, craftedBy = 3326 },
          } },

        { minSkill = 155, maxSkill = 165, recipeSpellId = 3506, craftedItemId = 3842,
          learnAtSkill = 155, estimatedCrafts = 10,
          materials = {
              { itemId = 3575, amount = 80 },                           -- Iron Bar
              { itemId = 3486, amount = 10, craftedBy = 3337 },
              { itemId = 2605, amount = 10 },                           -- Green Dye
          } },

        { minSkill = 165, maxSkill = 190, recipeSpellId = 3501, craftedItemId = 3835,
          learnAtSkill = 165, estimatedCrafts = 25,
          materials = {
              { itemId = 3575, amount = 150 },
              { itemId = 2605, amount = 25 },
          } },

        { minSkill = 190, maxSkill = 200, recipeSpellId = 7223, craftedItemId = 6040,
          learnAtSkill = 185, estimatedCrafts = 10,
          materials = {
              { itemId = 3859, amount = 50 },                           -- Steel Bar
              { itemId = 3486, amount = 20, craftedBy = 3337 },
          } },

        { minSkill = 200, maxSkill = 210, recipeSpellId = 9920, craftedItemId = 7966,
          learnAtSkill = 200, estimatedCrafts = 30, approximate = true, saveForLater = true,
          materials = { { itemId = 7912, amount = 120 } } },             -- Solid Stone

        { minSkill = 210, maxSkill = 225, recipeSpellId = 9928, craftedItemId = 7919,
          learnAtSkill = 205, estimatedCrafts = 15,
          notesKey = "NOTE_LEARN_ARTISAN",
          materials = {
              { itemId = 3860, amount = 90 },                           -- Mithril Bar
              { itemId = 4338, amount = 60 },                           -- Mageweave Cloth
          } },

        -- === Artisan (cap 300) ===
        { minSkill = 225, maxSkill = 235, recipeSpellId = 9935, craftedItemId = 7922,
          learnAtSkill = 215, estimatedCrafts = 10,
          materials = {
              { itemId = 3859, amount = 140 },
              { itemId = 3864, amount = 10 },                           -- Citrine
              { itemId = 7966, amount = 10, craftedBy = 9920 },
          } },

        { minSkill = 235, maxSkill = 250, recipeSpellId = 9961, craftedItemId = 7931,
          learnAtSkill = 230, estimatedCrafts = 15,
          alternatives = { { recipeSpellId = 9964, condKey = "ALT_MAT_CHOICE" } },
          materials = {
              { itemId = 3860, amount = 150 },
              { itemId = 4338, amount = 90 },
          } },

        { minSkill = 250, maxSkill = 260, recipeSpellId = 16641, craftedItemId = 12404,
          learnAtSkill = 250, estimatedCrafts = 20, approximate = true,
          materials = { { itemId = 12365, amount = 20 } } },             -- Dense Stone

        { minSkill = 260, maxSkill = 270, recipeSpellId = 16643, craftedItemId = 12406,
          learnAtSkill = 250, estimatedCrafts = 10,
          materials = { { itemId = 12359, amount = 80 } } },             -- Thorium Bar

        { minSkill = 270, maxSkill = 275, recipeSpellId = 16644, craftedItemId = 12408,
          learnAtSkill = 255, estimatedCrafts = 5,
          materials = { { itemId = 12359, amount = 40 } } },

        { minSkill = 275, maxSkill = 290, recipeSpellId = 16649, craftedItemId = 12425,
          learnAtSkill = 270, estimatedCrafts = 15,
          source = "quest", sourceItemId = 12690,
          notesKey = "NOTE_QUEST_IMPERIAL",
          materials = { { itemId = 12359, amount = 180 } } },

        { minSkill = 290, maxSkill = 300, recipeSpellId = 16652, craftedItemId = 12409,
          learnAtSkill = 280, estimatedCrafts = 10,
          notesKey = "NOTE_LEARN_MASTER",
          materials = {
              { itemId = 12359, amount = 120 },
              { itemId = 8170, amount = 80 },                           -- Rugged Leather
          } },

        -- === Master (cap 375) ===
        { minSkill = 300, maxSkill = 305, recipeSpellId = 34607, craftedItemId = 28420,
          learnAtSkill = 300, estimatedCrafts = 10, approximate = true,
          materials = {
              { itemId = 23445, amount = 10 },                          -- Fel Iron Bar
              { itemId = 21877, amount = 10 },                          -- Netherweave Cloth
          } },

        { minSkill = 305, maxSkill = 316, recipeSpellId = 29547, craftedItemId = 23484,
          learnAtSkill = 305, estimatedCrafts = 11,
          materials = { { itemId = 23445, amount = 44 } } },

        { minSkill = 316, maxSkill = 321, recipeSpellId = 29552, craftedItemId = 23491,
          learnAtSkill = 310, estimatedCrafts = 5,
          materials = { { itemId = 23445, amount = 25 } } },

        { minSkill = 321, maxSkill = 325, recipeSpellId = 29548, craftedItemId = 23487,
          learnAtSkill = 315, estimatedCrafts = 4,
          materials = { { itemId = 23445, amount = 24 } } },

        { minSkill = 325, maxSkill = 335, recipeSpellId = 32284, craftedItemId = 23559,
          learnAtSkill = 325, estimatedCrafts = 50, approximate = true,
          materials = { { itemId = 23446, amount = 50 } } },             -- Adamantite Bar

        { minSkill = 335, maxSkill = 340, recipeSpellId = 29556, craftedItemId = 23490,
          learnAtSkill = 320, estimatedCrafts = 7, approximate = true,
          materials = { { itemId = 23445, amount = 63 } } },

        { minSkill = 340, maxSkill = 350, recipeSpellId = 29728, craftedItemId = 23575,
          learnAtSkill = 340, estimatedCrafts = 45, approximate = true,
          source = "vendor", sourceItemId = 23638,
          vendorNoteKey = "NOTE_VENDOR_WARD",
          notesKey = "NOTE_LEARN_GRANDMASTER",
          materials = { { itemId = 23446, amount = 45 } } },

        -- === Grand Master (cap 450) ===
        { minSkill = 350, maxSkill = 360, recipeSpellId = 52569, craftedItemId = 39088,
          learnAtSkill = 350, estimatedCrafts = 10,
          materials = { { itemId = 36916, amount = 40 } } },             -- Cobalt Bar

        { minSkill = 360, maxSkill = 370, recipeSpellId = 54550, craftedItemId = 40668,
          learnAtSkill = 360, estimatedCrafts = 10,
          materials = { { itemId = 36916, amount = 40 } } },

        { minSkill = 370, maxSkill = 375, recipeSpellId = 55835, craftedItemId = 41975,
          learnAtSkill = 370, estimatedCrafts = 5,
          materials = { { itemId = 36916, amount = 25 } } },

        -- Guide links spell=41975 here, which is Cobalt Gauntlets' ITEM id;
        -- same recipe again (see header).
        { minSkill = 375, maxSkill = 380, recipeSpellId = 55835, craftedItemId = 41975,
          learnAtSkill = 370, estimatedCrafts = 5,
          materials = { { itemId = 36916, amount = 25 } } },

        { minSkill = 380, maxSkill = 385, recipeSpellId = 54918, craftedItemId = 40949,
          learnAtSkill = 380, estimatedCrafts = 5,
          materials = { { itemId = 36916, amount = 35 } } },

        { minSkill = 385, maxSkill = 390, recipeSpellId = 54941, craftedItemId = 40950,
          learnAtSkill = 385, estimatedCrafts = 5,
          materials = { { itemId = 36916, amount = 35 } } },

        { minSkill = 390, maxSkill = 395, recipeSpellId = 55204, craftedItemId = 41243,
          learnAtSkill = 390, estimatedCrafts = 5,
          materials = { { itemId = 36916, amount = 50 } } },

        { minSkill = 395, maxSkill = 400, recipeSpellId = 59436, craftedItemId = 43860,
          learnAtSkill = 395, estimatedCrafts = 5,
          materials = {
              { itemId = 36916, amount = 30 },
              { itemId = 36913, amount = 25 },                          -- Saronite Bar
          } },

        { minSkill = 400, maxSkill = 405, recipeSpellId = 54949, craftedItemId = 40955,
          learnAtSkill = 400, estimatedCrafts = 5,
          materials = { { itemId = 36916, amount = 40 } } },

        { minSkill = 405, maxSkill = 416, recipeSpellId = 55206, craftedItemId = 41245,
          learnAtSkill = 405, estimatedCrafts = 11,
          materials = {
              { itemId = 36913, amount = 77 },
              { itemId = 37700, amount = 22 },                          -- Crystallized Air
          } },

        { minSkill = 416, maxSkill = 425, recipeSpellId = 55656, craftedItemId = 41611,
          learnAtSkill = 416, estimatedCrafts = 13,
          materials = {
              { itemId = 36913, amount = 52 },
              { itemId = 35624, amount = 13 },                          -- Eternal Earth
              { itemId = 35622, amount = 13 },                          -- Eternal Water
              { itemId = 35627, amount = 13 },                          -- Eternal Shadow
          } },

        { minSkill = 425, maxSkill = 430, recipeSpellId = 55839, craftedItemId = 41976,
          learnAtSkill = 425, estimatedCrafts = 7, approximate = true,
          materials = {
              { itemId = 36913, amount = 14 },
              { itemId = 41163, amount = 7 },                           -- Titanium Bar
          } },

        { minSkill = 430, maxSkill = 440, recipeSpellId = 59406, craftedItemId = 43853,
          learnAtSkill = 430, estimatedCrafts = 15, approximate = true,
          numMade = 20,  -- verified: one combine yields 20 skeleton keys
          materials = {
              { itemId = 36913, amount = 60 },
              { itemId = 41163, amount = 15 },
          } },

        { minSkill = 440, maxSkill = 450, recipeSpellId = 55303, craftedItemId = 41345,
          learnAtSkill = 440, estimatedCrafts = 25, approximate = true,
          materials = {
              { itemId = 36913, amount = 350 },
              { itemId = 35624, amount = 25 },
          } },
    },
})
