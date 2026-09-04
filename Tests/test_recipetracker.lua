-- RecipeTracker: Erkennen frisch gelernter Rezepte ohne offenes Berufsfenster.

local root = ((arg and arg[0] or ""):match("^(.*)[/\]") or ".") .. "/.."
local PP = _G.ProfessionPilot

local saved = {
    NewModule = rawget(PP, "NewModule"),
    Recompute = rawget(PP, "Recompute"),
    GetProfession = rawget(PP, "GetProfession"),
    GetProfessions = rawget(PP, "GetProfessions"),
    db = rawget(PP, "db"),
    state = rawget(PP, "state"),
    IsSpellKnown = _G.IsSpellKnown,
    GetTradeSkillLine = _G.GetTradeSkillLine,
    GetCraftName = _G.GetCraftName,
}

local LEARNED, NOT_LEARNED = 3918, 3919
local PROF = {
    key = "engineering",
    professionSpellId = 4036,
    steps = { { recipeSpellId = LEARNED }, { recipeSpellId = NOT_LEARNED } },
}

local module
function PP:NewModule() module = {} return module end

local recomputed = 0
PP.Recompute = function() recomputed = recomputed + 1 end
PP.GetProfession = function(_, key) return key == PROF.key and PROF or nil end
PP.GetProfessions = function() return { engineering = PROF } end
PP.state = { professions = { engineering = true }, activeKey = "engineering" }
PP.db = { char = { knownRecipes = {} }, profile = { debug = false } }

-- Kein Berufsfenster offen -- genau die Situation beim Lehrer.
_G.GetTradeSkillLine = function() return nil end
_G.GetCraftName = function() return nil end
_G.IsSpellKnown = function(id) return id == LEARNED end

local chunk = assert(loadfile(root .. "/Modules/RecipeTracker.lua"))
chunk()
local RT = module
T.ok(RT ~= nil and RT.OnSpellLearned ~= nil, "RecipeTracker laedt headless")

-- Issue #1: das Rezept ist gelernt, aber ohne Fenster kennt es kein Scan.
RT:OnSpellLearned()
T.eq(PP.db.char.knownRecipes[LEARNED], true, "gelerntes Rezept landet im Cache")
T.eq(PP.db.char.knownRecipes[NOT_LEARNED], nil, "ungelerntes bleibt draussen")
T.ok(recomputed > 0, "Neuberechnung wird angestossen")

-- Ohne Aenderung darf kein weiteres Recompute ausgeloest werden.
local before = recomputed
RT:OnSpellLearned()
T.eq(recomputed, before, "zweiter Aufruf ohne Neuerung rechnet nicht neu")

-- Aeltere Clients ohne IsSpellKnown duerfen nicht in einen Fehler laufen.
_G.IsSpellKnown = nil
PP.db.char.knownRecipes = {}
T.eq(RT:SweepKnownSpells(), false, "ohne IsSpellKnown: sauberer No-op")

for k in pairs({ NewModule = 1, Recompute = 1, GetProfession = 1,
                 GetProfessions = 1, db = 1, state = 1 }) do
    PP[k] = saved[k]
end
_G.IsSpellKnown = saved.IsSpellKnown
_G.GetTradeSkillLine = saved.GetTradeSkillLine
_G.GetCraftName = saved.GetCraftName
