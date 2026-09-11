-- ProfessionPilot Modules/PriceSource.lua
-- Optional auction price integration. Detects an installed price provider at
-- enable time (both load before PLAYER_LOGIN, when AceAddon enables modules):
--   * Auctioneer (Auc-Advanced): AucAdvanced.API.GetMarketValue("item:id")
--     -- statistical market value, preferred when both are installed,
--   * Auctionator: Atr_GetAuctionBuyout(itemId) -- most recent scan/buyout.
-- Both verified against the versions installed alongside this addon.
-- Vendor prices remembered by Modules/MerchantBuyer.lua (db.global.
-- vendorPrices, copper per unit) take precedence: a vendor is the real price.
-- Without a provider and without remembered vendor prices every price query
-- returns nil and the UI hides prices.

local PP = _G.ProfessionPilot
local PriceSource = PP:NewModule("PriceSource")

local source          -- { name = string, get = function(itemId) -> copper|nil }
local cache = {}      -- [itemId] = { v = copper|nil, t = GetTime() }
local CACHE_TTL = 300 -- auction data changes at scan granularity; 5 min is fine

local function detect()
    local aucApi = _G.AucAdvanced and _G.AucAdvanced.API
    if aucApi and aucApi.GetMarketValue then
        return {
            name = "Auctioneer",
            get = function(itemId)
                return aucApi.GetMarketValue("item:" .. itemId)
            end,
        }
    end
    if _G.Atr_GetAuctionBuyout then
        return {
            name = "Auctionator",
            get = function(itemId)
                return _G.Atr_GetAuctionBuyout(itemId)
            end,
        }
    end
    return nil
end

function PriceSource:OnEnable()
    source = detect()
    PP:Debug("PriceSource:", source and source.name or "none")
end

-- Remembered vendor unit price in copper, or nil (item never seen at a
-- vendor, or no DB yet before OnInitialize).
function PP:GetVendorPrice(itemId)
    local prices = self.db and self.db.global.vendorPrices
    return prices and prices[itemId] or nil
end

local function hasVendorPrices()
    local prices = PP.db and PP.db.global.vendorPrices
    return prices ~= nil and next(prices) ~= nil
end

-- Display name of the active price sources: "Auctioneer", "Vendor" or
-- "Vendor + Auctioneer"; nil when there is nothing to price with.
function PP:GetPriceSourceName()
    if not source then source = detect() end
    local vendor = hasVendorPrices() and self.L["PRICE_SRC_VENDOR"] or nil
    if vendor and source then return vendor .. " + " .. source.name end
    return vendor or (source and source.name) or nil
end

-- Unit price in copper, or nil when no provider/no data. pcall guards against
-- third-party errors so a broken auction addon can never break our render.
function PP:GetItemPrice(itemId)
    local vendor = self:GetVendorPrice(itemId)
    if vendor then return vendor end

    if not source then
        source = detect()
        if not source then return nil end
    end

    local now = GetTime()
    local hit = cache[itemId]
    if hit and now - hit.t < CACHE_TTL then return hit.v end

    local ok, value = pcall(source.get, itemId)
    if not ok or type(value) ~= "number" or value <= 0 then
        value = nil
    end
    cache[itemId] = { v = value, t = now }
    return value
end
