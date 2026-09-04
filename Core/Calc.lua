-- ProfessionPilot Core/Calc.lua
-- Pure computation: step status, current step, remaining crafts, material needs
-- and aggregation with crafting-chain resolution. No WoW API calls, no UI,
-- no saved state -- everything comes in through explicit arguments, which keeps
-- this file testable under plain Lua 5.1 (Tests/run_tests.lua).

local PP = _G.ProfessionPilot
local Calc = {}
PP.Calc = Calc

local ceil = math.ceil
local max = math.max

-- Pure string helpers shared by the tracker modules (kept here so the
-- headless test suite covers them without stubbing Ace module plumbing).
local util = {}
PP.util = util

-- 3.3.5a: GetTradeSkillRecipeLink returns "|Henchant:<spellId>|h...".
function util.SpellIdFromRecipeLink(link)
    if type(link) ~= "string" then return nil end
    local id = link:match("|Henchant:(%d+)")
    return id and tonumber(id) or nil
end

function util.ItemIdFromLink(link)
    if type(link) ~= "string" then return nil end
    local id = link:match("|Hitem:(%d+)")
    return id and tonumber(id) or nil
end

-- Copper -> "12g 34s 56c" (zero units omitted, "0c" for zero, nil for nil).
function util.FormatMoney(copper)
    if type(copper) ~= "number" then return nil end
    copper = math.floor(copper + 0.5)
    if copper <= 0 then return "0c" end

    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local c = copper % 100

    local parts = {}
    if gold > 0 then parts[#parts + 1] = gold .. "g" end
    if silver > 0 then parts[#parts + 1] = silver .. "s" end
    if c > 0 then parts[#parts + 1] = c .. "c" end
    return table.concat(parts, " ")
end

-- ctx shape used throughout:
--   skill       current profession skill (0 = not learned)
--   cap         current trainable maximum (maxRank from GetSkillLineInfo)
--   known       set of known recipe spell ids { [spellId] = true }
--   counts      inventory { [itemId] = { bags = n, bank = n } }
--   includeBank whether bank counts contribute to "have"
--   maxSkill    profession cap (default 450)

local function have(ctx, itemId)
    local c = ctx.counts and ctx.counts[itemId]
    if not c then return 0 end
    local n = c.bags or 0
    if ctx.includeBank then n = n + (c.bank or 0) end
    return n
end
Calc.GetHave = have

-- First step the player has not finished yet. Parallel steps share a skill
-- window; data order defines their priority.
function Calc.GetCurrentStepIndex(steps, skill)
    for i = 1, #steps do
        if steps[i].maxSkill > skill then
            return i
        end
    end
    return nil
end

-- Crafts still needed to finish the step from the given skill, prorated
-- linearly across the step's skill window.
-- Approximation note: parallel steps sharing one window are each prorated by
-- the same fraction, which overestimates the per-step remainder mid-window
-- (the skill points came from *both* recipes). Totals stay consistent because
-- shortfalls expand via AggregateMaterials; treat mid-window counts in
-- parallel sections as upper bounds.
function Calc.GetRemainingCrafts(step, skill)
    if skill >= step.maxSkill then return 0 end
    local from = max(skill, step.minSkill)
    local span = step.maxSkill - step.minSkill
    return ceil(step.estimatedCrafts * (step.maxSkill - from) / span)
end

-- Remaining material amounts for a step. Registry validation guarantees
-- amount/estimatedCrafts is integral.
function Calc.GetStepMaterialNeeds(step, skill)
    local remaining = Calc.GetRemainingCrafts(step, skill)
    local needs = {}
    if remaining == 0 then return needs end
    for i = 1, #step.materials do
        local m = step.materials[i]
        needs[#needs + 1] = {
            itemId = m.itemId,
            need = remaining * (m.amount / step.estimatedCrafts),
            craftedBy = m.craftedBy,
        }
    end
    return needs
end

-- Status is purely about skill progression; "current" is assigned by the
-- caller via GetCurrentStepIndex. Flags carry everything the UI needs to
-- explain why a step is not craftable right now.
function Calc.GetStepStatus(step, ctx)
    local status = (ctx.skill >= step.maxSkill) and "completed" or "upcoming"

    local profMax = ctx.maxSkill or 450
    local flags = {
        recipeKnown = not not (ctx.known and ctx.known[step.recipeSpellId]),
        recipeLearnable = step.learnAtSkill <= ctx.skill,
        rankBlocked = step.minSkill >= (ctx.cap or 0) and (ctx.cap or 0) < profMax,
        matsMissing = false,
    }

    if status ~= "completed" then
        local needs = Calc.GetStepMaterialNeeds(step, ctx.skill)
        for i = 1, #needs do
            if needs[i].need > have(ctx, needs[i].itemId) then
                flags.matsMissing = true
                break
            end
        end
    end

    return status, flags
end

-- Pre-order walk over nested material nodes (node = {..., children?}).
function Calc.WalkTree(nodes, fn)
    for i = 1, #nodes do
        local n = nodes[i]
        fn(n)
        if n.children then
            Calc.WalkTree(n.children, fn)
        end
    end
end

-- Nested breakdown of a step's remaining materials into craftable
-- intermediates and base resources:
--   { {itemId, need, have, missing, craftedBy?, crafts?, children?}, ... }
-- Children are scaled to the MISSING portion of their parent (what still has
-- to be crafted). Inventory is consumed through a pool in traversal order so
-- a base material shared by two intermediates is never counted available
-- twice. `crafts` is the number of combines needed (respects numMade).
function Calc.BuildMaterialTree(profession, step, ctx)
    local pool = {}

    local function poolGet(itemId)
        local v = pool[itemId]
        if v == nil then
            local c = ctx.counts and ctx.counts[itemId]
            v = 0
            if c then
                v = c.bags or 0
                if ctx.includeBank then v = v + (c.bank or 0) end
            end
            pool[itemId] = v
        end
        return v
    end

    local MAX_DEPTH = 8

    local function addNode(list, itemId, amount, craftedBy, depth, visited)
        local avail = poolGet(itemId)
        local used = amount < avail and amount or avail
        pool[itemId] = avail - used
        local missing = amount - used

        local node = { itemId = itemId, need = amount, have = used,
            missing = missing, craftedBy = craftedBy }
        list[#list + 1] = node

        local producer = craftedBy and profession.producers[craftedBy]
        if producer and missing > 0 and depth < MAX_DEPTH
            and not visited[craftedBy] then
            visited[craftedBy] = true
            local numMade = producer.numMade or 1
            local crafts = ceil(missing / numMade)
            node.crafts = crafts
            node.children = {}
            for i = 1, #producer.materials do
                local pm = producer.materials[i]
                addNode(node.children, pm.itemId,
                    crafts * (pm.amount / producer.estimatedCrafts),
                    pm.craftedBy, depth + 1, visited)
            end
            visited[craftedBy] = nil
        end
    end

    local roots = {}
    local needs = Calc.GetStepMaterialNeeds(step, ctx.skill)
    for i = 1, #needs do
        addNode(roots, needs[i].itemId, needs[i].need, needs[i].craftedBy, 0, {})
    end
    return roots
end

-- Total material demand from the player's current skill up to opts.toSkill
-- (default: profession cap), walking steps in craft order:
--   * leveling steps project their output into a virtual pool, so
--     intermediates covered by the leveling path never double-count,
--   * real inventory (bags [+bank]) is consumed once per item,
--   * remaining shortfalls of craftable intermediates expand recursively
--     into extra crafts (result.crafts) and their base materials, which are
--     attached as CHILDREN of the intermediate node (drill-down view) --
--     top-level nodes carry only the direct step demand,
--   * ceil() overshoot from multi-output recipes (numMade > 1) is credited
--     back to the pool for later consumers.
-- Returns { entries = { {itemId, need, have, missing, craftedBy?, crafts?,
--           children?} ... } in first-use order (children likewise),
--           crafts = { [recipeSpellId] = extraCrafts } }.
-- `have` is the amount actually covered by pool/inventory for that node.
function Calc.AggregateMaterials(profession, ctx, opts)
    opts = opts or {}
    local toSkill = opts.toSkill or profession.maxSkill or 450
    local skill = ctx.skill

    local top, topByItem = {}, {}
    local pool = {}          -- consumable: inventory + projected production
    local craftsExtra = {}

    local function poolGet(itemId)
        local v = pool[itemId]
        if v == nil then
            local c = ctx.counts and ctx.counts[itemId]
            v = 0
            if c then
                v = c.bags or 0
                if ctx.includeBank then v = v + (c.bank or 0) end
            end
            pool[itemId] = v
        end
        return v
    end

    -- Nodes aggregate per item within their level (top level or one
    -- intermediate's child list).
    local function nodeFor(list, byItem, itemId, craftedBy)
        local e = byItem[itemId]
        if not e then
            e = { itemId = itemId, need = 0, have = 0, missing = 0,
                  craftedBy = craftedBy }
            byItem[itemId] = e
            list[#list + 1] = e
        elseif craftedBy and not e.craftedBy then
            e.craftedBy = craftedBy
        end
        return e
    end

    local MAX_CHAIN_DEPTH = 10  -- data is a DAG; guard against future mistakes

    local requireAmount
    requireAmount = function(list, byItem, itemId, amount, craftedBy, depth)
        if amount <= 0 then return end
        local e = nodeFor(list, byItem, itemId, craftedBy)
        e.need = e.need + amount

        local avail = poolGet(itemId)
        local used = amount < avail and amount or avail
        pool[itemId] = avail - used
        e.have = e.have + used
        local shortfall = amount - used
        if shortfall == 0 then return end

        e.missing = e.missing + shortfall

        local producer = craftedBy and profession.producers[craftedBy]
        if not producer or depth >= MAX_CHAIN_DEPTH then return end

        local numMade = producer.numMade or 1
        local crafts = ceil(shortfall / numMade)
        craftsExtra[producer.recipeSpellId] =
            (craftsExtra[producer.recipeSpellId] or 0) + crafts
        e.crafts = (e.crafts or 0) + crafts

        local leftover = crafts * numMade - shortfall
        if leftover > 0 then
            pool[itemId] = pool[itemId] + leftover
        end

        if not e.children then
            e.children = {}
            e.childByItem = {}
        end
        for i = 1, #producer.materials do
            local pm = producer.materials[i]
            requireAmount(e.children, e.childByItem, pm.itemId,
                crafts * (pm.amount / producer.estimatedCrafts),
                pm.craftedBy, depth + 1)
        end
    end

    for i = 1, #profession.steps do
        local step = profession.steps[i]
        if step.maxSkill > skill and step.minSkill < toSkill then
            local needs = Calc.GetStepMaterialNeeds(step, skill)
            for j = 1, #needs do
                requireAmount(top, topByItem, needs[j].itemId, needs[j].need,
                    needs[j].craftedBy, 0)
            end
            if step.craftedItemId then
                local made = Calc.GetRemainingCrafts(step, skill)
                    * (step.numMade or 1)
                pool[step.craftedItemId] = poolGet(step.craftedItemId) + made
            end
        end
    end

    -- Drop the internal lookup tables before the result leaves Calc.
    Calc.WalkTree(top, function(n) n.childByItem = nil end)

    return { entries = top, crafts = craftsExtra }
end

return Calc
