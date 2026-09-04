-- Integrity tests for Core/SmeltData.lua (informational ore->bar data).
-- Anchors verified against AtlasLoot_Crafting (Smelting section) and
-- LibPeriodicTable-3.1 TradeskillResultMats/RecipeLinks dumps.

local PP = _G.ProfessionPilot

-- Core/SmeltData.lua is not in run_tests' CODE list; self-load it so this
-- file works from the manifest and as a single-file run alike (same root
-- discovery as test_load_all, idempotent once run_tests loads it itself).
if not PP.SmeltData then
    local root = ((arg and arg[0] or ""):match("^(.*)[/\\]") or ".") .. "/.."
    dofile(root .. "/Core/SmeltData.lua")
end

local SD = PP.SmeltData
T.ok(SD, "SmeltData loaded")
if not SD then return end
T.eq(type(SD.Get), "function", "Get lookup exists")

-- Shape validation over every entry (skip the Get function member).
local count = 0
local seenSpell = {}
for barId, e in pairs(SD) do
    if type(barId) == "number" then
        count = count + 1
        local where = "bar " .. barId
        T.eq(type(e.smeltSpellId), "number", where .. ": smeltSpellId is number")
        T.eq(type(e.miningSkill), "number", where .. ": miningSkill is number")
        T.ok(not seenSpell[e.smeltSpellId], where .. ": smeltSpellId unique")
        seenSpell[e.smeltSpellId] = true

        if e.components then
            T.ok(e.oreItemId == nil and e.orePerBar == nil,
                where .. ": component shape carries no oreItemId/orePerBar")
            T.ok(type(e.numMade) == "number" and e.numMade >= 1,
                where .. ": numMade valid")
            T.ok(#e.components >= 2, where .. ": at least two components")
            for i, c in ipairs(e.components) do
                T.ok(type(c.itemId) == "number" and type(c.amount) == "number"
                    and c.amount > 0,
                    where .. ": component " .. i .. " well-formed")
            end
        else
            T.eq(type(e.oreItemId), "number", where .. ": oreItemId is number")
            T.ok(type(e.orePerBar) == "number" and e.orePerBar > 0,
                where .. ": orePerBar valid")
        end
    end
end
T.eq(count, 14, "exactly 14 bars covered")

-- Spot anchors ---------------------------------------------------------------
local copper = SD.Get(2840)
T.eq(copper.oreItemId, 2770, "Copper Bar from Copper Ore 2770 (not 2775!)")
T.eq(copper.orePerBar, 1, "1 copper ore per bar")
T.eq(copper.smeltSpellId, 2657, "Smelt Copper spell 2657")
T.eq(copper.miningSkill, 1, "copper smeltable at mining 1")

T.eq(SD.Get(2842).oreItemId, 2775, "Silver Bar from Silver Ore 2775")
T.eq(SD.Get(3576).oreItemId, 2771, "Tin Bar from Tin Ore 2771")
T.eq(SD.Get(3575).oreItemId, 2772, "Iron Bar from Iron Ore 2772")
T.eq(SD.Get(3577).oreItemId, 2776, "Gold Bar from Gold Ore 2776")

-- Bronze: bar + bar -> 2 bars, the special multi-component shape.
local bronze = SD.Get(2841)
T.ok(bronze.components, "bronze uses the component shape")
T.eq(bronze.oreItemId, nil, "bronze has no oreItemId")
T.eq(bronze.numMade, 2, "bronze yields 2 bars per smelt")
T.eq(#bronze.components, 2, "bronze has 2 components")
T.eq(bronze.components[1].itemId, 2840, "bronze component 1: Copper Bar")
T.eq(bronze.components[1].amount, 1, "bronze: 1 copper bar")
T.eq(bronze.components[2].itemId, 3576, "bronze component 2: Tin Bar")
T.eq(bronze.components[2].amount, 1, "bronze: 1 tin bar")
T.eq(bronze.smeltSpellId, 2659, "Smelt Bronze spell 2659")

-- Steel: iron bar + coal, yield 1.
local steel = SD.Get(3859)
T.ok(steel.components, "steel uses the component shape")
T.eq(steel.numMade, 1, "steel yields 1 bar")
T.eq(steel.components[1].itemId, 3575, "steel component 1: Iron Bar")
T.eq(steel.components[2].itemId, 3857, "steel component 2: Coal")

-- Outland/Northrend 2:1 smelts.
T.eq(SD.Get(23445).oreItemId, 23424, "Fel Iron Bar from Fel Iron Ore")
T.eq(SD.Get(23445).orePerBar, 2, "2 fel iron ore per bar")
T.eq(SD.Get(23446).oreItemId, 23425, "Adamantite Bar from Adamantite Ore")
T.eq(SD.Get(36916).oreItemId, 36909, "Cobalt Bar from Cobalt Ore")
T.eq(SD.Get(36916).orePerBar, 1, "1 cobalt ore per bar")
T.eq(SD.Get(36913).oreItemId, 36912, "Saronite Bar from Saronite Ore")
T.eq(SD.Get(36913).orePerBar, 2, "2 saronite ore per bar")
T.eq(SD.Get(41163).oreItemId, 36910, "Titanium Bar from Titanium Ore")
T.eq(SD.Get(41163).orePerBar, 2, "2 titanium ore per bar")
T.eq(SD.Get(41163).smeltSpellId, 55211, "Smelt Titanium spell 55211")

-- Lookup misses: uncovered bars and unknown ids return nil.
T.eq(SD.Get(6037), nil, "Truesilver not covered (not in any path)")
T.eq(SD.Get(999999), nil, "unknown id -> nil")

-- Cross-check: every covered bar is a material somewhere in the registered
-- profession paths, or feeds another covered bar as a component (Tin Bar is
-- only consumed by the Bronze smelt, not by any path directly).
-- Count only the real professions: earlier test files in the shared manifest
-- register throwaway fixtures ("test", "mini", "batch") in the same registry.
local REAL = { engineering = true, tailoring = true, leatherworking = true,
    jewelcrafting = true, alchemy = true, blacksmithing = true,
    enchanting = true, inscription = true }
local used = {}
local profCount = 0
for key, prof in pairs(PP:GetProfessions()) do
    if REAL[key] then
        profCount = profCount + 1
        for _, step in ipairs(prof.steps) do
            for _, m in ipairs(step.materials) do
                used[m.itemId] = true
            end
        end
    end
end
T.eq(profCount, 8, "8 real professions registered for the cross-check")

for barId, e in pairs(SD) do
    if type(barId) == "number" then
        local ok = used[barId] or false
        if not ok then
            for otherId, other in pairs(SD) do
                if type(otherId) == "number" and other.components then
                    for _, c in ipairs(other.components) do
                        if c.itemId == barId and used[otherId] then
                            ok = true
                        end
                    end
                end
            end
        end
        T.ok(ok, "bar " .. barId
            .. " used in a profession path (directly or via component)")
    end
end
