-- Tests fuer Modules/PublicAPI.lua: PP:GetMaterialPlan / GetMaterialPlanString
-- mit gestubbtem Addon-Zustand (PP.db, PP.state, PP.counts).

local root = ((arg and arg[0] or ""):match("^(.*)[/\\]") or ".") .. "/.."
local PP = _G.ProfessionPilot

local saved = {
    db = rawget(PP, "db"),
    state = rawget(PP, "state"),
    counts = rawget(PP, "counts"),
    GetMaterialPlan = rawget(PP, "GetMaterialPlan"),
    GetMaterialPlanString = rawget(PP, "GetMaterialPlanString"),
}

assert(loadfile(root .. "/Modules/PublicAPI.lua"))()
T.ok(type(PP.GetMaterialPlan) == "function", "GetMaterialPlan ist definiert")
T.ok(type(PP.GetMaterialPlanString) == "function", "GetMaterialPlanString ist definiert")
T.eq(PP.API_VERSION, 1, "API_VERSION 1")

local function leaf(plan, itemId)
    for _, e in ipairs(plan.leaves) do
        if e.itemId == itemId then return e end
    end
end

-- Addon noch nicht initialisiert -----------------------------------------------

PP.db, PP.state, PP.counts = nil, nil, nil
local r = PP:GetMaterialPlan("leatherworking", 450)
T.eq(type(r), "table", "ohne DB: Tabelle statt nil")
T.eq(r.ok, false, "ohne DB: nicht ok")
T.eq(r.error, "not_ready", "ohne DB: not_ready")
T.eq(PP:GetMaterialPlanString("leatherworking", 450), "v1|err|not_ready", "ohne DB: Fehlerstring")

PP.db = { char = { knownRecipes = {} }, profile = {} }
PP.state = {}                    -- SkillTracker hat noch nicht gescannt
PP.counts = {}
T.eq(PP:GetMaterialPlan("leatherworking", 450).error, "not_ready",
    "ohne Berufserkennung: not_ready")

-- Zustand: Charakter hat Lederverarbeitung (290/300) und Ingenieurskunst (100/150) --

PP.state = {
    activeKey = "engineering", hasProfession = true, skill = 100, cap = 150,
    countsReady = true,
    professions = {
        engineering = { skill = 100, cap = 150 },
        leatherworking = { skill = 290, cap = 300 },
    },
}
PP.counts = {
    [8170] = { bags = 12, bank = 100 },
    [21887] = { bags = 0, bank = 0 },
}
PP.db.char.bankScanned = true

-- Fehlerfaelle -------------------------------------------------------------------

T.eq(PP:GetMaterialPlan(nil, 450).error, "bad_args", "Schluessel nil: bad_args")
T.eq(PP:GetMaterialPlan(42, 450).error, "bad_args", "Schluessel Zahl: bad_args")
T.eq(PP:GetMaterialPlan("", 450).error, "bad_args", "Schluessel leer: bad_args")
T.eq(PP:GetMaterialPlan("nonsense", 450).error, "unknown_profession",
    "unbekannter Beruf: unknown_profession")
T.eq(PP:GetMaterialPlan("tailoring", 450).error, "no_profession",
    "registrierter, aber nicht erlernter Beruf: no_profession")
T.eq(PP:GetMaterialPlan("leatherworking", "viel").error, "bad_args",
    "Zielskill kein Wert: bad_args")
T.eq(PP:GetMaterialPlanString("tailoring", 450), "v1|err|no_profession",
    "no_profession als String")
T.eq(PP:GetMaterialPlanString("nonsense", 450), "v1|err|unknown_profession",
    "unknown_profession als String")
T.eq(PP:GetMaterialPlanString(nil, 450), "v1|err|bad_args", "bad_args als String")

-- Plan fuer einen NICHT aktiven Beruf -----------------------------------------------

local p = PP:GetMaterialPlan("leatherworking", 450)
T.ok(p.ok, "Plan fuer nicht aktiven Beruf")
T.eq(p.profession, "leatherworking", "Beruf")
T.eq(p.skill, 290, "Skill aus der Berufserkennung, nicht aus state.skill")
T.eq(p.cap, 300, "Cap aus der Berufserkennung")
T.eq(p.toSkill, 450, "Zielskill")
T.eq(p.countsReady, true, "countsReady aus state")
T.eq(p.bankScanned, true, "bankScanned aus db.char")
T.eq(PP.state.activeKey, "engineering", "aktiver Beruf bleibt unveraendert")
T.eq(PP.state.skill, 100, "state.skill bleibt unveraendert")

