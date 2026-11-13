-- ProfessionPilot Modules/PublicAPI.lua
-- Oeffentliche, versionierte Schnittstelle fuer andere Addons und Bots
-- (Issue Richie1710/ProfessionLeveler#26). Duenner WoW-Teil: sammelt Zustand
-- und Zaehlungen aus PP.state / PP.counts / PP.db und uebergibt sie an die
-- reine Logik in Core/MaterialPlan.lua. Kein WoW-API-Aufruf, keine Events,
-- kein Eingriff in die UI: der aktive Beruf wird NICHT umgeschaltet und
-- showUpcoming/includeBank der Einstellungen bleiben ohne Wirkung.
--
--   ProfessionPilot.API_VERSION                       -> 1
--   ProfessionPilot:GetMaterialPlan(key, toSkill, opts)        -> plan (Tabelle)
--   ProfessionPilot:GetMaterialPlanString(key, toSkill, opts)  -> "v1|ready|..."
--
-- key       Berufsschluessel, z. B. "leatherworking" (siehe Professions/*.lua)
-- toSkill   Zielskill, frei waehlbar; nil = Berufsmaximum, ueber dem Maximum
--           wird begrenzt. Schrittgenau (siehe Core/MaterialPlan.lua).
-- opts      { includeBank = bool } (Standard false: nur Taschen); fuer die
--           String-Variante ist auch ein Boolean als dritter Parameter erlaubt.
--
-- Rueckgabe ist immer eine Tabelle bzw. ein String, nie nil. Fehler:
-- plan.ok == false und plan.error == "not_ready" | "unknown_profession" |
-- "no_profession" | "bad_args" bzw. "v1|err|<code>". Format und Felder: README.

local PP = _G.ProfessionPilot

-- opts darf eine Tabelle oder (nur String-Variante) ein Boolean sein.
local function normalizeOpts(opts)
    if type(opts) == "boolean" then return { includeBank = opts } end
    if type(opts) == "table" then return opts end
    return {}
end

function PP:GetMaterialPlan(key, toSkill, opts)
    local MaterialPlan = self.MaterialPlan
    if not MaterialPlan then return { ok = false, error = "not_ready" } end

    if type(key) ~= "string" or key == "" then
        return MaterialPlan.Fail("bad_args")
    end
    -- Datenbank (OnInitialize) und Berufserkennung (SkillTracker-Scan) fehlen
    -- direkt nach dem Laden; ohne sie sind Skill und Zaehlungen unbekannt.
    local state = self.state
    if not self.db or not state or not state.professions then
        return MaterialPlan.Fail("not_ready")
    end

    local prof = self:GetProfession(key)
    if not prof then return MaterialPlan.Fail("unknown_profession") end

    -- Skill je Beruf aus der Berufserkennung, unabhaengig vom aktiven Beruf.
    local info = state.professions[key]
    if not info then return MaterialPlan.Fail("no_profession") end

    opts = normalizeOpts(opts)
    local char = self.db.char or {}
    return MaterialPlan.Build(prof, {
        skill = info.skill,
        cap = info.cap,
        known = char.knownRecipes,
        counts = self.counts,
        includeBank = opts.includeBank == true,
        countsReady = state.countsReady == true,
        bankScanned = char.bankScanned == true,
        toSkill = toSkill,
    })
end

function PP:GetMaterialPlanString(key, toSkill, opts)
    local MaterialPlan = self.MaterialPlan
    if not MaterialPlan then return "v1|err|not_ready" end
    return MaterialPlan.ToString(self:GetMaterialPlan(key, toSkill, opts))
end
