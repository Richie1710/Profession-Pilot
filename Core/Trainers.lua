-- ProfessionPilot Core/Trainers.lua
-- Reine Logik der Lehrer-Uebersicht: naechster Rang, Fraktionsfilter, Gruppierung nach Ort,
-- Hervorhebung. Kein WoW-API-Aufruf; alles kommt per Argument (Daten: PP.TrainerData).

local PP = _G.ProfessionPilot
local Trainers = {}
PP.Trainers = Trainers

-- Reihenfolge der Hauptstaedte je Fraktion (mapFile wie in PP.TrainerData.zones)
Trainers.CAPITAL_ORDER = {
    A = { "Stormwind", "Ironforge", "Darnassis", "TheExodar" },
    H = { "Ogrimmar", "Undercity", "ThunderBluff", "SilvermoonCity" },
}
Trainers.NEUTRAL_HUBS = { "ShattrathCity", "Dalaran" }

-- Naechster benoetigter Rang (1 Lehrling .. 6 Grossmeister) aus der aktuellen Obergrenze.
-- ranks = Rang-Obergrenzen des Berufs ({75, 150, ..., 450}). Beruf nicht erlernt (cap nil/0) -> 1.
-- Alles gelernt (cap >= maxSkill) -> nil.
function Trainers.NextRank(ranks, skill, cap, maxSkill)
    if not cap or cap <= 0 then return 1 end
    maxSkill = maxSkill or (ranks and ranks[#ranks]) or 450
    if cap >= maxSkill then return nil end
    for i, r in ipairs(ranks or {}) do
        if r > cap then return i end
    end
    return nil
end

-- Lehrt der Lehrer diesen Rang? (ranks ist eine Liste, GM-Lehrer lehren oft nur Rang 6)
function Trainers.Teaches(t, rank)
    if not rank or not t.ranks then return false end
    for _, r in ipairs(t.ranks) do
        if r == rank then return true end
    end
    return false
end

function Trainers.MaxRank(t)
    if not t.ranks or #t.ranks == 0 then return nil end
    return t.ranks[#t.ranks]
end

-- UnitFactionGroup("player") -> "A" / "H" / nil (dann werden alle Lehrer gezeigt)
function Trainers.FactionCode(group)
    if group == "Alliance" then return "A" end
    if group == "Horde" then return "H" end
    return nil
end

-- opts.faction ("A"/"H"/nil): eigene Fraktion + neutral. opts.onlyRank: nur Lehrer dieses Rangs
-- (Spezialisierungslehrer fallen dann raus).
function Trainers.Filter(list, opts)
    opts = opts or {}
    local out = {}
    for _, t in ipairs(list or {}) do
        local ok = true
        if opts.faction and t.f ~= opts.faction and t.f ~= "N" then ok = false end
        if ok and opts.onlyRank and not Trainers.Teaches(t, opts.onlyRank) then ok = false end
        if ok then out[#out + 1] = t end
    end
    return out
end

local function isDe(locale)
    return locale == "deDE"
end

function Trainers.LocalName(t, locale)
    if isDe(locale) then return t.nameDe or t.name end
    return t.name or t.nameDe
end

function Trainers.LocalSub(t, locale)
    if isDe(locale) then return t.subDe or t.sub end
    return t.sub or t.subDe
end

local function pick(rec, locale, fallback)
    if not rec then return fallback end
    if isDe(locale) then
        if rec.de and rec.de ~= "" then return rec.de end
        return rec.en or fallback
    end
    if rec.en and rec.en ~= "" then return rec.en end
    return rec.de or fallback
end

function Trainers.ZoneName(data, map, locale)
    return pick(data and data.zones and data.zones[map], locale, map)
end

function Trainers.AreaName(data, id, locale)
    if not id then return nil end
    return pick(data and data.areas and data.areas[id], locale, nil)
end

-- Mindeststufe fuer einen Rang (PP.TrainerData.rankLevel[key][rank]); nil wenn unbekannt
function Trainers.RankLevel(data, key, rank)
    local lv = data and data.rankLevel and data.rankLevel[key]
    local v = lv and rank and lv[rank]
    if v and v > 0 then return v end
    return nil
end

local function makeRow(data, t, opts)
    return {
        trainer = t,
        highlight = (opts.nextRank and Trainers.Teaches(t, opts.nextRank)) and true or false,
        maxRank = Trainers.MaxRank(t),
        name = Trainers.LocalName(t, opts.locale) or "",
        zone = Trainers.ZoneName(data, t.map, opts.locale),
        sub = Trainers.AreaName(data, t.area, opts.locale),
    }
end

-- hervorgehoben zuerst, dann hoechster Rang, dann Name, dann id
local function rowLess(a, b)
    if a.highlight ~= b.highlight then return a.highlight end
    local ma, mb = a.maxRank or 0, b.maxRank or 0
    if ma ~= mb then return ma > mb end
    if a.name ~= b.name then return a.name < b.name end
    return a.trainer.id < b.trainer.id
end

local function specLess(a, b)
    if a.name ~= b.name then return a.name < b.name end
    return a.trainer.id < b.trainer.id
end

-- Gruppen fuer die Anzeige.
-- opts = { faction = "A"|"H"|nil, nextRank = 1..6|nil, onlyRank = 1..6|nil, locale = "deDE"|... }
-- Rueckgabe: { { kind = "capital"|"hub"|"zone"|"spec", map = mapFile|nil, c = Kontinent|nil,
--               title = lokalisierter Zonenname|nil, rows = { {trainer, highlight, maxRank, name, zone, sub} } } }
-- Reihenfolge: eigene Hauptstaedte, Shattrath, Dalaran, uebrige Zonen (Kontinent, Name), Spezialisierung.
function Trainers.Build(data, key, opts)
    opts = opts or {}
    local list = Trainers.Filter(data and data.trainers and data.trainers[key], opts)

    local byMap, specRows = {}, {}
    for _, t in ipairs(list) do
        local row = makeRow(data, t, opts)
        if t.spec then
            specRows[#specRows + 1] = row
        else
            byMap[t.map] = byMap[t.map] or {}
            table.insert(byMap[t.map], row)
        end
    end

    local groups, used = {}, {}
    local function addGroup(kind, map)
        local rows = byMap[map]
        if not rows or used[map] then return end
        used[map] = true
        table.sort(rows, rowLess)
        local z = data.zones and data.zones[map]
        groups[#groups + 1] = {
            kind = kind, map = map, c = z and z.c,
            title = Trainers.ZoneName(data, map, opts.locale), rows = rows,
        }
    end

    local capitals = {}
    if opts.faction then
        capitals = Trainers.CAPITAL_ORDER[opts.faction] or {}
    else
        for _, m in ipairs(Trainers.CAPITAL_ORDER.A) do capitals[#capitals + 1] = m end
        for _, m in ipairs(Trainers.CAPITAL_ORDER.H) do capitals[#capitals + 1] = m end
    end
    for _, m in ipairs(capitals) do addGroup("capital", m) end
    for _, m in ipairs(Trainers.NEUTRAL_HUBS) do addGroup("hub", m) end

    local rest = {}
    for map in pairs(byMap) do
        if not used[map] then
            local z = data.zones and data.zones[map]
            rest[#rest + 1] = { map = map, c = z and z.c or 9, name = Trainers.ZoneName(data, map, opts.locale) }
        end
    end
    table.sort(rest, function(a, b)
        if a.c ~= b.c then return a.c < b.c end
        if a.name ~= b.name then return a.name < b.name end
        return a.map < b.map
    end)
    for _, r in ipairs(rest) do addGroup("zone", r.map) end

    if #specRows > 0 and not opts.onlyRank then
        table.sort(specRows, specLess)
        groups[#groups + 1] = { kind = "spec", rows = specRows }
    end
    return groups
end

function Trainers.Count(groups)
    local n = 0
    for _, g in ipairs(groups or {}) do n = n + #g.rows end
    return n
end

function Trainers.HighlightCount(groups)
    local n = 0
    for _, g in ipairs(groups or {}) do
        for _, r in ipairs(g.rows) do
            if r.highlight then n = n + 1 end
        end
    end
    return n
end

-- Flache Anzeigeliste: { {header = group}, {row = row, group = group}, ... }
function Trainers.Flatten(groups)
    local out = {}
    for _, g in ipairs(groups or {}) do
        out[#out + 1] = { header = g }
        for _, r in ipairs(g.rows) do out[#out + 1] = { row = r, group = g } end
    end
    return out
end
