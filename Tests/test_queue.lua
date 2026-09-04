-- Tests for Core/Queue.lua: bottom-up craft queue built from the nested
-- material tree (post-order, duplicate merge, missing intermediates only).

local PP = _G.ProfessionPilot
local Queue = PP.Queue

local function node(itemId, need, have, craftedBy, crafts, children)
    return { itemId = itemId, need = need, have = have,
        missing = need - have, craftedBy = craftedBy, crafts = crafts,
        children = children }
end

-- Depth chain: grandchild intermediate before child before parent.
-- parent (spell 100) <- child (spell 200) <- grandchild (spell 300) <- base
local roots = {
    node(1, 10, 0, 100, 10, {
        node(2, 20, 0, 200, 20, {
            node(3, 40, 0, 300, 40, {
                node(4, 80, 0),            -- base material, skipped
            }),
        }),
        node(5, 10, 10),                   -- covered base, skipped
    }),
    node(6, 5, 0),                         -- base root, skipped
}
local q = Queue.BuildFromTree(roots)
T.eq(#q, 3, "chain: three intermediates queued")
T.eq(q[1].recipeSpellId, 300, "chain: grandchild first")
T.eq(q[1].crafts, 40, "chain: grandchild crafts")
T.eq(q[2].recipeSpellId, 200, "chain: child second")
T.eq(q[2].crafts, 20, "chain: child crafts")
T.eq(q[3].recipeSpellId, 100, "chain: parent last")
T.eq(q[3].crafts, 10, "chain: parent crafts")

-- Duplicate recipe in two subtrees: crafts summed into earliest position.
roots = {
    node(10, 4, 0, 500, 4, { node(11, 8, 0) }),
    node(12, 6, 0, 600, 6, {
        node(10, 12, 0, 500, 12, { node(11, 24, 0) }),
    }),
}
q = Queue.BuildFromTree(roots)
T.eq(#q, 2, "merge: two distinct recipes")
T.eq(q[1].recipeSpellId, 500, "merge: duplicate keeps earliest slot")
T.eq(q[1].crafts, 16, "merge: crafts summed (4 + 12)")
T.eq(q[2].recipeSpellId, 600, "merge: consumer still after dependency")
T.eq(q[2].crafts, 6, "merge: consumer crafts untouched")

-- Empty / nil tree -> empty queue.
T.eq(#Queue.BuildFromTree({}), 0, "empty tree -> empty queue")
T.eq(#Queue.BuildFromTree(nil), 0, "nil tree -> empty queue")

-- Tree with no missing intermediates: bases and covered intermediates
-- (craftedBy set but no crafts) never enter the queue.
roots = {
    node(20, 10, 4),
    node(21, 5, 5, 700, nil),
}
T.eq(#Queue.BuildFromTree(roots), 0, "no crafts anywhere -> empty queue")

-- NextCraftable: skips crafts == 0 and not-ready entries; pure callback.
local fixed = {
    { recipeSpellId = 1, crafts = 0 },
    { recipeSpellId = 2, crafts = 3 },
    { recipeSpellId = 3, crafts = 5 },
}
local e, idx = Queue.NextCraftable(fixed, function() return true end)
T.eq(e and e.recipeSpellId, 2, "next: zero-craft head skipped")
T.eq(idx, 2, "next: index of first workable entry")

e = Queue.NextCraftable(fixed, function(id) return id == 3 end)
T.eq(e and e.recipeSpellId, 3, "next: not-ready entries skipped")

e = Queue.NextCraftable(fixed, function() return false end)
T.eq(e, nil, "next: nothing ready -> nil")

T.eq(Queue.NextCraftable({}, function() return true end), nil,
    "next: empty queue -> nil")
