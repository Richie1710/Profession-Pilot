-- ProfessionPilot Professions/Enchanting.lua
-- Static leveling data for Enchanting 1-450 on WotLK 3.3.5a.
--
-- Source: Wowhead WotLK Enchanting Leveling 1-450 guide (DOM-extracted
-- 2026-08-08, same method as the other professions). All 40 recipe spells
-- (44 steps; four recipes cover two skill windows each) cross-checked
-- against AtlasLoot_Crafting data for this exact client. learnAtSkill for
-- classic/TBC recipes comes from AtlasLoot (#sr# values); Northrend recipes
-- carry no skill rating there, so learnAtSkill conservatively equals the
-- step's minSkill (first window for repeated recipes).
--
-- Enchanting specifics:
--   * Most steps are ENCHANTS: they create no item, so craftedItemId is
--     omitted and the production pool stays inactive for them. Only the
--     nine runed rods, the Greater Magic Wand and the two oils craft items.
--   * Runed rods are required tools (kept, saveForLater). Each rod step
--     consumes the vendor-bought plain rod plus the PREVIOUS runed rod via
--     a craftedBy link: in game the old rod is a tool and not destroyed,
--     but the link makes aggregation build the rods in order and keeps
--     runed rods off the shopping list. AtlasLoot fixes two crafted-item
--     ids the guide dump does not carry: Lesser Mana Oil -> item 20747,
--     Runed Titanium Rod -> item 44452.
--   * Dusts/essences/shards come from disenchanting or the AH (no
--     craftedBy); the guide never uses lesser<->greater essence
--     conversions, so none are modeled.
--
-- Guide inconsistencies NOT carried over (totals always come from steps):
--   * Bracer Assault (301-310): the row lists 6 arcane dust for 9 crafts;
--     the enchant costs 6 dust PER craft -> stored 54. The shopping list's
--     350 arcane dust implies 60 there (10 crafts); the steps total 344.
--   * Shield Defense (420-425): the row says 4 crafts but lists materials
--     for 5 at the 6 dust + 6 eternal earth per-craft ratio its own second
--     window confirms (426-430: 4 crafts, 24/24) -> stored 5. With that,
--     the list's 742 infinite dust and 134 eternal earth match exactly.
--   * soul dust: steps need 122, the list says 130; vision dust: steps
--     need 237, the list says 240.
--   * 15x Imbued Vial (Superior Wizard Oil) are missing from the list.
--   * dream shards: the list's 60 = 48 consumed by steps + 12 spent buying
--     the three Dalaran formulas (4 each); formula costs are not modeled
--     as step materials.

local PP = _G.ProfessionPilot

PP:RegisterProfession({
    key = "enchanting",
    professionSpellId = 7411,  -- rank-1 spell; name equals the skill line name
    maxSkill = 450,
    ranks = { 75, 150, 225, 300, 375, 450 },

    steps = {
        -- === Apprentice (cap 75) ===
        { minSkill = 1, maxSkill = 2, recipeSpellId = 7421, craftedItemId = 6218,
          learnAtSkill = 1, estimatedCrafts = 1, saveForLater = true,
          notesKey = "NOTE_TOOL",
          materials = {
              { itemId = 6217, amount = 1 },                            -- Copper Rod
              { itemId = 10940, amount = 1 },                           -- Strange Dust
              { itemId = 10938, amount = 1 },                           -- Lesser Magic Essence
          } },

        { minSkill = 2, maxSkill = 50, recipeSpellId = 7418,
          learnAtSkill = 1, estimatedCrafts = 48,
          notesKey = "NOTE_DISENCHANT",
          materials = { { itemId = 10940, amount = 48 } } },

        -- === Journeyman (cap 150) ===
        { minSkill = 50, maxSkill = 90, recipeSpellId = 7418,
          learnAtSkill = 1, estimatedCrafts = 40,
          notesKey = "NOTE_LEARN_JOURNEYMAN",
          materials = { { itemId = 10940, amount = 40 } } },

        { minSkill = 90, maxSkill = 100, recipeSpellId = 7457,
          learnAtSkill = 50, estimatedCrafts = 10,
          materials = { { itemId = 10940, amount = 30 } } },

        { minSkill = 100, maxSkill = 101, recipeSpellId = 7795, craftedItemId = 6339,
          learnAtSkill = 100, estimatedCrafts = 1, saveForLater = true,
          notesKey = "NOTE_TOOL",
          materials = {
              { itemId = 6338, amount = 1 },                            -- Silver Rod
              { itemId = 10940, amount = 6 },
              { itemId = 10939, amount = 3 },                           -- Greater Magic Essence
              { itemId = 6218, amount = 1, craftedBy = 7421 },          -- Runed Copper Rod (tool)
          } },

        { minSkill = 101, maxSkill = 110, recipeSpellId = 14807, craftedItemId = 11288,
          learnAtSkill = 70, estimatedCrafts = 9,
          materials = {
              { itemId = 4470, amount = 9 },                            -- Simple Wood
              { itemId = 10939, amount = 9 },
          } },

        { minSkill = 110, maxSkill = 135, recipeSpellId = 13419,
          learnAtSkill = 110, estimatedCrafts = 25,
          source = "vendor", sourceItemId = 11039,
          vendorNoteKey = "NOTE_VENDOR_ASHENVALE",
          notesKey = "NOTE_LEARN_EXPERT",
          materials = { { itemId = 10998, amount = 25 } } },            -- Lesser Astral Essence

        -- === Expert (cap 225) ===
        { minSkill = 135, maxSkill = 155, recipeSpellId = 13501,
          learnAtSkill = 130, estimatedCrafts = 20,
          materials = { { itemId = 11083, amount = 40 } } },            -- Soul Dust

        { minSkill = 155, maxSkill = 156, recipeSpellId = 13628, craftedItemId = 11130,
          learnAtSkill = 150, estimatedCrafts = 1, saveForLater = true,
          notesKey = "NOTE_TOOL",
          materials = {
              { itemId = 11128, amount = 1 },                           -- Golden Rod
              { itemId = 5500, amount = 1 },                            -- Iridescent Pearl
              { itemId = 11082, amount = 2 },                           -- Greater Astral Essence
              { itemId = 11083, amount = 2 },
              { itemId = 6339, amount = 1, craftedBy = 7795 },          -- Runed Silver Rod (tool)
          } },

        { minSkill = 156, maxSkill = 185, recipeSpellId = 13536,
          learnAtSkill = 140, estimatedCrafts = 40,
          source = "vendor", sourceItemId = 11101,
          vendorNoteKey = "NOTE_VENDOR_ASHENVALE",
          materials = { { itemId = 11083, amount = 80 } } },

        { minSkill = 185, maxSkill = 200, recipeSpellId = 13661,
          learnAtSkill = 180, estimatedCrafts = 15,
          materials = { { itemId = 11137, amount = 15 } } },            -- Vision Dust

        { minSkill = 200, maxSkill = 201, recipeSpellId = 13702, craftedItemId = 11145,
          learnAtSkill = 200, estimatedCrafts = 1, saveForLater = true,
          notesKey = "NOTE_TOOL",
          materials = {
              { itemId = 11144, amount = 1 },                           -- Truesilver Rod
              { itemId = 7971, amount = 1 },                            -- Black Pearl
              { itemId = 11135, amount = 2 },                           -- Greater Mystic Essence
              { itemId = 11137, amount = 2 },
              { itemId = 11130, amount = 1, craftedBy = 13628 },        -- Runed Golden Rod (tool)
          } },

        { minSkill = 201, maxSkill = 220, recipeSpellId = 13661,
          learnAtSkill = 180, estimatedCrafts = 25, approximate = true,
          materials = { { itemId = 11137, amount = 25 } } },

        { minSkill = 220, maxSkill = 225, recipeSpellId = 13746,
          learnAtSkill = 205, estimatedCrafts = 5,
          notesKey = "NOTE_LEARN_ARTISAN",
          materials = { { itemId = 11137, amount = 15 } } },

        -- === Artisan (cap 300) ===
        { minSkill = 225, maxSkill = 230, recipeSpellId = 13815,
          learnAtSkill = 210, estimatedCrafts = 5,
          materials = {
              { itemId = 11174, amount = 5 },                           -- Lesser Nether Essence
              { itemId = 11137, amount = 5 },
          } },

        { minSkill = 230, maxSkill = 235, recipeSpellId = 13836,
          learnAtSkill = 215, estimatedCrafts = 5,
          materials = { { itemId = 11137, amount = 25 } } },

        { minSkill = 235, maxSkill = 250, recipeSpellId = 13858,
          learnAtSkill = 220, estimatedCrafts = 25,
          materials = { { itemId = 11137, amount = 150 } } },

        { minSkill = 250, maxSkill = 265, recipeSpellId = 25127, craftedItemId = 20747,
          learnAtSkill = 250, estimatedCrafts = 20, approximate = true,
          source = "vendor", sourceItemId = 20754,
          vendorNoteKey = "NOTE_VENDOR_SILITHUS",
          materials = {
              { itemId = 11176, amount = 60 },                          -- Dream Dust
              { itemId = 8831, amount = 40 },                           -- Purple Lotus
              { itemId = 8925, amount = 20 },                           -- Crystal Vial
          } },

        { minSkill = 265, maxSkill = 290, recipeSpellId = 20017,
          learnAtSkill = 265, estimatedCrafts = 27, approximate = true,
          source = "vendor", sourceItemId = 16217,
          vendorNoteKey = "NOTE_VENDOR_UC_DARNASSUS",
          materials = { { itemId = 11176, amount = 135 } } },

        { minSkill = 290, maxSkill = 299, recipeSpellId = 20028,
          learnAtSkill = 290, estimatedCrafts = 9,
          notesKey = "NOTE_LEARN_MASTER",
          materials = { { itemId = 16204, amount = 72 } } },            -- Illusion Dust

        { minSkill = 299, maxSkill = 300, recipeSpellId = 20051, craftedItemId = 16207,
          learnAtSkill = 290, estimatedCrafts = 1, saveForLater = true,
          source = "vendor", sourceItemId = 16243,
          vendorNoteKey = "NOTE_VENDOR_MOONGLADE",
          notesKey = "NOTE_TOOL",
          materials = {
              { itemId = 16206, amount = 1 },                           -- Arcanite Rod
              { itemId = 13926, amount = 1 },                           -- Golden Pearl
              { itemId = 16204, amount = 10 },
              { itemId = 16203, amount = 4 },                           -- Greater Eternal Essence
              { itemId = 14344, amount = 2 },                           -- Large Brilliant Shard
              { itemId = 11145, amount = 1, craftedBy = 13702 },        -- Runed Truesilver Rod (tool)
          } },

        -- === Master (cap 375) ===
        { minSkill = 300, maxSkill = 301, recipeSpellId = 32664, craftedItemId = 22461,
          learnAtSkill = 300, estimatedCrafts = 1, saveForLater = true,
          notesKey = "NOTE_TOOL",
          materials = {
              { itemId = 25843, amount = 1 },                           -- Fel Iron Rod
              { itemId = 16203, amount = 4 },
              { itemId = 14344, amount = 6 },
              { itemId = 16207, amount = 1, craftedBy = 20051 },        -- Runed Arcanite Rod (tool)
          } },

        { minSkill = 301, maxSkill = 310, recipeSpellId = 34002,
          learnAtSkill = 300, estimatedCrafts = 9,
          materials = { { itemId = 22445, amount = 54 } } },            -- Arcane Dust (6/craft)

        { minSkill = 310, maxSkill = 316, recipeSpellId = 27899,
          learnAtSkill = 305, estimatedCrafts = 6,
          materials = { { itemId = 22445, amount = 36 } } },

        { minSkill = 316, maxSkill = 330, recipeSpellId = 33996,
          learnAtSkill = 310, estimatedCrafts = 16, approximate = true,
          materials = { { itemId = 22445, amount = 128 } } },

        { minSkill = 330, maxSkill = 335, recipeSpellId = 34009,
          learnAtSkill = 325, estimatedCrafts = 5,
          materials = { { itemId = 22445, amount = 75 } } },

        { minSkill = 335, maxSkill = 340, recipeSpellId = 44383,
          learnAtSkill = 330, estimatedCrafts = 5,
          materials = {
              { itemId = 22449, amount = 5 },                           -- Large Prismatic Shard
              { itemId = 22447, amount = 20 },                          -- Lesser Planar Essence
          } },

        { minSkill = 340, maxSkill = 350, recipeSpellId = 28019, craftedItemId = 22522,
          learnAtSkill = 340, estimatedCrafts = 15, approximate = true,
          source = "vendor", sourceItemId = 22563,
          vendorNoteKey = "NOTE_VENDOR_SHATTRATH",
          notesKey = "NOTE_LEARN_GRANDMASTER",
          materials = {
              { itemId = 22445, amount = 45 },
              { itemId = 22792, amount = 15 },                          -- Nightmare Vine
              { itemId = 18256, amount = 15 },                          -- Imbued Vial
          } },

        { minSkill = 350, maxSkill = 351, recipeSpellId = 32665, craftedItemId = 22462,
          learnAtSkill = 350, estimatedCrafts = 1, saveForLater = true,
          source = "vendor", sourceItemId = 25848,
          vendorNoteKey = "NOTE_VENDOR_HELLFIRE",
          notesKey = "NOTE_TOOL",
          materials = {
              { itemId = 25844, amount = 1 },                           -- Adamantite Rod
              { itemId = 22446, amount = 8 },                           -- Greater Planar Essence
              { itemId = 22449, amount = 8 },
              { itemId = 23571, amount = 1 },                           -- Primal Might
              { itemId = 22461, amount = 1, craftedBy = 32664 },        -- Runed Fel Iron Rod (tool)
          } },

        -- === Grand Master (cap 450) ===
        { minSkill = 351, maxSkill = 360, recipeSpellId = 60609,
          learnAtSkill = 351, estimatedCrafts = 9,
          materials = { { itemId = 34054, amount = 54 } } },            -- Infinite Dust

        { minSkill = 360, maxSkill = 375, recipeSpellId = 60616,
          learnAtSkill = 360, estimatedCrafts = 18, approximate = true,
          materials = { { itemId = 34054, amount = 108 } } },

        { minSkill = 375, maxSkill = 376, recipeSpellId = 32667, craftedItemId = 22463,
          learnAtSkill = 375, estimatedCrafts = 1, saveForLater = true,
          notesKey = "NOTE_TOOL",
          materials = {
              { itemId = 25845, amount = 1 },                           -- Eternium Rod
              { itemId = 22446, amount = 6 },
              { itemId = 22445, amount = 6 },
              { itemId = 22462, amount = 1, craftedBy = 32665 },        -- Runed Adamantite Rod (tool)
          } },

        { minSkill = 376, maxSkill = 380, recipeSpellId = 60616,
          learnAtSkill = 360, estimatedCrafts = 6, approximate = true,
          materials = { { itemId = 34054, amount = 36 } } },

        { minSkill = 380, maxSkill = 385, recipeSpellId = 44555,
          learnAtSkill = 380, estimatedCrafts = 5,
          materials = { { itemId = 34054, amount = 50 } } },

        { minSkill = 385, maxSkill = 395, recipeSpellId = 60623,
          learnAtSkill = 385, estimatedCrafts = 10,
          materials = {
              { itemId = 34054, amount = 80 },
              { itemId = 37705, amount = 10 },                          -- Crystallized Water
          } },

        { minSkill = 395, maxSkill = 410, recipeSpellId = 44500,
          learnAtSkill = 395, estimatedCrafts = 15,
          materials = { { itemId = 34054, amount = 135 } } },

        { minSkill = 410, maxSkill = 415, recipeSpellId = 44484,
          learnAtSkill = 410, estimatedCrafts = 5,
          materials = { { itemId = 34054, amount = 60 } } },

        { minSkill = 415, maxSkill = 420, recipeSpellId = 44508,
          learnAtSkill = 415, estimatedCrafts = 5,
          materials = {
              { itemId = 34054, amount = 50 },
              { itemId = 34055, amount = 5 },                           -- Greater Cosmic Essence
          } },

        { minSkill = 420, maxSkill = 425, recipeSpellId = 44489,
          learnAtSkill = 420, estimatedCrafts = 5, approximate = true,
          materials = {
              { itemId = 34054, amount = 30 },
              { itemId = 35624, amount = 30 },                          -- Eternal Earth
          } },

        { minSkill = 425, maxSkill = 426, recipeSpellId = 60619, craftedItemId = 44452,
          learnAtSkill = 425, estimatedCrafts = 1, saveForLater = true,
          notesKey = "NOTE_TOOL",
          materials = {
              { itemId = 41745, amount = 1 },                           -- Titanium Rod
              { itemId = 34054, amount = 40 },
              { itemId = 34055, amount = 12 },
              { itemId = 34052, amount = 8 },                           -- Dream Shard
              { itemId = 22463, amount = 1, craftedBy = 32667 },        -- Runed Eternium Rod (tool)
          } },

        { minSkill = 426, maxSkill = 430, recipeSpellId = 44489,
          learnAtSkill = 420, estimatedCrafts = 4,
          materials = {
              { itemId = 34054, amount = 24 },
              { itemId = 35624, amount = 24 },
          } },

        { minSkill = 430, maxSkill = 435, recipeSpellId = 47672,
          learnAtSkill = 430, estimatedCrafts = 5,
          source = "vendor", sourceItemId = 44471,
          vendorNoteKey = "NOTE_VENDOR_DALARAN",
          materials = {
              { itemId = 34054, amount = 75 },
              { itemId = 34055, amount = 10 },
          } },

        { minSkill = 435, maxSkill = 445, recipeSpellId = 44625,
          learnAtSkill = 435, estimatedCrafts = 10,
          source = "vendor", sourceItemId = 44485,
          vendorNoteKey = "NOTE_VENDOR_DALARAN",
          materials = {
              { itemId = 34052, amount = 20 },
              { itemId = 35624, amount = 80 },
          } },

        { minSkill = 445, maxSkill = 450, recipeSpellId = 60763,
          learnAtSkill = 445, estimatedCrafts = 5,
          source = "vendor", sourceItemId = 44490,
          vendorNoteKey = "NOTE_VENDOR_DALARAN",
          materials = {
              { itemId = 34055, amount = 20 },
              { itemId = 34052, amount = 20 },
          } },
    },
})
