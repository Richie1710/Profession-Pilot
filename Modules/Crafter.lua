-- ProfessionPilot Modules/Crafter.lua
-- Crafts the current step's recipe straight from the main window.
-- 3.3.5a: DoTradeSkill(index, count) is not protected, but it only works
-- while the trade skill window is open, so the button has two stages:
-- closed -> "open profession" (CastSpellByName from the click, a hardware
-- event), open -> "craft". No crafting ever happens without a click.

local PP = _G.ProfessionPilot
local Crafter = PP:NewModule("Crafter", "AceEvent-3.0")

local tradeSkillOpen = false
local craftOpen = false  -- Enchanting uses the old Craft API on 3.3.5a

function Crafter:OnEnable()
    self:RegisterEvent("TRADE_SKILL_SHOW")
    self:RegisterEvent("TRADE_SKILL_CLOSE")
    self:RegisterEvent("CRAFT_SHOW")
    self:RegisterEvent("CRAFT_CLOSE")
end

function Crafter:TRADE_SKILL_SHOW()
    tradeSkillOpen = true
    PP:Recompute()  -- craft button state depends on the open window
end

function Crafter:TRADE_SKILL_CLOSE()
    tradeSkillOpen = false
    PP:Recompute()
end

function Crafter:CRAFT_SHOW()
    craftOpen = true
    PP:Recompute()
end

function Crafter:CRAFT_CLOSE()
    craftOpen = false
    PP:Recompute()
end

-- -> "tradeskill" | "craft" | nil : which open window belongs to the
-- active profession.
local function activeProfessionOpen()
    local prof = PP:GetActiveProfession()
    if not prof then return nil end
    local profName = GetSpellInfo(prof.professionSpellId)
    if tradeSkillOpen and GetTradeSkillLine() == profName then
        return "tradeskill"
    end
    if craftOpen and GetCraftName and GetCraftName() == profName then
        return "craft"
    end
    return nil
end

local function findRecipe(mode, spellId)
    if mode == "craft" then
        for i = 1, GetNumCrafts() do
            local _, _, craftType, numAvailable = GetCraftInfo(i)
            if craftType ~= "header"
                and PP.util.SpellIdFromRecipeLink(GetCraftRecipeLink(i)) == spellId then
                return i, numAvailable or 0
            end
        end
        return nil, 0
    end
    for i = 1, GetNumTradeSkills() do
        local _, skillType, numAvailable = GetTradeSkillInfo(i)
        if skillType ~= "header"
            and PP.util.SpellIdFromRecipeLink(GetTradeSkillRecipeLink(i)) == spellId then
            return i, numAvailable or 0
        end
    end
    return nil, 0
end

-- Generic per-recipe state: "closed" | "ready"[, craftableCount].
-- "closed" also covers a recipe hidden by trade skill filters; reopening
-- the window refreshes and expands the list.
function Crafter:GetRecipeState(spellId)
    local mode = activeProfessionOpen()
    if not mode then return "closed" end
    local index, available = findRecipe(mode, spellId)
    if not index then return "closed" end
    return "ready", available
end

-- Main-window state: "hidden" | "unknown" | "closed" | "ready"[, count]
function Crafter:GetState()
    local snap = PP.snapshot
    if not snap or not snap.profession or not snap.currentIndex then
        return "hidden"
    end
    if not snap.steps[snap.currentIndex].flags.recipeKnown then
        return "unknown"
    end
    return self:GetRecipeState(snap.profession.steps[snap.currentIndex].recipeSpellId)
end

function Crafter:OpenProfession()
    if UnitAffectingCombat("player") then return end
    local prof = PP:GetActiveProfession()
    if not prof then return end
    local name = GetSpellInfo(prof.professionSpellId)
    if name then
        CastSpellByName(name)
    end
end

-- Craft any recipe of the active profession, capped by what the reagents
-- in bags allow. Craft-API professions (Enchanting) always craft one per
-- click: DoCraft has no repeat count, and enchants need a target anyway.
function Crafter:CraftRecipe(spellId, count)
    if UnitAffectingCombat("player") then return end
    local mode = activeProfessionOpen()
    if not mode then return end

    if mode == "tradeskill" then
        ExpandTradeSkillSubClass(0)
    end
    local index, available = findRecipe(mode, spellId)
    if not index or available == 0 then return end

    if mode == "craft" then
        PP:Debug("Crafter: DoCraft", index)
        DoCraft(index)
        return
    end

    local n = count or 1
    if n > available then n = available end
    if n > 0 then
        PP:Debug("Crafter: DoTradeSkill", index, "x" .. n)
        DoTradeSkill(index, n)
    end
end

-- count = number of combines; -1 crafts the step's remaining amount.
function Crafter:CraftCurrent(count)
    local snap = PP.snapshot
    if not snap or not snap.profession or not snap.currentIndex then return end
    local n = count or 1
    if n == -1 then
        n = snap.steps[snap.currentIndex].remainingCrafts
    end
    self:CraftRecipe(snap.profession.steps[snap.currentIndex].recipeSpellId, n)
end
