-- ProfessionPilot test stubs: minimal WoW/Ace environment for headless Lua 5.1.
-- Only what the pure modules (Core/Calc, Core/ProfessionRegistry, Professions/*)
-- touch at file scope or inside tested functions.

local L = setmetatable({}, { __index = function(_, key) return key end })

_G.ProfessionPilot = {
    L = L,
    Debug = function() end,
}

-- 3.3.5a: GetSpellInfo reads client DBCs and works for any valid spell id.
function _G.GetSpellInfo(spellId)
    return "spell:" .. tostring(spellId), nil, "Interface\\Icons\\INV_Misc_Wrench_01"
end

function _G.GetItemInfo(itemId)
    return "item:" .. tostring(itemId)
end
