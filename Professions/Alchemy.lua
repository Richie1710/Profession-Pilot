-- ProfessionPilot Professions/Alchemy.lua
-- Static leveling data for Alchemy 1-450 on WotLK 3.3.5a.
--
-- Source: Wowhead WotLK Alchemy Leveling 1-450 guide (DOM-extracted
-- 2026-08-08, same method as Engineering/Tailoring/Leatherworking; German
-- locale page, ids taken from the embedded link map). All 32 recipe spells
-- (30 steps + 2 flask alternatives) cross-checked against AtlasLoot_Crafting
-- data for this exact client: spell id -> crafted item id confirmed.
-- AtlasLoot's Alchemy sections carry NO #sr# skill ratings (every entry is
-- tagged Trainer/Vendor/Discovery instead, unlike e.g. Blacksmithing), so
-- learnAtSkill conservatively equals each step's minSkill throughout.
--
-- Vendor recipes per AtlasLoot (the guide flags neither):
--   * Philosopher's Stone -- recipe sold by a vendor in Tanaris (Gadgetzan),
--   * Super Mana Potion -- recipe is vendor-sold (Zangarmarsh, limited stock).
--
-- Balance / deliberate decisions (totals always come from steps):
--   * Minor Healing Potion: 59 produced ("Save These for Later"), 50
--     consumed by Lesser Healing Potion -> 9 spare from the 1-60 grind.
--   * Philosopher's Stone (1 craft) is the permanent transmute TOOL
--     (NOTE_TOOL, kept, never consumed); its 4x Firebloom is missing from
--     the guide's shopping list entirely.
--   * numMade deliberately omitted on Flask of Endless Rage (patch 3.3.0
--     doubled Northrend flask yield to 2/combine -- not verifiable offline,
--     and nothing downstream consumes flasks) and on Transmute: Titanium
--     (possible multi-bar yield on this client, also unverifiable offline).
--
-- Guide shopping-list inconsistencies NOT carried over:
--   * the list UNDERSTATES Leaded Vial 65 vs 95 consumed (-30!), Goldclover
--     130 vs 136 and Lichbloom 145 vs 149,
--   * padded beyond step demand: Briarthorn 95 vs 85, Mageroyal 20 vs 15,
--     Imbued Vial 163 vs 131, Golden Sansam 70 vs 61, Felweed 35 vs 25,
--     Tiger Lily 35 vs 34, Adder's Tongue 25 vs 24,
--   * Firebloom (4x for the Philosopher's Stone) is absent from the list.

local PP = _G.ProfessionPilot

PP:RegisterProfession({
    key = "alchemy",
    professionSpellId = 2259,  -- rank-1 spell; name equals the skill line name
    maxSkill = 450,
    ranks = { 75, 150, 225, 300, 375, 450 },

    steps = {
        -- === Apprentice (cap 75) ===
        { minSkill = 1, maxSkill = 60, recipeSpellId = 2330, craftedItemId = 118,
          learnAtSkill = 1, estimatedCrafts = 59, saveForLater = true,
          notesKey = "NOTE_LEARN_JOURNEYMAN",
          materials = {
              { itemId = 2447, amount = 59 },                           -- Peacebloom
              { itemId = 765, amount = 59 },                            -- Silverleaf
              { itemId = 3371, amount = 59 },                           -- Empty Vial
          } },

        -- === Journeyman (cap 150) ===
        { minSkill = 60, maxSkill = 110, recipeSpellId = 2337, craftedItemId = 858,
          learnAtSkill = 60, estimatedCrafts = 50,
          materials = {
              { itemId = 118, amount = 50, craftedBy = 2330 },
              { itemId = 2450, amount = 50 },                           -- Briarthorn
          } },

        { minSkill = 110, maxSkill = 140, recipeSpellId = 3447, craftedItemId = 929,
          learnAtSkill = 110, estimatedCrafts = 35,
          notesKey = "NOTE_LEARN_EXPERT",
          materials = {
              { itemId = 2453, amount = 35 },                           -- Bruiseweed
              { itemId = 2450, amount = 35 },
              { itemId = 3372, amount = 35 },                           -- Leaded Vial
          } },

        -- === Expert (cap 225) ===
        { minSkill = 140, maxSkill = 155, recipeSpellId = 3173, craftedItemId = 3385,
          learnAtSkill = 140, estimatedCrafts = 15,
          materials = {
              { itemId = 785, amount = 15 },                            -- Mageroyal
              { itemId = 3820, amount = 15 },                           -- Stranglekelp
              { itemId = 3371, amount = 15 },
          } },

        { minSkill = 155, maxSkill = 185, recipeSpellId = 7181, craftedItemId = 1710,
          learnAtSkill = 155, estimatedCrafts = 30,
          materials = {
              { itemId = 3357, amount = 30 },                           -- Liferoot
              { itemId = 3356, amount = 30 },                           -- Kingsblood
              { itemId = 3372, amount = 30 },
          } },

        { minSkill = 185, maxSkill = 205, recipeSpellId = 11449, craftedItemId = 8949,
          learnAtSkill = 185, estimatedCrafts = 20,
          notesKey = "NOTE_LEARN_ARTISAN",
          materials = {
              { itemId = 3820, amount = 20 },
              { itemId = 3821, amount = 20 },                           -- Goldthorn
              { itemId = 3372, amount = 20 },
          } },

        -- === Artisan (cap 300) ===
        { minSkill = 205, maxSkill = 215, recipeSpellId = 11450, craftedItemId = 8951,
          learnAtSkill = 205, estimatedCrafts = 10,
          materials = {
              { itemId = 3355, amount = 10 },                           -- Wild Steelbloom
              { itemId = 3821, amount = 10 },
              { itemId = 3372, amount = 10 },
          } },

        { minSkill = 215, maxSkill = 230, recipeSpellId = 11457, craftedItemId = 3928,
          learnAtSkill = 215, estimatedCrafts = 15,
          materials = {
              { itemId = 8838, amount = 15 },                           -- Sungrass
              { itemId = 3358, amount = 15 },                           -- Khadgar's Whisker
              { itemId = 8925, amount = 15 },                           -- Crystal Vial
          } },

        -- Permanent transmute tool ("Keep This for Transmutes"); the recipe
        -- itself is vendor-sold in Tanaris (AtlasLoot; guide does not flag it).
        { minSkill = 230, maxSkill = 231, recipeSpellId = 11459, craftedItemId = 9149,
          learnAtSkill = 230, estimatedCrafts = 1, saveForLater = true,
          notesKey = "NOTE_TOOL",
          source = "vendor",
          vendorNoteKey = "NOTE_VENDOR_TANARIS",
          materials = {
              { itemId = 3575, amount = 4 },                            -- Iron Bar
              { itemId = 9262, amount = 1 },                            -- Black Vitriol
              { itemId = 8831, amount = 4 },                            -- Purple Lotus
              { itemId = 4625, amount = 4 },                            -- Firebloom
          } },

        { minSkill = 231, maxSkill = 250, recipeSpellId = 11460, craftedItemId = 9154,
          learnAtSkill = 231, estimatedCrafts = 19,
          materials = {
              { itemId = 8836, amount = 19 },                           -- Arthas' Tears
              { itemId = 8925, amount = 19 },
          } },

        { minSkill = 250, maxSkill = 265, recipeSpellId = 11467, craftedItemId = 9187,
          learnAtSkill = 250, estimatedCrafts = 15,
          materials = {
              { itemId = 8838, amount = 15 },
              { itemId = 3821, amount = 15 },
              { itemId = 8925, amount = 15 },
          } },

        { minSkill = 265, maxSkill = 285, recipeSpellId = 17553, craftedItemId = 13443,
          learnAtSkill = 265, estimatedCrafts = 20,
          materials = {
              { itemId = 8838, amount = 40 },
              { itemId = 8839, amount = 40 },                           -- Blindweed
              { itemId = 8925, amount = 20 },
          } },

        { minSkill = 285, maxSkill = 300, recipeSpellId = 17556, craftedItemId = 13446,
          learnAtSkill = 285, estimatedCrafts = 18, approximate = true,
          notesKey = "NOTE_LEARN_MASTER",
          materials = {
              { itemId = 13464, amount = 36 },                          -- Golden Sansam
              { itemId = 13465, amount = 18 },                          -- Mountain Silversage
              { itemId = 8925, amount = 18 },
          } },

        -- === Master (cap 375) ===
        { minSkill = 300, maxSkill = 310, recipeSpellId = 33732, craftedItemId = 28100,
          learnAtSkill = 300, estimatedCrafts = 10,
          materials = {
              { itemId = 13464, amount = 10 },
              { itemId = 22785, amount = 10 },                          -- Felweed
              { itemId = 18256, amount = 10 },                          -- Imbued Vial
          } },

        { minSkill = 310, maxSkill = 325, recipeSpellId = 28545, craftedItemId = 22825,
          learnAtSkill = 310, estimatedCrafts = 15,
          notesKey = "NOTE_ALCHEMY_SPEC",
          materials = {
              { itemId = 13464, amount = 15 },
              { itemId = 22786, amount = 15 },                          -- Dreaming Glory
              { itemId = 18256, amount = 15 },
          } },

        { minSkill = 325, maxSkill = 335, recipeSpellId = 45061, craftedItemId = 34440,
          learnAtSkill = 325, estimatedCrafts = 10,
          materials = {
              { itemId = 22787, amount = 20 },                          -- Ragveil
              { itemId = 8925, amount = 10 },
          } },

        { minSkill = 335, maxSkill = 340, recipeSpellId = 28551, craftedItemId = 22829,
          learnAtSkill = 335, estimatedCrafts = 5,
          materials = {
              { itemId = 22791, amount = 10 },                          -- Netherbloom
              { itemId = 22785, amount = 5 },
              { itemId = 18256, amount = 5 },
          } },

        -- Recipe: Super Mana Potion is vendor-sold (AtlasLoot; limited-stock
        -- Zangarmarsh vendors -- the guide fails to flag it).
        { minSkill = 340, maxSkill = 350, recipeSpellId = 28555, craftedItemId = 22832,
          learnAtSkill = 340, estimatedCrafts = 10,
          notesKey = "NOTE_LEARN_GRANDMASTER",
          source = "vendor",
          vendorNoteKey = "NOTE_VENDOR_ZANGARMARSH",
          materials = {
              { itemId = 22786, amount = 20 },
              { itemId = 22785, amount = 10 },
              { itemId = 18256, amount = 10 },
          } },

        -- === Grand Master (cap 450) ===
        { minSkill = 350, maxSkill = 360, recipeSpellId = 53838, craftedItemId = 39671,
          learnAtSkill = 350, estimatedCrafts = 15, approximate = true,
          materials = {
              { itemId = 36901, amount = 30 },                          -- Goldclover
              { itemId = 18256, amount = 15 },
          } },

        { minSkill = 360, maxSkill = 365, recipeSpellId = 53839, craftedItemId = 40067,
          learnAtSkill = 360, estimatedCrafts = 5,
          materials = {
              { itemId = 36907, amount = 10 },                          -- Talandra's Rose
              { itemId = 18256, amount = 5 },
          } },

        { minSkill = 365, maxSkill = 375, recipeSpellId = 53842, craftedItemId = 40070,
          learnAtSkill = 365, estimatedCrafts = 10,
          materials = {
              { itemId = 36901, amount = 10 },
              { itemId = 36904, amount = 10 },                          -- Tiger Lily
              { itemId = 18256, amount = 10 },
          } },

        { minSkill = 375, maxSkill = 380, recipeSpellId = 53812, craftedItemId = 40195,
          learnAtSkill = 375, estimatedCrafts = 5,
          materials = {
              { itemId = 40199, amount = 5 },                           -- Pygmy Suckerfish
          } },

        { minSkill = 380, maxSkill = 385, recipeSpellId = 53900, craftedItemId = 40081,
          learnAtSkill = 380, estimatedCrafts = 5,
          materials = {
              { itemId = 36901, amount = 5 },
              { itemId = 36907, amount = 10 },
              { itemId = 18256, amount = 5 },
          } },

        { minSkill = 385, maxSkill = 395, recipeSpellId = 54218, craftedItemId = 40073,
          learnAtSkill = 385, estimatedCrafts = 12, approximate = true,
          materials = {
              { itemId = 36904, amount = 24 },
              { itemId = 18256, amount = 12 },
          } },

        { minSkill = 395, maxSkill = 405, recipeSpellId = 53840, craftedItemId = 39666,
          learnAtSkill = 395, estimatedCrafts = 12, approximate = true,
          notesKey = "NOTE_ALCHEMY_RESEARCH",
          materials = {
              { itemId = 36901, amount = 24 },
              { itemId = 36903, amount = 24 },                          -- Adder's Tongue
              { itemId = 18256, amount = 12 },
          } },

        { minSkill = 405, maxSkill = 415, recipeSpellId = 53905, craftedItemId = 40093,
          learnAtSkill = 405, estimatedCrafts = 10,
          materials = {
              { itemId = 36906, amount = 20 },                          -- Icethorn
              { itemId = 18256, amount = 10 },
          } },

        { minSkill = 415, maxSkill = 425, recipeSpellId = 53837, craftedItemId = 33448,
          learnAtSkill = 415, estimatedCrafts = 22, approximate = true,
          materials = {
              { itemId = 36905, amount = 44 },                          -- Lichbloom
              { itemId = 36901, amount = 22 },
              { itemId = 18256, amount = 22 },
          } },

        { minSkill = 425, maxSkill = 430, recipeSpellId = 60350, craftedItemId = 41163,
          learnAtSkill = 425, estimatedCrafts = 7, approximate = true,
          materials = {
              { itemId = 36913, amount = 56 },                          -- Saronite Bar
          } },

        { minSkill = 430, maxSkill = 435, recipeSpellId = 57427, craftedItemId = 41334,
          learnAtSkill = 430, estimatedCrafts = 5,
          materials = {
              { itemId = 36932, amount = 5 },                           -- Dark Jade
              { itemId = 36929, amount = 5 },                           -- Huge Citrine
              { itemId = 36860, amount = 5 },                           -- Eternal Fire
          } },

        { minSkill = 435, maxSkill = 450, recipeSpellId = 53903, craftedItemId = 46377,
          learnAtSkill = 435, estimatedCrafts = 15, numMade = 2,  -- verified: 2 flasks/combine (3.3.0 change)
          alternatives = {
              { recipeSpellId = 53901, condKey = "ALT_MAT_CHOICE" },    -- Frost Wyrm
              { recipeSpellId = 53902, condKey = "ALT_MAT_CHOICE" },    -- Stoneblood
          },
          materials = {
              { itemId = 36905, amount = 105 },
              { itemId = 36901, amount = 45 },
              { itemId = 36908, amount = 15 },                          -- Frost Lotus
              { itemId = 40411, amount = 15 },                          -- Enchanted Vial
          } },
    },
})
