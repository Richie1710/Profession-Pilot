-- ProfessionPilot Core/Queue.lua
-- Pure craft-queue logic: turns the nested material tree of the current
-- step (Calc.BuildMaterialTree output) into a bottom-up work list of
-- combines. No WoW API calls, no state -- loadable headless under plain
-- Lua 5.1 (Tests/test_queue.lua).
--
-- The queue covers MISSING INTERMEDIATES only: every tree node that
-- carries `crafts` (a shortfall that has to be crafted first). The step's
-- own recipe is deliberately NOT part of the queue -- it is crafted via
-- the existing main-window craft button once the intermediates exist.

local PP = _G.ProfessionPilot
local Queue = {}
PP.Queue = Queue

-- roots: nested nodes { itemId, need, have, missing, craftedBy?, crafts?,
-- children? } as produced by Calc.BuildMaterialTree.
-- -> ordered array of { recipeSpellId, crafts }:
--   * post-order (children before parents), so every intermediate appears
--     after the intermediates it consumes,
--   * duplicates of the same recipe (same intermediate under two parents)
--     are merged: crafts summed into the EARLIEST position -- merging can
--     only move work earlier, never later, so children-before-parents
--     ordering is preserved,
--   * nodes without `crafts` (base materials, intermediates fully covered
--     by inventory) are skipped.
function Queue.BuildFromTree(roots)
    local queue, bySpell = {}, {}

    local function visit(nodes)
        for i = 1, #nodes do
            local n = nodes[i]
            if n.children then
                visit(n.children)
            end
            local spellId = n.craftedBy
            if spellId and n.crafts and n.crafts > 0 then
                local e = bySpell[spellId]
                if e then
                    e.crafts = e.crafts + n.crafts
                else
                    e = { recipeSpellId = spellId, crafts = n.crafts }
                    bySpell[spellId] = e
                    queue[#queue + 1] = e
                end
            end
        end
    end

    if roots then
        visit(roots)
    end
    return queue
end

-- First queue entry that still needs work AND is craftable right now.
-- -> entry, index (or nil). isReady(recipeSpellId) -> boolean is injected
-- so the runtime driver can back it with Crafter:GetRecipeState while the
-- headless tests use plain closures.
function Queue.NextCraftable(queue, isReady)
    for i = 1, #queue do
        local e = queue[i]
        if e.crafts and e.crafts > 0 and isReady(e.recipeSpellId) then
            return e, i
        end
    end
    return nil
end

return Queue
