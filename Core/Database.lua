-- ProfessionPilot Core/Database.lua
-- AceDB defaults. profile = account-wide UI settings, char = per-character
-- caches that mirror server state (recipes, bank) between sessions.

local PP = _G.ProfessionPilot

PP.defaults = {
    profile = {
        locked = false,
        scale = 1.0,
        minimap = { hide = false },   -- consumed by LibDBIcon
        onlyCurrent = false,
        autoExpandTree = true,
        showUpcoming = true,
        includeBank = true,
        showAlternatives = true,
        tooltips = true,
        showPrices = true,            -- remembered vendor prices or Auctioneer/Auctionator
        showRoster = true,            -- alt counts in shopping-list tooltips
        ldbText = true,               -- progress text on DataBroker displays
        debug = false,
        window = {},                  -- [frameName] = { point, x, y }
    },
    char = {
        knownRecipes = {},            -- [recipeSpellId] = true
        bankCounts = {},              -- [itemId] = count (cached bank contents)
        bankScanned = false,
        lastSkill = 0,
        activeProfession = nil,       -- persisted /pp prof choice
        stats = {},                   -- [recipeSpellId] = { crafts = n, ups = n }
    },
    global = {
        roster = {},                  -- ["Name - Realm"] = { counts = { [itemId] = n }, updated = time() }
        vendorPrices = {},            -- [itemId] = copper per unit, last seen at a vendor
    },
}
