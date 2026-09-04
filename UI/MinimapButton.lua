-- ProfessionPilot UI/MinimapButton.lua
-- LibDataBroker launcher plus LibDBIcon minimap button.
--
-- LDB text mode: UpdateFromSnapshot also maintains dataObject.text with the
-- live progress ("<skill>/<max> | <n>x <recipe>"). The object deliberately
-- stays type "launcher" -- LibDBIcon expects a launcher for the minimap
-- button, and display addons that render text (Titan, ChocolateBar, FuBar
-- bridges) show .text regardless of type, while the minimap icon ignores it.
-- Gated by PP.db.profile.ldbText (nil/true = on, false = off).

local PP = _G.ProfessionPilot
local L = PP.L

local MinimapButton = PP:NewModule("MinimapButton", "AceEvent-3.0")
PP.UI.MinimapButton = MinimapButton

local ICON = "Interface\\Icons\\Trade_Engineering"
local MAX_NAME_CHARS = 20

-- UTF-8 aware truncation: a plain :sub(1, n) can split a multi-byte
-- character (deDE umlauts) and 3.3.5 FontStrings render that as garbage.
local function truncate(text, maxChars)
    local i, len, chars = 1, #text, 0
    while i <= len do
        chars = chars + 1
        if chars > maxChars then
            return text:sub(1, i - 1)
        end
        local b = text:byte(i)
        if b >= 240 then i = i + 4
        elseif b >= 224 then i = i + 3
        elseif b >= 192 then i = i + 2
        else i = i + 1 end
    end
    return text
end

function MinimapButton:OnEnable()
    local LDB = LibStub("LibDataBroker-1.1", true)
    local DBIcon = LibStub("LibDBIcon-1.0", true)
    if not LDB then return end

    if not self.dataObject then
        self.dataObject = LDB:NewDataObject("ProfessionPilot", {
            type = "launcher",
            icon = ICON,
            label = "ProfessionPilot",
            OnClick = function(_, button)
                if button == "RightButton" then
                    PP.UI.Options:Open()
                else
                    PP.UI.MainWindow:Toggle()
                end
            end,
            OnTooltipShow = function(tooltip)
                tooltip:AddLine("ProfessionPilot", 1, 0.82, 0)
                local snap = PP.snapshot
                if snap and snap.profession then
                    tooltip:AddLine(L["SKILL_LABEL"]
                        :format(snap.skill, snap.profession.maxSkill), 1, 1, 1)
                    if snap.currentIndex then
                        local step = snap.profession.steps[snap.currentIndex]
                        local name = GetSpellInfo(step.recipeSpellId)
                        tooltip:AddLine(L["NEXT_LABEL"] .. " " .. (name or "?"),
                            0.9, 0.9, 0.9)
                    end
                    local missing = 0
                    for _, e in ipairs(snap.totals.entries) do
                        if e.missing > 0 and not e.craftedBy then
                            missing = missing + e.missing
                        end
                    end
                    if missing > 0 then
                        tooltip:AddLine(L["COL_MISSING"] .. ": " .. missing,
                            1, 0.35, 0.35)
                    end
                end
                tooltip:AddLine(L["MINIMAP_LEFT"], 0.6, 0.8, 1)
                tooltip:AddLine(L["MINIMAP_RIGHT"], 0.6, 0.8, 1)
            end,
        })
    end

    if DBIcon and not DBIcon:IsRegistered("ProfessionPilot") then
        DBIcon:Register("ProfessionPilot", self.dataObject, PP.db.profile.minimap)
    end

    -- Re-render the text when settings change (ldbText toggle, /pp reset);
    -- data changes arrive via the direct call in PP:Recompute().
    self:RegisterMessage("PP_SETTINGS_CHANGED", function()
        self:UpdateFromSnapshot()
    end)

    self:ApplySettings()
    self:UpdateFromSnapshot()
end

function MinimapButton:ApplySettings()
    local DBIcon = LibStub("LibDBIcon-1.0", true)
    if not DBIcon then return end
    if PP.db.profile.minimap.hide then
        DBIcon:Hide("ProfessionPilot")
    else
        DBIcon:Show("ProfessionPilot")
    end
end

-- Keep the launcher icon and the LDB text in sync with the active profession.
function MinimapButton:UpdateFromSnapshot()
    if not self.dataObject then return end
    local snap = PP.snapshot

    if snap and snap.profession then
        local _, _, icon = GetSpellInfo(snap.profession.professionSpellId)
        if icon then self.dataObject.icon = icon end
    else
        self.dataObject.icon = ICON
    end

    -- ldbText == false disables the text; nil (default not yet in the DB
    -- defaults) counts as enabled so the feature works out of the box.
    local profile = PP.db and PP.db.profile
    if not profile or profile.ldbText == false
        or not (snap and snap.profession) then
        self.dataObject.text = nil
        return
    end

    local text = snap.skill .. "/" .. snap.profession.maxSkill
    local idx = snap.currentIndex
    local info = idx and snap.steps and snap.steps[idx]
    if info then
        local name = GetSpellInfo(snap.profession.steps[idx].recipeSpellId)
        if name then
            text = text .. " | " .. (info.remainingCrafts or "?") .. "x "
                .. truncate(name, MAX_NAME_CHARS)
        end
    end
    self.dataObject.text = text
end
