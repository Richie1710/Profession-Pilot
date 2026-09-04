-- ProfessionPilot Modules/AltAdvisor.lua
-- Cost advisor runtime: feeds live auction prices and open-window reagent
-- data into the pure PP.Advisor logic (Core/Advisor.lua) and publishes
--   PP.advice = { alt = {...}|nil, buys = { [itemId] = {verdict, ...} } }
-- followed by a "PP_ADVICE" message after every PP_SNAPSHOT and window
-- update. Two advice kinds:
--   * alt  -- the CURRENT step's recipe vs. its data-declared alternatives
--            (step.alternatives), compared by live reagent cost PER CRAFT.
--            We have no static reagent data for alternatives, so their
--            reagent lists can only be read from the OPEN profession window
--            (TradeSkill API; Craft API for Enchanting on 3.3.5a).
--   * buys -- buy-vs-craft verdicts for craftable intermediates in the
--            current step's material tree (needs only a price source).
-- Everything bails out early without a window/price source; no OnUpdate,
-- no polling -- strictly event driven.

local PP = _G.ProfessionPilot
local AltAdvisor = PP:NewModule("AltAdvisor", "AceEvent-3.0")

local tradeSkillOpen = false
local craftOpen = false  -- Enchanting uses the old Craft API on 3.3.5a

function AltAdvisor:OnEnable()
    -- Own window tracking (same pattern as Modules/Crafter.lua): handler
    -- order across modules is undefined, so a PP_SNAPSHOT triggered by
    -- another module's SHOW handler may reach us before our SHOW event does.
    -- Updating again from our own handler makes the final state correct.
    self:RegisterEvent("TRADE_SKILL_SHOW", "WindowEvent")
    self:RegisterEvent("TRADE_SKILL_CLOSE", "WindowEvent")
    self:RegisterEvent("CRAFT_SHOW", "WindowEvent")
    self:RegisterEvent("CRAFT_CLOSE", "WindowEvent")
    self:RegisterEvent("TRADE_SKILL_UPDATE", "Update")
    self:RegisterEvent("CRAFT_UPDATE", "Update")
    self:RegisterMessage("PP_SNAPSHOT", "Update")
end

function AltAdvisor:WindowEvent(event)
    if event == "TRADE_SKILL_SHOW" then
        tradeSkillOpen = true
    elseif event == "TRADE_SKILL_CLOSE" then
        tradeSkillOpen = false
    elseif event == "CRAFT_SHOW" then
        craftOpen = true
    elseif event == "CRAFT_CLOSE" then
        craftOpen = false
    end
    self:Update()
end

-- The PP.Advisor/GetItemPrice/GetPriceSourceName existence checks are
-- deliberate: files newly added to the TOC only load after a full client
-- RESTART, while /reload re-runs existing files. Without the guard, a
-- /reload right after an update would error out here and kill the advice
-- pipeline (comment pattern from UI/MaterialList.lua priceEnabled).
local function priceReady()
    return PP.Advisor ~= nil
        and PP.GetItemPrice ~= nil
        and PP.GetPriceSourceName ~= nil
        and PP:GetPriceSourceName() ~= nil
end

-- Which open window belongs to the active profession ("tradeskill" |
-- "craft" | nil). Mirrors Modules/Crafter.lua; kept local so the modules
-- stay independent.
local function openMode(prof)
    local profName = GetSpellInfo(prof.professionSpellId)
    if not profName then return nil end
    if tradeSkillOpen and GetTradeSkillLine() == profName then
        return "tradeskill"
    end
    if craftOpen and GetCraftName and GetCraftName() == profName then
        return "craft"
    end
    return nil
end