-- Bank an/aus nur ueber opts, nicht ueber die UI-Einstellung --------------------------

T.eq(leaf(p, 8170).missing, 108, "Standard: nur Taschen, 120 - 12")
T.eq(p.includeBank, false, "includeBank Standard false")
PP.db.profile.includeBank = true         -- UI-Einstellung darf nichts aendern
PP.db.profile.showUpcoming = false
local again = PP:GetMaterialPlan("leatherworking", 450)
T.eq(leaf(again, 8170).missing, 108, "UI-includeBank ohne Wirkung")
T.eq(#again.leaves, #p.leaves, "UI-showUpcoming ohne Wirkung")

local withBank = PP:GetMaterialPlan("leatherworking", 450, { includeBank = true })
T.eq(withBank.includeBank, true, "opts.includeBank")
T.eq(leaf(withBank, 8170).missing, 8, "mit Bank: 120 - 112")
T.eq(leaf(withBank, 8170).bank, 100, "Bankzahl im Blatt")

-- Zielskill frei waehlbar --------------------------------------------------------------

local short = PP:GetMaterialPlan("leatherworking", 300)
T.eq(short.toSkill, 300, "Zielskill 300")
T.eq(short.coveredToSkill, 300, "abgedeckt bis 300")
T.ok(#short.leaves < #p.leaves, "kuerzerer Plan")
T.eq(PP:GetMaterialPlan("leatherworking").toSkill, 450, "ohne Zielskill: Maximum")

-- countsReady -----------------------------------------------------------------------------

PP.state.countsReady = false
local nr = PP:GetMaterialPlan("leatherworking", 450)
T.ok(nr.ok, "nicht bereit: trotzdem ein Plan")
T.eq(nr.countsReady, false, "countsReady false nach Ladescreen")
T.eq(PP:GetMaterialPlanString("leatherworking", 450):sub(1, 11), "v1|notready",
    "notready im String")
PP.state.countsReady = nil
T.eq(PP:GetMaterialPlan("leatherworking", 450).countsReady, false,
    "fehlendes Flag zaehlt als nicht bereit")
PP.state.countsReady = true

-- String-Variante ----------------------------------------------------------------------------

local s = PP:GetMaterialPlanString("leatherworking", 450)
T.eq(s:sub(1, 9), "v1|ready|", "String beginnt mit Version und Zustand")
T.eq(s:match("8170:%d+:%d+:%d+:%d+"), "8170:120:12:100:108", "Rugged Leather im String")
local sb = PP:GetMaterialPlanString("leatherworking", 450, true)
T.eq(sb:match("8170:%d+:%d+:%d+:%d+"), "8170:120:12:100:8", "Boolean als dritter Parameter")
local st = PP:GetMaterialPlanString("leatherworking", 450, { includeBank = true })
T.eq(st, sb, "Tabelle und Boolean liefern denselben String")
local back = PP.MaterialPlan.Parse(s)
T.ok(back.ok, "Rundlauf: Parse ok")
T.eq(back.profession, "leatherworking", "Rundlauf: Beruf")
T.eq(back.leaves[2].itemId, 8170, "Rundlauf: zweites Blatt Rugged Leather")
T.eq(back.leaves[2].missing, 108, "Rundlauf: fehlende Menge")

-- Leerer Bestand (PP.counts leer) rechnet ohne Fehler --------------------------------------

PP.counts = {}
local empty = PP:GetMaterialPlan("leatherworking", 450)
T.eq(leaf(empty, 8170).missing, 120, "ohne Bestand fehlt alles")
PP.counts = nil
local noCounts = PP:GetMaterialPlan("leatherworking", 450)
T.ok(noCounts.ok, "counts nil: kein Fehler")
T.eq(leaf(noCounts, 8170).missing, 120, "counts nil: fehlt alles")

-- Alte Werte zurueck --------------------------------------------------------------------------

PP.db, PP.state, PP.counts = saved.db, saved.state, saved.counts
PP.GetMaterialPlan = saved.GetMaterialPlan
PP.GetMaterialPlanString = saved.GetMaterialPlanString
