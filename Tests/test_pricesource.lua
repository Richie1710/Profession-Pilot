-- PriceSource: gemerkte Haendlerpreise vor Auktionspreisen, Quellenname.
-- Modul headless geladen (NewModule-Stub wie in test_recipetracker.lua).

local root = ((arg and arg[0] or ""):match("^(.*)[/\\]") or ".") .. "/.."
local PP = _G.ProfessionPilot

-- PriceSource haengt seine Funktionen direkt an PP -- nach dem Test
-- wieder entfernen, alle Tests teilen sich einen Lua-Zustand.
local saved = {
    NewModule = rawget(PP, "NewModule"),
    db = rawget(PP, "db"),
    GetItemPrice = rawget(PP, "GetItemPrice"),
    GetPriceSourceName = rawget(PP, "GetPriceSourceName"),
    GetVendorPrice = rawget(PP, "GetVendorPrice"),
    GetTime = _G.GetTime,
    AucAdvanced = _G.AucAdvanced,
    Atr_GetAuctionBuyout = _G.Atr_GetAuctionBuyout,
}

function PP:NewModule() return {} end
_G.GetTime = function() return 0 end
_G.AucAdvanced = nil
_G.Atr_GetAuctionBuyout = nil
PP.db = { global = { vendorPrices = {} } }

assert(loadfile(root .. "/Modules/PriceSource.lua"))()

T.eq(PP:GetPriceSourceName(), nil, "ohne Quelle: kein Name")
T.eq(PP:GetItemPrice(1), nil, "ohne Quelle: kein Preis")
T.eq(PP:GetVendorPrice(1), nil, "ohne Haendlerbesuch: kein Haendlerpreis")

PP.db.global.vendorPrices[1] = 500
T.eq(PP:GetPriceSourceName(), "PRICE_SRC_VENDOR", "nur Haendler: Name Haendler")
T.eq(PP:GetVendorPrice(1), 500, "GetVendorPrice liefert den Stueckpreis")
T.eq(PP:GetItemPrice(1), 500, "nur Haendler: Haendlerpreis")
T.eq(PP:GetItemPrice(2), nil, "nur Haendler: fremdes Item ohne Preis")

_G.Atr_GetAuctionBuyout = function(id) return id == 1 and 9999 or 700 end
T.eq(PP:GetPriceSourceName(), "PRICE_SRC_VENDOR + Auctionator",
    "beides: kombinierter Name")
T.eq(PP:GetItemPrice(1), 500, "beides: Haendlerpreis schlaegt AH")
T.eq(PP:GetItemPrice(2), 700, "beides: AH fuer den Rest")

PP.db.global.vendorPrices = {}
T.eq(PP:GetPriceSourceName(), "Auctionator", "nur AH: Name wie bisher")

-- Vor OnInitialize gibt es noch keine DB.
PP.db = nil
T.eq(PP:GetVendorPrice(1), nil, "ohne DB: kein Haendlerpreis, kein Fehler")

for k in pairs({ NewModule = 1, db = 1, GetItemPrice = 1,
                 GetPriceSourceName = 1, GetVendorPrice = 1 }) do
    PP[k] = saved[k]
end
_G.GetTime = saved.GetTime
_G.AucAdvanced = saved.AucAdvanced
_G.Atr_GetAuctionBuyout = saved.Atr_GetAuctionBuyout
