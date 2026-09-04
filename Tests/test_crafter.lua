-- Crafter:GetState -- der Zustandsautomat hinter dem Knopf im Hauptfenster.
-- Modules/Crafter.lua definiert an Dateiebene nur Funktionen, laesst sich mit
-- einem NewModule-Stub also headless laden und direkt aufrufen.

local root = ((arg and arg[0] or ""):match("^(.*)[/\]") or ".") .. "/.."
local PP = _G.ProfessionPilot

-- Umgebung sichern: alle Tests teilen sich einen Lua-Zustand.
local saved = {
    NewModule = rawget(PP, "NewModule"),
    Recompute = rawget(PP, "Recompute"),
    GetActiveProfession = rawget(PP, "GetActiveProfession"),
    snapshot = rawget(PP, "snapshot"),
    util = rawget(PP, "util"),
    GetTradeSkillLine = _G.GetTradeSkillLine,
    GetNumTradeSkills = _G.GetNumTradeSkills,
    GetTradeSkillInfo = _G.GetTradeSkillInfo,
    GetTradeSkillRecipeLink = _G.GetTradeSkillRecipeLink,
    GetCraftName = _G.GetCraftName,
    UnitAffectingCombat = _G.UnitAffectingCombat,
}

local RECIPE = 3918
local PROF = {
    key = "engineering",
    professionSpellId = 4036,
    steps = { { recipeSpellId = RECIPE } },
}

local module
function PP:NewModule() module = {} return module end
PP.Recompute = function() end
PP.GetActiveProfession = function() return PROF end
PP.util = { SpellIdFromRecipeLink = function(link)
    return link and tonumber(link:match("(%d+)")) or nil
end }

_G.UnitAffectingCombat = function() return false end
_G.GetCraftName = nil
_G.GetTradeSkillLine = function() return GetSpellInfo(PROF.professionSpellId) end
_G.GetNumTradeSkills = function() return 1 end
_G.GetTradeSkillInfo = function() return "Rezept", "optimal", 7 end
_G.GetTradeSkillRecipeLink = function() return "|Henchant:" .. RECIPE .. "|h" end

local chunk = assert(loadfile(root .. "/Modules/Crafter.lua"))
chunk()
local Crafter = module
T.ok(Crafter ~= nil and Crafter.GetState ~= nil, "Crafter laedt headless")

local function setKnown(known)
    PP.snapshot = {
        profession = PROF,
        currentIndex = 1,
        steps = { { flags = { recipeKnown = known }, remainingCrafts = 3 } },
    }
end

-- Ohne Schnappschuss gibt es nichts anzuzeigen.
PP.snapshot = nil
T.eq(Crafter:GetState(), "hidden", "ohne Snapshot: hidden")

-- Kernfall aus Issue #1: das Rezept gilt noch als unbekannt, weil der Cache
-- es mangels offenem Fenster nicht kennt. Dann muss der Knopf das Oeffnen
-- anbieten -- sonst kommt der Scan nie zustande, der es bekannt macht.
setKnown(false)
Crafter:TRADE_SKILL_CLOSE()
T.eq(Crafter:GetState(), "closed", "Fenster zu + Rezept unbekannt: Beruf oeffnen")

-- Erst bei offenem Fenster ist "unbekannt" eine belastbare Aussage.
Crafter:TRADE_SKILL_SHOW()
T.eq(Crafter:GetState(), "unknown", "Fenster offen + Rezept unbekannt: unknown")

setKnown(true)
local state, available = Crafter:GetState()
T.eq(state, "ready", "Fenster offen + Rezept bekannt: ready")
T.eq(available, 7, "ready meldet die herstellbare Anzahl")

Crafter:TRADE_SKILL_CLOSE()
T.eq(Crafter:GetState(), "closed", "Fenster zu + Rezept bekannt: Beruf oeffnen")

-- Umgebung zuruecksetzen.
for k, v in pairs({ NewModule = 1, Recompute = 1, GetActiveProfession = 1,
                    snapshot = 1, util = 1 }) do
    PP[k] = saved[k]
end
_G.GetTradeSkillLine = saved.GetTradeSkillLine
_G.GetNumTradeSkills = saved.GetNumTradeSkills
_G.GetTradeSkillInfo = saved.GetTradeSkillInfo
_G.GetTradeSkillRecipeLink = saved.GetTradeSkillRecipeLink
_G.GetCraftName = saved.GetCraftName
_G.UnitAffectingCombat = saved.UnitAffectingCombat
