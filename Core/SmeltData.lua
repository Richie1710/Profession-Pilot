-- ProfessionPilot Core/SmeltData.lua
-- Informational ore->bar smelting data for the bar materials that appear in
-- the profession leveling paths. Pure static table + lookup, headless
-- testable. NOT part of the material aggregation -- consumed by tooltips /
-- info display only, so wrong or missing entries can never skew a total.
--
-- Verification (local data only, no invented ids):
--   * smeltSpellId <-> bar itemId: AtlasLoot_Crafting crafting.lua Smelting
--     section ("Smelt X" rows, same 3.3.5a client), independently confirmed
--     by LibPeriodicTable-3.1 "Tradeskill.RecipeLinks.Smelting"
--     (DataStore_Crafts / ArkInventory copies).
--   * ore itemId + ratio: LibPeriodicTable-3.1
--     "TradeskillResultMats.Forward.Smelting" (barId -> "oreId x count").
--   * miningSkill: AtlasLoot #sr# values -- INFORMATIONAL ONLY, shown in
--     tooltips, never used in calculations.
--   * Bronze numMade = 2 is the one value no local dump carries (PT stores
--     reagents, not yields); it is the long-established 3.3.5 yield of
--     Smelt Bronze.
--
-- Two entry shapes (consumers must handle both):
--   ore smelt:       { oreItemId, orePerBar, miningSkill, smeltSpellId }
--   multi-component: { components = { { itemId, amount }, ... }, numMade,
--                      miningSkill, smeltSpellId }        -- Bronze, Steel

local PP = _G.ProfessionPilot

local SmeltData = {
    -- [barItemId] = entry                                    bar <- input(s)
    [2840] = { oreItemId = 2770, orePerBar = 1,             -- Copper Bar <- 1 Copper Ore
               miningSkill = 1, smeltSpellId = 2657 },
    [3576] = { oreItemId = 2771, orePerBar = 1,             -- Tin Bar <- 1 Tin Ore
               miningSkill = 65, smeltSpellId = 3304 },
    [2841] = { components = { { itemId = 2840, amount = 1 },-- 2x Bronze Bar <-
                              { itemId = 3576, amount = 1 } }, -- 1 Copper + 1 Tin Bar
               numMade = 2,
               miningSkill = 65, smeltSpellId = 2659 },
    [2842] = { oreItemId = 2775, orePerBar = 1,             -- Silver Bar <- 1 Silver Ore
               miningSkill = 75, smeltSpellId = 2658 },
    [3575] = { oreItemId = 2772, orePerBar = 1,             -- Iron Bar <- 1 Iron Ore
               miningSkill = 125, smeltSpellId = 3307 },
    [3577] = { oreItemId = 2776, orePerBar = 1,             -- Gold Bar <- 1 Gold Ore
               miningSkill = 155, smeltSpellId = 3308 },
    [3859] = { components = { { itemId = 3575, amount = 1 },-- Steel Bar <-
                              { itemId = 3857, amount = 1 } }, -- 1 Iron Bar + 1 Coal
               numMade = 1,
               miningSkill = 165, smeltSpellId = 3569 },
    [3860] = { oreItemId = 3858, orePerBar = 1,             -- Mithril Bar <- 1 Mithril Ore
               miningSkill = 175, smeltSpellId = 10097 },
    [12359] = { oreItemId = 10620, orePerBar = 1,           -- Thorium Bar <- 1 Thorium Ore
                miningSkill = 250, smeltSpellId = 16153 },
    [23445] = { oreItemId = 23424, orePerBar = 2,           -- Fel Iron Bar <- 2 Fel Iron Ore
                miningSkill = 300, smeltSpellId = 29356 },
    [23446] = { oreItemId = 23425, orePerBar = 2,           -- Adamantite Bar <- 2 Adamantite Ore
                miningSkill = 325, smeltSpellId = 29358 },
    [36916] = { oreItemId = 36909, orePerBar = 1,           -- Cobalt Bar <- 1 Cobalt Ore
                miningSkill = 350, smeltSpellId = 49252 },
    [36913] = { oreItemId = 36912, orePerBar = 2,           -- Saronite Bar <- 2 Saronite Ore
                miningSkill = 400, smeltSpellId = 49258 },
    [41163] = { oreItemId = 36910, orePerBar = 2,           -- Titanium Bar <- 2 Titanium Ore
                miningSkill = 450, smeltSpellId = 55211 },
}

-- Entry for a bar item id, nil for anything that is not a covered bar.
function SmeltData.Get(itemId)
    return SmeltData[itemId]
end

PP.SmeltData = SmeltData