-- Window index of a recipe by spell id, nil when not listed (also covers
-- recipes hidden by trade skill filters; RecipeTracker already expands
-- collapsed subclass headers on every TRADE_SKILL_UPDATE).
local function findRecipe(mode, spellId)
    if mode == "craft" then
        for i = 1, GetNumCrafts() do
            local _, _, craftType = GetCraftInfo(i)
            if craftType ~= "header"
                and PP.util.SpellIdFromRecipeLink(GetCraftRecipeLink(i)) == spellId then
                return i
            end
        end
        return nil
    end
    for i = 1, GetNumTradeSkills() do
        local _, skillType = GetTradeSkillInfo(i)
        if skillType ~= "header"
            and PP.util.SpellIdFromRecipeLink(GetTradeSkillRecipeLink(i)) == spellId then
            return i
        end
    end
    return nil
end

-- Live reagent cost of one craft, in copper: sum of reagentCount * unit
-- price. nil when any reagent has no price or the reagent list is empty
-- (partial sums would look cheaper than they are).
local function reagentCost(mode, index)
    local numReagents
    if mode == "craft" then
        numReagents = GetCraftNumReagents(index)
    else
        numReagents = GetTradeSkillNumReagents(index)
    end
    if not numReagents or numReagents == 0 then return nil end

    local total = 0
    for r = 1, numReagents do
        local count, link
        if mode == "craft" then
            local _, _, c = GetCraftReagentInfo(index, r)
            count = c
            link = GetCraftReagentItemLink(index, r)
        else
            local _, _, c = GetTradeSkillReagentInfo(index, r)
            count = c
            link = GetTradeSkillReagentItemLink(index, r)
        end
        local itemId = PP.util.ItemIdFromLink(link)
        local unit = itemId and PP:GetItemPrice(itemId)
        if not unit then return nil end
        total = total + (count or 1) * unit
    end
    return total
end

-- alt advice for the current step, or nil. Costs are per craft on both
-- sides -- main and alternative fill the same skill window, so per-craft
-- is the fair comparison (saving is copper per craft, too).
local function compareAlternatives(mode, step)
    local mainIndex = findRecipe(mode, step.recipeSpellId)
    if not mainIndex then return nil end
    local mainCost = reagentCost(mode, mainIndex)
    if not mainCost then return nil end

    local altCosts = {}
    for i = 1, #step.alternatives do
        local alt = step.alternatives[i]
        local idx = findRecipe(mode, alt.recipeSpellId)
        local cost = idx and reagentCost(mode, idx)
        if cost then
            altCosts[#altCosts + 1] = { spellId = alt.recipeSpellId, cost = cost }
        end
    end

    local best = PP.Advisor.CompareCosts(mainCost, altCosts)
    if not best then return nil end

    -- Display extras for the UI hint line.
    best.mainCost = mainCost
    best.mainSpellId = step.recipeSpellId
    for i = 1, #step.alternatives do
        if step.alternatives[i].recipeSpellId == best.spellId then
            best.condKey = step.alternatives[i].condKey
            break
        end
    end
    return best
end

local function priceFn(itemId)
    return PP:GetItemPrice(itemId)
end

function AltAdvisor:Update()
    local advice = { alt = nil, buys = {} }
    local snap = PP.snapshot
    local prof = snap and snap.profession

    if prof and snap.currentIndex and PP.db and priceReady() then
        local profile = PP.db.profile
        local step = prof.steps[snap.currentIndex]

        -- (a) recipe alternatives: only for the current step, only when the
        -- matching profession window is open (sole source of alt reagents).
        if step.alternatives and profile.showAlternatives then
            local mode = openMode(prof)
            if mode then
                advice.alt = compareAlternatives(mode, step)
            end
        end

        -- (b) buy-vs-craft for the current step's craftable intermediates
        -- (nested ones included -- WalkTree is pre-order over all levels).
        if profile.showPrices and snap.tree then
            PP.Calc.WalkTree(snap.tree, function(n)
                if n.crafts then
                    local res = PP.Advisor.BuyVsCraft(n, priceFn)
                    if res then advice.buys[n.itemId] = res end
                end
            end)
        end
    end

    PP.advice = advice
    if advice.alt then
        PP:Debug("AltAdvisor: alt", advice.alt.spellId,
            "saves", advice.alt.saving, "per craft")
    end
    PP:SendMessage("PP_ADVICE")
end
