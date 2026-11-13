-- ProfessionPilot Core/MaterialPlan.lua
-- Reine Logik der oeffentlichen Material-API (Issue Richie1710/ProfessionLeveler#26):
-- aus einem Beruf, dem Skill und den Inventarzahlen wird eine flache Liste der
-- Basismaterialien bis zu einem frei gewaehlten Zielskill gebaut, dazu die
-- Stringform fuer Lua.LuaDoString. Keine WoW-API, kein gespeicherter Zustand --
-- alles kommt ueber Argumente, headless testbar (Tests/test_materialplan.lua).
-- Der Laufzeit-Teil (PP:GetMaterialPlan) steht in Modules/PublicAPI.lua.
--
-- Rechenkern ist Calc.AggregateMaterials: Bestand wird dort genau einmal aus
-- einem gemeinsamen Pool abgezogen, Zwischenprodukte (craftedBy) werden zu
-- ihren Zutaten aufgeloest. Diese Datei sammelt nur die Blaetter des Baums
-- ein und fasst sie je Item zusammen -- Zaehlungen werden nie neu gerechnet,
-- also auch nichts doppelt gezaehlt.

local PP = _G.ProfessionPilot
local Calc = PP.Calc

local MaterialPlan = {}
PP.MaterialPlan = MaterialPlan

-- Version der oeffentlichen Form (Tabelle und String). Inkompatible
-- Aenderungen erhoehen sie; Aufrufer pruefen sie vor dem Parsen.
local API_VERSION = 1
MaterialPlan.API_VERSION = API_VERSION
PP.API_VERSION = API_VERSION

-- Fehlercodes (plan.error bzw. "v1|err|<code>"):
--   not_ready            Addon-Datenbank oder Berufserkennung noch nicht initialisiert
--   unknown_profession   kein registrierter Beruf mit diesem Schluessel
--   no_profession        Beruf registriert, der Charakter hat ihn nicht (Skill 0/unbekannt)
--   bad_args             Schluessel oder Zielskill unbrauchbar
MaterialPlan.ERRORS = {
    "not_ready", "unknown_profession", "no_profession", "bad_args",
}

local ceil, floor = math.ceil, math.floor

-- Mengen sind ganzzahlig; die Rundung faengt nur Gleitkommarauschen ab.
local function whole(x)
    local n = ceil((x or 0) - 1e-6)
    -- <= 0 faengt auch -0 ab (ceil(-0.5) ergibt -0, im String waere das "-0").
    if n <= 0 then return 0 end
    return n
end

function MaterialPlan.Fail(code)
    return { ok = false, error = code, apiVersion = API_VERSION }
end

-- Alle Basismaterialien (Knoten ohne craftedBy) des Aggregat-Baums, je Item
-- summiert. need = gesamter Bedarf (direkt + ueber aufgeloeste Zwischenprodukte),
-- missing = nach Abzug des Bestands (aus Calc). Ergebnis nach itemId sortiert.
local function collectLeaves(entries)
    local byItem, list = {}, {}
    Calc.WalkTree(entries, function(n)
        if not n.craftedBy then
            local e = byItem[n.itemId]
            if not e then
                e = { itemId = n.itemId, need = 0, missing = 0 }
                byItem[n.itemId] = e
                list[#list + 1] = e
            end
            e.need = e.need + (n.need or 0)
            e.missing = e.missing + (n.missing or 0)
        end
    end)
    table.sort(list, function(a, b) return a.itemId < b.itemId end)
    return list
end

-- input:
--   skill        aktueller Skill des Berufs (Pflicht, > 0)
--   cap          aktuelles Rang-Maximum (optional)
--   known        Set bekannter Rezepte (optional, fuer die Rechnung ohne Wirkung)
--   counts       { [itemId] = { bags = n, bank = n } }
--   includeBank  Bankbestand mitzaehlen (Standard false)
--   countsReady  false = Taschenzahlen noch nicht nach dem Ladescreen gelesen
--   bankScanned  Bank wurde mindestens einmal gelesen (sonst ist bank immer 0)
--   toSkill      Zielskill (Standard und Obergrenze: prof.maxSkill)
-- -> plan-Tabelle (ok = true) oder MaterialPlan.Fail(code)
--
-- Granularitaet: toSkill gilt auf Schrittebene. Jeder Schritt, der zwischen
-- Skill und toSkill beginnt, wird komplett gerechnet (wie im Material-Fenster);
-- plan.coveredToSkill nennt den tatsaechlichen Endpunkt.
function MaterialPlan.Build(prof, input)
    if type(input) ~= "table" then return MaterialPlan.Fail("bad_args") end
    if type(prof) ~= "table" or type(prof.steps) ~= "table" or not prof.producers then
        return MaterialPlan.Fail("unknown_profession")
    end
    local skill = input.skill
    if type(skill) ~= "number" or skill <= 0 then
        return MaterialPlan.Fail("no_profession")
    end

    local maxSkill = prof.maxSkill or 450
    local toSkill = input.toSkill
    if toSkill == nil then
        toSkill = maxSkill
    elseif type(toSkill) ~= "number" or toSkill ~= toSkill or toSkill < 1 then
        return MaterialPlan.Fail("bad_args")
    end
    toSkill = floor(toSkill)
    if toSkill > maxSkill then toSkill = maxSkill end

    local includeBank = input.includeBank == true
    local counts = input.counts or {}
    local ctx = {
        skill = skill,
        cap = input.cap or 0,
        known = input.known or {},
        counts = counts,
        includeBank = includeBank,
        maxSkill = maxSkill,
    }

    local covered = skill
    for i = 1, #prof.steps do
        local step = prof.steps[i]
        if step.maxSkill > skill and step.minSkill < toSkill
            and step.maxSkill > covered then
            covered = step.maxSkill
        end
    end

    local agg = Calc.AggregateMaterials(prof, ctx, { toSkill = toSkill })

    local leaves = collectLeaves(agg.entries)
    for i = 1, #leaves do
        local e = leaves[i]
        local c = counts[e.itemId]
        local bags = c and c.bags or 0
        local bank = c and c.bank or 0
        e.need = whole(e.need)
        e.missing = whole(e.missing)
        e.bags = bags
        e.bank = bank
        e.have = bags + (includeBank and bank or 0)
    end

    local intermediates = {}
    for recipeSpellId, crafts in pairs(agg.crafts) do
        local producer = prof.producers[recipeSpellId]
        intermediates[#intermediates + 1] = {
            itemId = producer and producer.craftedItemId or 0,
            recipeSpellId = recipeSpellId,
            crafts = whole(crafts),
        }
    end
    table.sort(intermediates, function(a, b)
        return a.recipeSpellId < b.recipeSpellId
    end)

    return {
        ok = true,
        apiVersion = API_VERSION,
        profession = prof.key,
        skill = skill,
        cap = input.cap or 0,
        maxSkill = maxSkill,
        toSkill = toSkill,
        coveredToSkill = covered,
        includeBank = includeBank,
        countsReady = input.countsReady == true,
        bankScanned = input.bankScanned == true,
        leaves = leaves,
        intermediates = intermediates,
    }
end

-- ---------------------------------------------------------------------------
-- Stringform (Lua.LuaDoString kann nur Strings zurueckgeben)
--
--   v<API_VERSION>|<state>|<profession>|<skill>|<cap>|<toSkill>|<includeBank>|<leaves>|<crafts>
--
--   state        ready      Taschenzahlen gelesen, Plan verwertbar
--                notready   Plan gerechnet, aber Taschenzahlen noch nicht gelesen
--                           (missing ist dann ueberall zu hoch) -> warten, neu fragen
--   profession   Berufsschluessel, z. B. leatherworking
--   includeBank  1 = Bank zaehlt zu have, 0 = nur Taschen
--   leaves       itemId:need:bags:bank:missing, durch ';' getrennt, nach itemId sortiert
--   crafts       itemId:recipeSpellId:crafts, durch ';' getrennt (Zwischenprodukte,
--                die noch hergestellt werden muessen), nach recipeSpellId sortiert
--
--   Fehler:  v<API_VERSION>|err|<code>
--
-- Keine Itemnamen, keine Leerzeichen, keine Sonderzeichen ausser | : ;
-- Leere Listen sind leere Felder: "...|1||" (beide leer).
-- ---------------------------------------------------------------------------

function MaterialPlan.ToString(plan)
    local v = "v" .. API_VERSION
    if type(plan) ~= "table" then return v .. "|err|bad_args" end
    if not plan.ok then return v .. "|err|" .. tostring(plan.error or "bad_args") end

    local leaves = {}
    for i = 1, #plan.leaves do
        local e = plan.leaves[i]
        leaves[i] = e.itemId .. ":" .. e.need .. ":" .. e.bags .. ":"
            .. e.bank .. ":" .. e.missing
    end
    local crafts = {}
    for i = 1, #plan.intermediates do
        local e = plan.intermediates[i]
        crafts[i] = e.itemId .. ":" .. e.recipeSpellId .. ":" .. e.crafts
    end

    return table.concat({
        v,
        plan.countsReady and "ready" or "notready",
        plan.profession,
        plan.skill,
        plan.cap,
        plan.toSkill,
        plan.includeBank and 1 or 0,
        table.concat(leaves, ";"),
        table.concat(crafts, ";"),
    }, "|")
end

-- Zerlegt an '|' und behaelt leere Felder (gmatch "[^|]*" liefert in 5.1 uneinheitlich).
local function splitPipe(s)
    local out, pos = {}, 1
    while true do
        local i = s:find("|", pos, true)
        if not i then
            out[#out + 1] = s:sub(pos)
            break
        end
        out[#out + 1] = s:sub(pos, i - 1)
        pos = i + 1
    end
    return out
end

local function splitList(s, sep)
    local out = {}
    if s == "" then return out end
    local pos = 1
    while true do
        local i = s:find(sep, pos, true)
        if not i then
            out[#out + 1] = s:sub(pos)
            break
        end
        out[#out + 1] = s:sub(pos, i - 1)
        pos = i + 1
    end
    return out
end

local function numbers(s, count)
    local parts = splitList(s, ":")
    if #parts ~= count then return nil end
    local out = {}
    for i = 1, count do
        local n = tonumber(parts[i])
        if not n then return nil end
        out[i] = n
    end
    return out
end

-- Gegenstueck zu ToString: -> plan-Tabelle (gleiche Felder wie Build, ausser
-- maxSkill/coveredToSkill/bankScanned) bzw. { ok = false, error = code }.
-- Unbekannte Version, kaputte Felder -> error = "bad_format".
function MaterialPlan.Parse(str)
    if type(str) ~= "string" then
        return { ok = false, error = "bad_format" }
    end
    local f = splitPipe(str)
    local version = f[1] and f[1]:match("^v(%d+)$")
    if not version or tonumber(version) ~= API_VERSION then
        return { ok = false, error = "bad_format" }
    end
    if f[2] == "err" then
        return { ok = false, error = f[3] or "bad_format", apiVersion = API_VERSION }
    end
    if #f ~= 9 or (f[2] ~= "ready" and f[2] ~= "notready") then
        return { ok = false, error = "bad_format" }
    end

    local skill, cap, toSkill = tonumber(f[4]), tonumber(f[5]), tonumber(f[6])
    if not (skill and cap and toSkill) or (f[7] ~= "0" and f[7] ~= "1") or f[3] == "" then
        return { ok = false, error = "bad_format" }
    end
    local includeBank = f[7] == "1"

    local leaves = {}
    local list = splitList(f[8], ";")
    for i = 1, #list do
        local n = numbers(list[i], 5)
        if not n then return { ok = false, error = "bad_format" } end
        leaves[i] = {
            itemId = n[1], need = n[2], bags = n[3], bank = n[4], missing = n[5],
            have = n[3] + (includeBank and n[4] or 0),
        }
    end
    local intermediates = {}
    list = splitList(f[9], ";")
    for i = 1, #list do
        local n = numbers(list[i], 3)
        if not n then return { ok = false, error = "bad_format" } end
        intermediates[i] = { itemId = n[1], recipeSpellId = n[2], crafts = n[3] }
    end

    return {
        ok = true,
        apiVersion = API_VERSION,
        countsReady = f[2] == "ready",
        profession = f[3],
        skill = skill,
        cap = cap,
        toSkill = toSkill,
        includeBank = includeBank,
        leaves = leaves,
        intermediates = intermediates,
    }
end

return MaterialPlan
