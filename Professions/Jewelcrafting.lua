-- ProfessionPilot Professions/Jewelcrafting.lua
-- Static leveling data for Jewelcrafting 1-450 on WotLK 3.3.5a.
--
-- Source: Wowhead WotLK Jewelcrafting Leveling 1-450 guide (DOM-extracted
-- 2026-08-08, same method as Engineering/Tailoring/Leatherworking). All 30
-- recipe spells (27 steps + 2 meta-cut alternatives + rank spells checked)
-- cross-checked against AtlasLoot_Crafting data for this exact client:
-- spell id -> crafted item id confirmed for every step. learnAtSkill for
-- classic/TBC recipes comes from AtlasLoot (#sr# values); Northrend recipes
-- are trainer-taught without a skill rating in AtlasLoot, so learnAtSkill
-- conservatively equals the step's minSkill there.
--
-- Modeling decisions:
--   * Prospecting is NOT modeled; all gems are plain farm/buy materials.
--   * The three "cut any uncommon gem" windows have no single recipe in the
--     guide; each is modeled with ONE cheap representative cut (Teardrop
--     Blood Garnet for 300-325, Dazzling Deep Peridot for 335-340, Solid
--     Chalcedony for 350-395) and flagged NOTE_JC_ANY_GEM + approximate --
--     any uncommon cut of the era works, use whatever is cheapest.
--   * 420-440 is TWO parallel steps (Engineering precedent): one Earthsiege
--     cut (Persistent, alt: Powerful) and one Skyflare cut (Swift, alt:
--     Tireless), ~10 raw meta gems each = the guide's "20 of any".
--   * Icy Prism (440-450) has a 20 hour cooldown -> NOTE_JC_PRISM_CD.
--
-- Intermediate balance (produced vs consumed by later steps):
--   * Delicate Copper Wire 55/55, Bronze Setting 50/50, Thorium Setting
--     56/56, Mercurial Adamantite 12/12 -- all exact.
--   * Mithril Filigree: 40 produced but 71 consumed (56 Truesilver Ring +
--     15 Aquamarine Pendant) -> aggregation auto-adds 31 crafts, i.e. the
--     real mithril bar total is 142, not the guide list's 80.
--
-- Guide inconsistencies NOT carried over (totals always computed from steps):
--   * shopping list omits the 10 Frozen Orbs for Icy Prism entirely,
--   * "70 of any" Northrend uncommon gems understates the steps' demand of
--     95 (60 window + 5 Bloodstone for Bloodstone Band + 30 prism-specific:
--     10 Chalcedony, 10 Shadow Crystal, 10 Dark Jade),
--   * "45 of any" TBC uncommon gems vs 42 actually used by the steps (35+7).
--
-- Pattern: Pendant of the Agate Shield (item 20970) is a VENDOR recipe,
-- sold in Wetlands (Alliance) / Thousand Needles (Horde).
--
-- Only ids here; localized names come from GetSpellInfo/GetItemInfo at runtime.

local PP = _G.ProfessionPilot

PP:RegisterProfession({
    key = "jewelcrafting",
    professionSpellId = 25229,  -- rank-1 spell; name equals the skill line name
    maxSkill = 450,
    ranks = { 75, 150, 225, 300, 375, 450 },

    steps = {
        -- === Apprentice (cap 75) ===
        { minSkill = 1, maxSkill = 35, recipeSpellId = 25255, craftedItemId = 20816,
          learnAtSkill = 1, estimatedCrafts = 55, saveForLater = true,
          materials = { { itemId = 2840, amount = 110 } } },             -- Copper Bar

        { minSkill = 35, maxSkill = 50, recipeSpellId = 32179, craftedItemId = 25439,
          learnAtSkill = 20, estimatedCrafts = 15,
          notesKey = "NOTE_LEARN_JOURNEYMAN",
          materials = {
              { itemId = 818, amount = 15 },                             -- Tigerseye
              { itemId = 20816, amount = 15, craftedBy = 25255 },
          } },

        -- === Journeyman (cap 150) ===
        { minSkill = 50, maxSkill = 80, recipeSpellId = 25278, craftedItemId = 20817,
          learnAtSkill = 50, estimatedCrafts = 50, saveForLater = true,
          materials = { { itemId = 2841, amount = 100 } } },             -- Bronze Bar

        { minSkill = 80, maxSkill = 100, recipeSpellId = 25287, craftedItemId = 20823,
          learnAtSkill = 70, estimatedCrafts = 20,
          materials = {
              { itemId = 1210, amount = 40 },                           -- Shadowgem
              { itemId = 20817, amount = 20, craftedBy = 25278 },
              { itemId = 20816, amount = 40, craftedBy = 25255 },
          } },

        { minSkill = 100, maxSkill = 110, recipeSpellId = 25318, craftedItemId = 20828,
          learnAtSkill = 100, estimatedCrafts = 10,
          materials = {
              { itemId = 1210, amount = 20 },
              { itemId = 2841, amount = 20 },
          } },

        { minSkill = 110, maxSkill = 120, recipeSpellId = 32807, craftedItemId = 25881,
          learnAtSkill = 110, estimatedCrafts = 10,
          materials = { { itemId = 2838, amount = 80 } } },              -- Heavy Stone

        { minSkill = 120, maxSkill = 150, recipeSpellId = 25610, craftedItemId = 20950,
          learnAtSkill = 120, estimatedCrafts = 30,
          source = "vendor", sourceItemId = 20970,
          vendorNoteKey = "NOTE_VENDOR_JC_AGATE",
          notesKey = "NOTE_LEARN_EXPERT",
          materials = {
              { itemId = 1206, amount = 30 },                           -- Moss Agate
              { itemId = 20817, amount = 30, craftedBy = 25278 },
          } },

        -- === Expert (cap 225) ===
        { minSkill = 150, maxSkill = 180, recipeSpellId = 25615, craftedItemId = 20963,
          learnAtSkill = 150, estimatedCrafts = 40, saveForLater = true,
          materials = { { itemId = 3860, amount = 80 } } },              -- Mithril Bar

        { minSkill = 180, maxSkill = 185, recipeSpellId = 32808, craftedItemId = 25882,
          learnAtSkill = 175, estimatedCrafts = 9, approximate = true,
          materials = { { itemId = 7912, amount = 90 } } },              -- Solid Stone

        { minSkill = 185, maxSkill = 210, recipeSpellId = 25620, craftedItemId = 20960,
          learnAtSkill = 170, estimatedCrafts = 28, approximate = true,
          materials = {
              { itemId = 6037, amount = 28 },                           -- Truesilver Bar
              { itemId = 20963, amount = 56, craftedBy = 25615 },
          } },

        { minSkill = 210, maxSkill = 220, recipeSpellId = 26874, craftedItemId = 20964,
          learnAtSkill = 210, estimatedCrafts = 10,
          materials = {
              { itemId = 7909, amount = 30 },                           -- Aquamarine
              { itemId = 8151, amount = 40 },                           -- Flask of Mojo
          } },

        { minSkill = 220, maxSkill = 225, recipeSpellId = 26876, craftedItemId = 21755,
          learnAtSkill = 220, estimatedCrafts = 5,
          notesKey = "NOTE_LEARN_ARTISAN",
          materials = {
              { itemId = 7909, amount = 5 },
              { itemId = 20963, amount = 15, craftedBy = 25615 },
          } },

        -- === Artisan (cap 300) ===
        { minSkill = 225, maxSkill = 250, recipeSpellId = 26880, craftedItemId = 21752,
          learnAtSkill = 225, estimatedCrafts = 56, saveForLater = true,
          materials = { { itemId = 12359, amount = 56 } } },             -- Thorium Bar

        { minSkill = 250, maxSkill = 260, recipeSpellId = 26883, craftedItemId = 21764,
          learnAtSkill = 235, estimatedCrafts = 10,
          materials = {
              { itemId = 7910, amount = 10 },                           -- Star Ruby
              { itemId = 21752, amount = 10, craftedBy = 26880 },
          } },

        { minSkill = 260, maxSkill = 281, recipeSpellId = 26902, craftedItemId = 21767,
          learnAtSkill = 260, estimatedCrafts = 21,
          materials = {
              { itemId = 12799, amount = 21 },                          -- Large Opal
              { itemId = 21752, amount = 21, craftedBy = 26880 },
          } },

        { minSkill = 281, maxSkill = 295, recipeSpellId = 36526, craftedItemId = 30422,
          learnAtSkill = 265, estimatedCrafts = 20, approximate = true,
          materials = {
              { itemId = 12800, amount = 20 },                          -- Azerothian Diamond
              { itemId = 21752, amount = 20, craftedBy = 26880 },
          } },

        { minSkill = 295, maxSkill = 300, recipeSpellId = 34961, craftedItemId = 29160,
          learnAtSkill = 290, estimatedCrafts = 5,
          notesKey = "NOTE_LEARN_MASTER",
          materials = {
              { itemId = 12364, amount = 10 },                          -- Huge Emerald
              { itemId = 21752, amount = 5, craftedBy = 26880 },
          } },

        -- === Master (cap 375) ===
        -- "Cut any uncommon TBC gem"; representative: Teardrop Blood Garnet.
        { minSkill = 300, maxSkill = 325, recipeSpellId = 28903, craftedItemId = 23094,
          learnAtSkill = 300, estimatedCrafts = 35, approximate = true,
          notesKey = "NOTE_JC_ANY_GEM",
          materials = { { itemId = 23077, amount = 35 } } },             -- Blood Garnet

        { minSkill = 325, maxSkill = 335, recipeSpellId = 38068, craftedItemId = 31079,
          learnAtSkill = 325, estimatedCrafts = 12, saveForLater = true,
          materials = {
              { itemId = 24243, amount = 48 },                          -- Adamantite Powder
              { itemId = 22452, amount = 12 },                          -- Primal Earth
          } },

        -- "Cut any uncommon TBC gem"; representative: Dazzling Deep Peridot.
        { minSkill = 335, maxSkill = 340, recipeSpellId = 28924, craftedItemId = 23106,
          learnAtSkill = 325, estimatedCrafts = 7, approximate = true,
          notesKey = "NOTE_JC_ANY_GEM",
          materials = { { itemId = 23079, amount = 7 } } },              -- Deep Peridot

        { minSkill = 340, maxSkill = 350, recipeSpellId = 31052, craftedItemId = 24078,
          learnAtSkill = 335, estimatedCrafts = 12, approximate = true,
          notesKey = "NOTE_LEARN_GRANDMASTER",
          materials = {
              { itemId = 23446, amount = 12 },                          -- Adamantite Bar
              { itemId = 31079, amount = 12, craftedBy = 38068 },
          } },

        -- === Grand Master (cap 450) ===
        -- "Cut any uncommon Northrend gem"; representative: Solid Chalcedony.
        { minSkill = 350, maxSkill = 395, recipeSpellId = 53934, craftedItemId = 39919,
          learnAtSkill = 350, estimatedCrafts = 60, approximate = true,
          notesKey = "NOTE_JC_ANY_GEM",
          materials = { { itemId = 36923, amount = 60 } } },             -- Chalcedony

        { minSkill = 395, maxSkill = 400, recipeSpellId = 56193, craftedItemId = 42336,
          learnAtSkill = 395, estimatedCrafts = 5,
          materials = {
              { itemId = 37701, amount = 10 },                          -- Crystallized Earth
              { itemId = 36917, amount = 5 },                           -- Bloodstone
          } },

        { minSkill = 400, maxSkill = 420, recipeSpellId = 58145, craftedItemId = 43248,
          learnAtSkill = 400, estimatedCrafts = 23,
          materials = { { itemId = 35624, amount = 46 } } },             -- Eternal Earth

        -- Parallel meta-cut windows (Engineering precedent): 10 Earthsiege +
        -- 10 Skyflare cuts = the guide's "20 of any" raw meta gems.
        { minSkill = 420, maxSkill = 440, recipeSpellId = 55402, craftedItemId = 41381,
          learnAtSkill = 420, estimatedCrafts = 10, approximate = true,
          alternatives = { { recipeSpellId = 55399, condKey = "ALT_MAT_CHOICE" } },
          materials = { { itemId = 41334, amount = 10 } } },             -- Earthsiege Diamond

        { minSkill = 420, maxSkill = 440, recipeSpellId = 55394, craftedItemId = 41339,
          learnAtSkill = 420, estimatedCrafts = 10, approximate = true,
          alternatives = { { recipeSpellId = 55386, condKey = "ALT_MAT_CHOICE" } },
          materials = { { itemId = 41266, amount = 10 } } },             -- Skyflare Diamond

        { minSkill = 440, maxSkill = 450, recipeSpellId = 62242, craftedItemId = 44943,
          learnAtSkill = 440, estimatedCrafts = 10,
          notesKey = "NOTE_JC_PRISM_CD",
          materials = {
              { itemId = 43102, amount = 10 },                          -- Frozen Orb
              { itemId = 36923, amount = 10 },                          -- Chalcedony
              { itemId = 36926, amount = 10 },                          -- Shadow Crystal
              { itemId = 36932, amount = 10 },                          -- Dark Jade
          } },
    },
})
