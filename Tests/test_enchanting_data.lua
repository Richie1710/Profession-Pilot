-- Integrity and aggregation tests for Professions/Enchanting.lua.

local PP = _G.ProfessionPilot
local Calc = PP.Calc
local prof = PP:GetProfession("enchanting")

T.ok(prof, "enchanting profession registered")
if not prof then return end

local steps = prof.steps

T.eq(#steps, 44, "44 steps")
T.eq(prof.professionSpellId, 7411, "profession spell id (rank 1)")

-- Every skill point 1..449 lies inside at least one step window.
local uncovered = 0
for s = 1, 449 do
    local covered = false
    for i = 1, #steps do
        if steps[i].minSkill <= s and s < steps[i].maxSkill then
            covered = true
            break
        end
    end
    if not covered then uncovered = uncovered + 1 end
end
T.eq(uncovered, 0, "no skill gaps between 1 and 449")
T.eq(steps[1].minSkill, 1, "path starts at 1")
T.eq(steps[#steps].maxSkill, 450, "path ends at 450")

-- Anchor checks (AtlasLoot 3.3.5a). Four recipes cover two windows each
-- (7418, 13661, 60616, 44489); bySpell keeps the LATER window for those.
local bySpell = {}
for i = 1, #steps do bySpell[steps[i].recipeSpellId] = steps[i] end

T.eq(bySpell[7421].craftedItemId, 6218, "Runed Copper Rod item id")
T.eq(bySpell[14807].craftedItemId, 11288, "Greater Magic Wand item id")
T.eq(bySpell[25127].craftedItemId, 20747,
    "Lesser Mana Oil item id (AtlasLoot; absent from the guide dump)")
T.eq(bySpell[60619].craftedItemId, 44452,
    "Runed Titanium Rod item id (AtlasLoot; absent from the guide dump)")
T.eq(bySpell[7418].craftedItemId, nil, "enchant steps craft no item")

-- Enchants vs item crafts; rod steps are single-craft kept tools.
local enchantSteps, itemSteps, rodSteps = 0, 0, 0
for i = 1, #steps do
    if steps[i].craftedItemId then
        itemSteps = itemSteps + 1
    else
        enchantSteps = enchantSteps + 1
    end
    if steps[i].notesKey == "NOTE_TOOL" then
        rodSteps = rodSteps + 1
        T.eq(steps[i].saveForLater, true, "rod step " .. i .. " saved for later")
        T.eq(steps[i].estimatedCrafts, 1, "rod step " .. i .. " single craft")
        T.ok(steps[i].craftedItemId, "rod step " .. i .. " crafts an item")
    end
end
T.eq(enchantSteps, 32, "32 enchant-only steps (no craftedItemId)")
T.eq(itemSteps, 12, "12 item steps (9 rods, wand, two oils)")
T.eq(rodSteps, 9, "9 runed rod tool steps")

-- Rod chain: every rod after the first consumes its predecessor.
local rodChain = {
    { 7795, 6218, 7421 },      -- Silver <- Copper
    { 13628, 6339, 7795 },     -- Golden <- Silver
    { 13702, 11130, 13628 },   -- Truesilver <- Golden
    { 20051, 11145, 13702 },   -- Arcanite <- Truesilver
    { 32664, 16207, 20051 },   -- Fel Iron <- Arcanite
    { 32665, 22461, 32664 },   -- Adamantite <- Fel Iron
    { 32667, 22462, 32665 },   -- Eternium <- Adamantite
    { 60619, 22463, 32667 },   -- Titanium <- Eternium
}
for _, c in ipairs(rodChain) do
    local found = false
    for _, m in ipairs(bySpell[c[1]].materials) do
        if m.itemId == c[2] and m.craftedBy == c[3] then found = true end
    end
    T.ok(found, ("rod %d consumes rod item %d via %d"):format(c[1], c[2], c[3]))
end

-- Reconciled steps (see the data file header).
T.eq(bySpell[34002].materials[1].amount, 54,
    "Bracer Assault: 54 arcane dust total (guide row prints the per-craft 6)")
T.eq(steps[39].recipeSpellId, 44489, "step 39 is the first Shield Defense window")
T.eq(steps[39].estimatedCrafts, 5,
    "Shield Defense 420-425: 5 crafts (guide's 4 conflicts with its own 30/30 mats)")
T.eq(steps[39].materials[1].amount / 5, 6, "Shield Defense: 6 infinite dust per craft")
T.eq(steps[39].materials[2].amount / 5, 6, "Shield Defense: 6 eternal earth per craft")
T.eq(steps[41].recipeSpellId, 44489, "step 41 is the second Shield Defense window")
T.eq(steps[41].estimatedCrafts, 4, "Shield Defense 426-430: 4 crafts (24/24)")

-- Vendor formulas.
T.eq(bySpell[13419].source, "vendor", "Cloak Minor Agility is a vendor formula")
T.eq(bySpell[13419].sourceItemId, 11039, "Cloak Minor Agility formula item")
T.eq(bySpell[20051].source, "vendor", "Runed Arcanite Rod formula (Moonglade)")
T.eq(bySpell[20051].sourceItemId, 16243, "Runed Arcanite Rod formula item")
T.eq(bySpell[60763].vendorNoteKey, "NOTE_VENDOR_DALARAN",
    "Boots Greater Assault formula sold in Dalaran (AtlasLoot confirms)")
local vendorCount = 0
for i = 1, #steps do
    if steps[i].source == "vendor" then vendorCount = vendorCount + 1 end
end
T.eq(vendorCount, 10, "ten vendor formulas along the path")

-- Raw totals across steps (per-step guide data; list deviations documented).
local totals = {}
for i = 1, #steps do
    for _, m in ipairs(steps[i].materials) do
        if not m.craftedBy then
            totals[m.itemId] = (totals[m.itemId] or 0) + m.amount
        end
    end
end
T.eq(totals[10940], 125, "strange dust 125 (matches the guide list)")
T.eq(totals[11083], 122, "soul dust 122 (guide list wrongly says 130)")
T.eq(totals[11137], 237, "vision dust 237 (guide list wrongly says 240)")
T.eq(totals[22445], 344, "arcane dust 344 (guide list says 350)")
T.eq(totals[34054], 742, "infinite dust 742 (matches the guide list)")
T.eq(totals[34052], 48, "dream shards 48 consumed (list's 60 adds 12 formula cost)")
T.eq(totals[18256], 15, "imbued vials 15 (missing from the guide list entirely)")
T.eq(totals[35624], 134, "eternal earth 134 (matches the guide list)")
T.eq(totals[34055], 47, "greater cosmic essence 47 (matches the guide list)")

-- Aggregation ---------------------------------------------------------------
local function ctxOf(skill)
    return { skill = skill, cap = 450, known = {}, counts = {}, maxSkill = 450 }
end
local function entryFor(result, itemId)
    for _, e in ipairs(result.entries) do
        if e.itemId == itemId then return e end
    end
    return nil
end
local function treeSum(result, itemId, field)
    local total = 0
    Calc.WalkTree(result.entries, function(n)
        if n.itemId == itemId then total = total + n[field] end
    end)
    return total
end

-- Full path: every rod is produced by its own step before the next rod
-- needs it, so nothing expands and no runed rod hits the shopping list.
local r = Calc.AggregateMaterials(prof, ctxOf(1))
T.eq(next(r.crafts), nil, "full path: no shortfall crafts anywhere")
T.eq(entryFor(r, 6218).need, 1, "runed copper rod needed once (silver rod)")
T.eq(entryFor(r, 6218).missing, 0, "runed copper rod covered by its own step")
T.eq(treeSum(r, 10940, "need"), 125, "strange dust 125 aggregated flat")
T.eq(treeSum(r, 34054, "need"), 742, "infinite dust 742 aggregated flat")

-- 425: the eternium rod step is long completed, so the titanium rod's tool
-- requirement expands through the whole rod chain down to the copper rod.
r = Calc.AggregateMaterials(prof, ctxOf(425))
T.eq(r.crafts[32667], 1, "425: one runed eternium rod to rebuild")
T.eq(r.crafts[20051], 1, "425: chain rebuilds the runed arcanite rod")
T.eq(r.crafts[7421], 1, "425: chain reaches back to the runed copper rod")
T.eq(treeSum(r, 10940, "need"), 7,
    "425: 7 strange dust via rod chain (6 silver + 1 copper)")
T.eq(treeSum(r, 34054, "need"), 139,
    "425: 40+24+75 infinite dust from steps, the rod chain adds none")

-- 449: one Boots Greater Assault left.
r = Calc.AggregateMaterials(prof, ctxOf(449))
T.eq(entryFor(r, 34055).need, 4, "4 greater cosmic essence at 449")
T.eq(entryFor(r, 34052).need, 4, "4 dream shards at 449")
T.eq(Calc.GetCurrentStepIndex(steps, 450), nil, "450 -> done")
