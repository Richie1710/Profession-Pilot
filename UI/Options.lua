-- ProfessionPilot UI/Options.lua
-- AceConfig options registered into the Blizzard interface options panel.

local PP = _G.ProfessionPilot
local L = PP.L

local Options = PP:NewModule("Options")
PP.UI.Options = Options

local function get(info)
    return PP.db.profile[info[#info]]
end

-- Setters split by effect: visual-only settings re-render, data-affecting
-- settings recompute the snapshot first.
local function setVisual(info, value)
    PP.db.profile[info[#info]] = value
    PP:SendMessage("PP_SETTINGS_CHANGED")
end

local function setData(info, value)
    PP.db.profile[info[#info]] = value
    PP:Recompute()
end

local function buildOptions()
    return {
        type = "group",
        name = "ProfessionPilot",
        args = {
            general = {
                type = "group", inline = true, order = 1,
                name = L["OPT_GENERAL"],
                args = {
                    locked = {
                        type = "toggle", order = 1,
                        name = L["OPT_LOCK"], desc = L["OPT_LOCK_DESC"],
                        get = get, set = setVisual,
                    },
                    scale = {
                        type = "range", order = 2,
                        name = L["OPT_SCALE"],
                        min = 0.6, max = 1.5, step = 0.05,
                        get = get, set = setVisual,
                    },
                    minimapShown = {
                        type = "toggle", order = 3,
                        name = L["OPT_MINIMAP"],
                        get = function() return not PP.db.profile.minimap.hide end,
                        set = function(_, value)
                            PP.db.profile.minimap.hide = not value
                            PP.UI.MinimapButton:ApplySettings()
                        end,
                    },
                    tooltips = {
                        type = "toggle", order = 4,
                        name = L["OPT_TOOLTIPS"],
                        get = get, set = setVisual,
                    },
                    onlyCurrent = {
                        type = "toggle", order = 5,
                        name = L["OPT_ONLY_CURRENT"],
                        desc = L["OPT_ONLY_CURRENT_DESC"],
                        get = get, set = setVisual,
                    },
                    autoExpandTree = {
                        type = "toggle", order = 6,
                        name = L["OPT_AUTO_EXPAND"],
                        desc = L["OPT_AUTO_EXPAND_DESC"],
                        get = get, set = setVisual,
                    },
                    showUpcoming = {
                        type = "toggle", order = 7,
                        name = L["OPT_SHOW_UPCOMING"],
                        desc = L["OPT_SHOW_UPCOMING_DESC"],
                        get = get, set = setData,
                    },
                    includeBank = {
                        type = "toggle", order = 8,
                        name = L["OPT_INCLUDE_BANK"],
                        desc = L["OPT_INCLUDE_BANK_DESC"],
                        get = get, set = setData,
                    },
                    showAlternatives = {
                        type = "toggle", order = 9,
                        name = L["OPT_ALTERNATIVES"],
                        get = get, set = setVisual,
                    },
                    showPrices = {
                        type = "toggle", order = 10,
                        name = L["OPT_SHOW_PRICES"],
                        desc = L["OPT_SHOW_PRICES_DESC"],
                        disabled = function() return PP:GetPriceSourceName() == nil end,
                        get = get, set = setVisual,
                    },
                    merchantBar = {
                        type = "toggle", order = 11,
                        name = L["OPT_MERCHANT_BAR"],
                        desc = L["OPT_MERCHANT_BAR_DESC"],
                        get = get, set = setVisual,
                    },
                    showRoster = {
                        type = "toggle", order = 12,
                        name = L["OPT_SHOW_ROSTER"],
                        desc = L["OPT_SHOW_ROSTER_DESC"],
                        get = get, set = setVisual,
                    },
                    ldbText = {
                        type = "toggle", order = 13,
                        name = L["OPT_LDB_TEXT"],
                        desc = L["OPT_LDB_TEXT_DESC"],
                        get = get, set = setVisual,
                    },
                    debug = {
                        type = "toggle", order = 14,
                        name = L["OPT_DEBUG"], desc = L["OPT_DEBUG_DESC"],
                        get = get, set = setVisual,
                    },
                },
            },
        },
    }
end

function Options:OnInitialize()
    LibStub("AceConfig-3.0"):RegisterOptionsTable("ProfessionPilot", buildOptions)
    self.panel = LibStub("AceConfigDialog-3.0")
        :AddToBlizOptions("ProfessionPilot", "ProfessionPilot")
end

function Options:Open()
    -- 3.3.5 quirk: the first call may open the options frame without
    -- navigating to the category; calling twice is the standard workaround.
    InterfaceOptionsFrame_OpenToCategory(self.panel)
    InterfaceOptionsFrame_OpenToCategory(self.panel)
end
