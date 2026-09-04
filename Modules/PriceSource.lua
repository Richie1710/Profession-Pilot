-- ProfessionPilot Modules/PriceSource.lua
-- Optional auction price integration. Detects an installed price provider at
-- enable time (both load before PLAYER_LOGIN, when AceAddon enables modules):
--   * Auctioneer (Auc-Advanced): AucAdvanced.API.GetMarketValue("item:id")
--     -- statistical market value, preferred when both are installed,
--   * Auctionator: Atr_GetAuctionBuyout(itemId) -- most recent scan/buyout.
-- Both verified against the versions installed alongside this addon.
-- Without a provider every price query returns nil and the UI hides prices.

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

function PP:GetPriceSourceName()
    if not source then source = detect() end
    return source and source.name or nil
end

-- Unit price in copper, or nil when no provider/no data. pcall guards against
-- third-party errors so a broken auction addon can never break our render.
function PP:GetItemPrice(itemId)
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
