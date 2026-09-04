-- ProfessionPilot Professions/Inscription.lua
-- Static leveling data for Inscription 1-450 on WotLK 3.3.5a.
--
-- Source: Wowhead WotLK Inscription Leveling 1-450 guide (DOM-extracted
-- 2026-08-08, same method as the other professions; German locale page, ids
-- from the embedded link map). Every fixed recipe spell cross-checked against
-- AtlasLoot_Crafting data for this exact client (spell id -> crafted item id).
-- Inscription is fully WotLK-era: AtlasLoot carries NO #sr# skill ratings
-- (Trainer labels only), so learnAtSkill equals each step's minSkill
-- throughout (same convention as Alchemy / the Northrend tailoring steps).
--
-- Milling: pigments are RAW materials here (no craftedBy) -- Milling (51005)
-- is a random-yield profession ability, not a trackable recipe, and it gives
-- no skill-ups on this client. The guide's shopping list speaks in herbs,
-- the step table speaks in pigments; steps are authoritative. Rare pigments
-- (Burnt 10, Sapphire 15, Icy 100) come as milling byproducts -- the guide's
-- herb counts are optimistic for those (esp. 100 Icy from ~100 mills).
--
-- Generic glyph windows: ten steps just say "N Glyphs (craft yellow or
-- higher)" without naming one. Each is modeled with a representative
-- trainer-taught glyph (AtlasLoot: Trainer source + item id confirmed;
-- the exact ink tier per glyph is not verifiable offline) and carries
-- notesKey NOTE_INSC_ANY_GLYPH: craft whatever glyph is yellow for you,
-- the ink/parchment demand per craft is what the guide's table states.
--
-- Northrend Inscription Research (61177, steps 31 and 38): discovery spell
-- with a 20 h cooldown and a random glyph as output -> two steps share the
-- spell id, craftedItemId is omitted (no fixed output), NOTE_INSC_RESEARCH.
-- Strange Tarot (59480) likewise creates a random card -> no craftedItemId.
--
-- Ink balance (production vs consumption; totals always come from steps):
--   * balanced: Ivory 17, Moonglow 22, Midnight 20, Dawnstar 10,
--     Jadefire 47, Shimmering 35, Ethereal 45.
--   * Lion's Ink: 40 produced but 45 consumed -> the chain expansion adds
--     5 inks = 10 extra Golden Pigment the guide list ignores.
--   * Ink of the Sea: 90 produced but 148 consumed -> +58 inks = +116 Azure
--     Pigment (true azure total 296; even the list's 500 herbs fall short).
--   * surplus: Celestial 55 produced / 45 consumed, Snowfall 50 / 21
--     (both crafted for skill-ups; leftovers are intended).
--   * Ink of the Sky (15) is crafted purely for skill points, never consumed.
--   * Fiery Ink (5x, Weapon Vellum II) has NO crafting step in the guide:
--     modeled as a raw material -- the player mills Ruby Pigment byproducts
--     and crafts the ink untracked (recipe 57710, Trainer per AtlasLoot).
--
-- Further deliberate decisions:
--   * Scroll steps use AtlasLoot's crafted item ids, which map every scroll
--     rank to the base item (Stamina->1180, Intellect/Spirit->955,
--     Strength/Agility->3012). Nothing consumes scrolls, so only the
--     (unused) production-pool credit is affected.
--   * NOTE_LEARN_EXPERT/ARTISAN/GRANDMASTER sit on the ink step FOLLOWING
--     the guide's "Learn ..." header (the trainer visit at 125/200/350),
--     because the guide's own row there is a generic glyph step that must
--     keep NOTE_INSC_ANY_GLYPH.
--   * Parchments (Light 81, Common 87, Heavy 90, Resilient 246) are vendor
--     trade goods sold by inscription suppliers.

local PP = _G.ProfessionPilot

PP:RegisterProfession({
    key = "inscription",
    professionSpellId = 45357,  -- rank-1 spell; name equals the skill line name
    maxSkill = 450,
    ranks = { 75, 150, 225, 300, 375, 450 },

    steps = {
        -- === Apprentice (cap 75) ===
        { minSkill = 1, maxSkill = 18, recipeSpellId = 52738, craftedItemId = 37101,
          learnAtSkill = 1, estimatedCrafts = 17, saveForLater = true,
          notesKey = "NOTE_INSC_MILLING",
          materials = { { itemId = 39151, amount = 17 } } },             -- Alabaster Pigment

        { minSkill = 18, maxSkill = 35, recipeSpellId = 45382, craftedItemId = 1180,
          learnAtSkill = 18, estimatedCrafts = 17,                       -- Scroll of Stamina
          materials = {
              { itemId = 37101, amount = 17, craftedBy = 52738 },       -- Ivory Ink
              { itemId = 39354, amount = 17 },                          -- Light Parchment
          } },

        { minSkill = 35, maxSkill = 53, recipeSpellId = 52843, craftedItemId = 39469,
          learnAtSkill = 35, estimatedCrafts = 22, saveForLater = true,
          materials = { { itemId = 39151, amount = 44 } } },

        { minSkill = 53, maxSkill = 75, recipeSpellId = 52739, craftedItemId = 38682,
          learnAtSkill = 53, estimatedCrafts = 22,                      -- Armor Vellum
          notesKey = "NOTE_LEARN_JOURNEYMAN",
          materials = {
              { itemId = 39469, amount = 22, craftedBy = 52843 },      -- Moonglow Ink
              { itemId = 39354, amount = 44 },
          } },

        -- === Journeyman (cap 150) ===
        { minSkill = 75, maxSkill = 80, recipeSpellId = 53462, craftedItemId = 39774,
          learnAtSkill = 75, estimatedCrafts = 20, saveForLater = true,
          materials = { { itemId = 39334, amount = 40 } } },             -- Dusky Pigment

        { minSkill = 80, maxSkill = 100, recipeSpellId = 57265, craftedItemId = 42461,
          learnAtSkill = 80, estimatedCrafts = 20,        -- any glyph; representative:
          notesKey = "NOTE_INSC_ANY_GLYPH",               -- Glyph of Health Funnel
          materials = {
              { itemId = 39774, amount = 20, craftedBy = 53462 },      -- Midnight Ink
              { itemId = 39354, amount = 20 },
          } },

        { minSkill = 100, maxSkill = 105, recipeSpellId = 57704, craftedItemId = 43116,
          learnAtSkill = 100, estimatedCrafts = 40, saveForLater = true,
          materials = { { itemId = 39338, amount = 80 } } },             -- Golden Pigment

        { minSkill = 105, maxSkill = 125, recipeSpellId = 57133, craftedItemId = 42974,
          learnAtSkill = 105, estimatedCrafts = 20,       -- any glyph; representative:
          notesKey = "NOTE_INSC_ANY_GLYPH",               -- Glyph of Sprint
          materials = {
              { itemId = 43116, amount = 20, craftedBy = 57704 },      -- Lion's Ink
              { itemId = 10648, amount = 20 },                         -- Common Parchment
          } },

        -- === Expert (cap 225) ===
        { minSkill = 125, maxSkill = 130, recipeSpellId = 57706, craftedItemId = 43117,
          learnAtSkill = 125, estimatedCrafts = 10, saveForLater = true,
          notesKey = "NOTE_LEARN_EXPERT",
          materials = { { itemId = 43104, amount = 10 } } },             -- Burnt Pigment

        { minSkill = 130, maxSkill = 145, recipeSpellId = 56973, craftedItemId = 42737,
          learnAtSkill = 130, estimatedCrafts = 15,       -- any glyph; representative:
          notesKey = "NOTE_INSC_ANY_GLYPH",               -- Glyph of Blink
          materials = {
              { itemId = 43116, amount = 15, craftedBy = 57704 },
              { itemId = 10648, amount = 15 },
          } },

        { minSkill = 145, maxSkill = 150, recipeSpellId = 59480,
          learnAtSkill = 145, estimatedCrafts = 5,        -- Strange Tarot (random card)
          materials = {
              { itemId = 43117, amount = 10, craftedBy = 57706 },      -- Dawnstar Ink
              { itemId = 10648, amount = 5 },
              { itemId = 43116, amount = 10, craftedBy = 57704 },
          } },

        { minSkill = 150, maxSkill = 155, recipeSpellId = 57707, craftedItemId = 43118,
          learnAtSkill = 150, estimatedCrafts = 47, saveForLater = true,
          materials = { { itemId = 39339, amount = 94 } } },             -- Emerald Pigment

        { minSkill = 155, maxSkill = 195, recipeSpellId = 57157, craftedItemId = 43417,
          learnAtSkill = 155, estimatedCrafts = 40,       -- any glyph; representative:
          notesKey = "NOTE_INSC_ANY_GLYPH",               -- Glyph of Hamstring
          materials = {
              { itemId = 43118, amount = 40, craftedBy = 57707 },      -- Jadefire Ink
              { itemId = 10648, amount = 40 },
          } },

        { minSkill = 195, maxSkill = 200, recipeSpellId = 57120, craftedItemId = 42961,
          learnAtSkill = 195, estimatedCrafts = 7, approximate = true,
          notesKey = "NOTE_INSC_ANY_GLYPH",               -- Glyph of Eviscerate
          materials = {
              { itemId = 43118, amount = 7, craftedBy = 57707 },
              { itemId = 10648, amount = 7 },
          } },

        -- === Artisan (cap 300) ===
        { minSkill = 200, maxSkill = 205, recipeSpellId = 57709, craftedItemId = 43120,
          learnAtSkill = 200, estimatedCrafts = 55, saveForLater = true,
          notesKey = "NOTE_LEARN_ARTISAN",
          materials = { { itemId = 39340, amount = 110 } } },            -- Violet Pigment

        { minSkill = 205, maxSkill = 245, recipeSpellId = 57197, craftedItemId = 42411,
          learnAtSkill = 205, estimatedCrafts = 40,       -- any glyph; representative:
          notesKey = "NOTE_INSC_ANY_GLYPH",               -- Glyph of Renew
          materials = {
              { itemId = 43120, amount = 40, craftedBy = 57709 },      -- Celestial Ink
              { itemId = 39501, amount = 40 },                         -- Heavy Parchment
          } },

        { minSkill = 245, maxSkill = 250, recipeSpellId = 59488, craftedItemId = 39350,
          learnAtSkill = 245, estimatedCrafts = 5,        -- Weapon Vellum II
          materials = {
              { itemId = 43121, amount = 5 },             -- Fiery Ink (RAW: no ink
              { itemId = 43120, amount = 5, craftedBy = 57709 },  -- step in the guide)
              { itemId = 39501, amount = 10 },
          } },

        { minSkill = 250, maxSkill = 255, recipeSpellId = 57711, craftedItemId = 43122,
          learnAtSkill = 250, estimatedCrafts = 35, saveForLater = true,
          materials = { { itemId = 39341, amount = 70 } } },             -- Silvery Pigment

        { minSkill = 255, maxSkill = 260, recipeSpellId = 50608, craftedItemId = 955,
          learnAtSkill = 255, estimatedCrafts = 5,        -- Scroll of Spirit V
          materials = {
              { itemId = 43122, amount = 5, craftedBy = 57711 },       -- Shimmering Ink
              { itemId = 39501, amount = 10 },
          } },

        { minSkill = 260, maxSkill = 275, recipeSpellId = 56981, craftedItemId = 42746,
          learnAtSkill = 260, estimatedCrafts = 15,       -- any glyph (2 ink/2 parchment
          notesKey = "NOTE_INSC_ANY_GLYPH",               -- each); repr.: Glyph of Icy Veins
          materials = {
              { itemId = 43122, amount = 30, craftedBy = 57711 },
              { itemId = 39501, amount = 30 },
          } },

        { minSkill = 275, maxSkill = 290, recipeSpellId = 57712, craftedItemId = 43123,
          learnAtSkill = 275, estimatedCrafts = 15,       -- Ink of the Sky: skill-ups
          notesKey = "NOTE_LEARN_MASTER",                 -- only, never consumed
          materials = { { itemId = 43107, amount = 15 } } },            -- Sapphire Pigment

        -- === Master (cap 375) ===
        { minSkill = 290, maxSkill = 305, recipeSpellId = 57713, craftedItemId = 43124,
          learnAtSkill = 290, estimatedCrafts = 45, saveForLater = true,
          materials = { { itemId = 39342, amount = 90 } } },             -- Nether Pigment

        { minSkill = 305, maxSkill = 350, recipeSpellId = 57024, craftedItemId = 41098,
          learnAtSkill = 305, estimatedCrafts = 45,       -- any glyph; representative:
          notesKey = "NOTE_INSC_ANY_GLYPH",               -- Glyph of Crusader Strike
          materials = {
              { itemId = 43124, amount = 45, craftedBy = 57713 },      -- Ethereal Ink
              { itemId = 39502, amount = 45 },                         -- Resilient Parchment
          } },

        -- === Grand Master (cap 450) ===
        { minSkill = 350, maxSkill = 355, recipeSpellId = 57715, craftedItemId = 43126,
          learnAtSkill = 350, estimatedCrafts = 90, saveForLater = true,
          notesKey = "NOTE_LEARN_GRANDMASTER",
          materials = { { itemId = 39343, amount = 180 } } },            -- Azure Pigment

        { minSkill = 355, maxSkill = 360, recipeSpellId = 50610, craftedItemId = 955,
          learnAtSkill = 355, estimatedCrafts = 5,        -- Scroll of Spirit VII
          materials = {
              { itemId = 43126, amount = 5, craftedBy = 57715 },       -- Ink of the Sea
              { itemId = 39502, amount = 10 },
          } },

        { minSkill = 360, maxSkill = 365, recipeSpellId = 50603, craftedItemId = 955,
          learnAtSkill = 360, estimatedCrafts = 5,        -- Scroll of Intellect VII
          materials = {
              { itemId = 43126, amount = 5, craftedBy = 57715 },
              { itemId = 39502, amount = 10 },
          } },

        { minSkill = 365, maxSkill = 370, recipeSpellId = 58490, craftedItemId = 3012,
          learnAtSkill = 365, estimatedCrafts = 5,        -- Scroll of Strength VII
          materials = {
              { itemId = 43126, amount = 5, craftedBy = 57715 },
              { itemId = 39502, amount = 10 },
          } },

        { minSkill = 370, maxSkill = 375, recipeSpellId = 58482, craftedItemId = 3012,
          learnAtSkill = 370, estimatedCrafts = 5,        -- Scroll of Agility VII
          materials = {
              { itemId = 43126, amount = 5, craftedBy = 57715 },
              { itemId = 39502, amount = 10 },
          } },

        { minSkill = 375, maxSkill = 380, recipeSpellId = 57716, craftedItemId = 43127,
          learnAtSkill = 375, estimatedCrafts = 50, saveForLater = true,
          materials = { { itemId = 43109, amount = 100 } } },            -- Icy Pigment

        { minSkill = 380, maxSkill = 385, recipeSpellId = 57219, craftedItemId = 43546,
          learnAtSkill = 380, estimatedCrafts = 7, approximate = true,
          notesKey = "NOTE_INSC_ANY_GLYPH",               -- repr.: Glyph of Icy Touch
          materials = {
              { itemId = 43126, amount = 7, craftedBy = 57715 },
              { itemId = 39502, amount = 7 },
          } },

        { minSkill = 385, maxSkill = 386, recipeSpellId = 61177,
          learnAtSkill = 385, estimatedCrafts = 1,        -- Northrend Inscription
          notesKey = "NOTE_INSC_RESEARCH",                -- Research (random glyph)
          materials = {
              { itemId = 43126, amount = 3, craftedBy = 57715 },
              { itemId = 43127, amount = 1, craftedBy = 57716 },       -- Snowfall Ink
              { itemId = 39502, amount = 3 },
          } },

        { minSkill = 386, maxSkill = 400, recipeSpellId = 57221, craftedItemId = 43548,
          learnAtSkill = 386, estimatedCrafts = 25,       -- any major glyph; repr.:
          notesKey = "NOTE_INSC_ANY_GLYPH",               -- Glyph of Plague Strike
          materials = {
              { itemId = 43126, amount = 25, craftedBy = 57715 },
              { itemId = 39502, amount = 25 },
          } },

        { minSkill = 400, maxSkill = 405, recipeSpellId = 50620, craftedItemId = 1180,
          learnAtSkill = 400, estimatedCrafts = 5,        -- Scroll of Stamina VIII
          materials = {
              { itemId = 43126, amount = 5, craftedBy = 57715 },
              { itemId = 39502, amount = 10 },
          } },

        { minSkill = 405, maxSkill = 410, recipeSpellId = 50611, craftedItemId = 955,
          learnAtSkill = 405, estimatedCrafts = 5,        -- Scroll of Spirit VIII
          materials = {
              { itemId = 43126, amount = 5, craftedBy = 57715 },
              { itemId = 39502, amount = 10 },
          } },

        { minSkill = 410, maxSkill = 415, recipeSpellId = 50604, craftedItemId = 955,
          learnAtSkill = 410, estimatedCrafts = 5,        -- Scroll of Intellect VIII
          materials = {
              { itemId = 43126, amount = 5, craftedBy = 57715 },
              { itemId = 39502, amount = 10 },
          } },

        { minSkill = 415, maxSkill = 420, recipeSpellId = 58491, craftedItemId = 3012,
          learnAtSkill = 415, estimatedCrafts = 5,        -- Scroll of Strength VIII
          materials = {
              { itemId = 43126, amount = 5, craftedBy = 57715 },
              { itemId = 39502, amount = 10 },
          } },

        { minSkill = 420, maxSkill = 430, recipeSpellId = 58483, craftedItemId = 3012,
          learnAtSkill = 420, estimatedCrafts = 13, approximate = true,
          materials = {                                   -- Scroll of Agility VIII
              { itemId = 43126, amount = 13, craftedBy = 57715 },
              { itemId = 39502, amount = 26 },
          } },

        { minSkill = 430, maxSkill = 450, recipeSpellId = 61177,
          learnAtSkill = 430, estimatedCrafts = 20,       -- research, 20 h cooldown:
          notesKey = "NOTE_INSC_RESEARCH",                -- 20 discoveries = 20 days
          materials = {
              { itemId = 43126, amount = 60, craftedBy = 57715 },
              { itemId = 43127, amount = 20, craftedBy = 57716 },
              { itemId = 39502, amount = 60 },
          } },
    },
})
