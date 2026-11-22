-- ProfessionPilot Tools/trainer_gen_lib.lua
-- Stufe B der Lehrer-Daten: Logik, die aus den Rohdaten (Tools/data/trainer_source.lua)
-- Professions/TrainerData.lua macht. Reines Lua 5.1 ohne WoW-API; die Testsuite laedt die
-- Datei per dofile (Tests/test_trainer_gen.lua). Aufruf ueber Tools/gen_trainers.lua.

local Lib = {}

-- Rang-Lernzauber je SkillLine (trainer_spell.SpellId) -> Rangindex 1..6
-- (Lehrling, Geselle, Experte, Fachmann, Meister, Grossmeister).
Lib.RANK_SPELLS = {
    [171] = { [2275] = 1, [2280] = 2, [3465] = 3, [11612] = 4, [28597] = 5, [51303] = 6 },  -- Alchemie
    [164] = { [2020] = 1, [2021] = 2, [3539] = 3, [9786] = 4, [29845] = 5, [51298] = 6 },   -- Schmiedekunst
    [165] = { [2155] = 1, [2154] = 2, [3812] = 3, [10663] = 4, [32550] = 5, [51301] = 6 },  -- Lederverarbeitung
    [197] = { [3911] = 1, [3912] = 2, [3913] = 3, [12181] = 4, [26791] = 5, [51308] = 6 },  -- Schneiderei
    [202] = { [4039] = 1, [4040] = 2, [4041] = 3, [12657] = 4, [30351] = 5, [61464] = 6 },  -- Ingenieurskunst
    [333] = { [7414] = 1, [7415] = 2, [7416] = 3, [13921] = 4, [28030] = 5, [51312] = 6 },  -- Verzauberkunst
    [755] = { [25245] = 1, [25246] = 2, [28896] = 3, [28899] = 4, [28901] = 5, [51310] = 6 }, -- Juwelierskunst
    [773] = { [45375] = 1, [45376] = 2, [45377] = 3, [45378] = 4, [45379] = 5, [45380] = 6 }, -- Inschriftenkunde
}

-- SkillLine -> Registry-Key (Professions/*.lua)
Lib.SKILL_KEY = {
    [171] = "alchemy", [164] = "blacksmithing", [165] = "leatherworking", [197] = "tailoring",
    [202] = "engineering", [333] = "enchanting", [755] = "jewelcrafting", [773] = "inscription",
}

-- Englische Berufsnamen (Platzhalter-Erkennung: NPC heisst wie der Beruf, ohne Untertitel)
Lib.PROF_EN = {
    [171] = "Alchemy", [164] = "Blacksmithing", [165] = "Leatherworking", [197] = "Tailoring",
    [202] = "Engineering", [333] = "Enchanting", [755] = "Jewelcrafting", [773] = "Inscription",
}

-- Platzhalter-NPCs auf der Sehertreppe in Shattrath (unsichtbares Modell, keine echten Lehrer)
Lib.EXCLUDE = {
    [33608] = true, [33609] = true, [33610] = true, [33611] = true,
    [33612] = true, [33613] = true, [33614] = true, [33615] = true,
}

-- Template-Fraktion widerspricht dem Standort (Niobe: Template 189 "Kreatur", steht in der Wildhammerfeste)
Lib.SIDE_OVERRIDE = { [24868] = "A" }

-- Unterzone je NPC-Entry, wenn die ADT-Kachel des Spawns nur die Wurzelzone meldet.
-- Kirembri Silvermane steht zwischen Andiala und Lanloer auf der Sehertreppe (3898).
Lib.AREA_OVERRIDE = { [33637] = 3898 }

-- Unterzone ergaenzen: nur wenn keine bekannt ist und die Override-Area zur Zone gehoert
function Lib.SubAreaOf(entry, file, sub, src)
    if sub or not entry or not file then return sub end
    local ov = Lib.AREA_OVERRIDE[entry]
    local z = src.zones and src.zones[file]
    if ov and z and Lib.RootOf(ov, src.areas or {}) == z.areaId then return ov end
    return sub
end

-- Neutrale Templates, deren Freund-Fraktion Ruf verlangt
Lib.REP = { [1743] = "aldor", [1744] = "scryers", [414] = "timbermaw" }

-- Hauptstaedte: A/H = Fraktionshauptstadt, N = neutrale Drehkreuze
Lib.CAPITALS = {
    Stormwind = "A", Ironforge = "A", Darnassis = "A", TheExodar = "A",
    Ogrimmar = "H", Undercity = "H", ThunderBluff = "H", SilvermoonCity = "H",
    ShattrathCity = "N", Dalaran = "N",
}

-- WMO-Staedte, die in der ADT nur als Umland erscheinen: liegt der Spawn im Stadt-Rechteck und
-- gehoert die ADT-Zone zu einer der roots, ist es die Stadt (plus Hoehenbedingung).
Lib.CITY_FIX = {
    { file = "Ironforge", roots = { [1] = true } },                          -- ADT: Dun Morogh
    { file = "Undercity", roots = { [85] = true }, zMax = 0 },               -- ADT: Tirisfal (Ruinen)
    { file = "TheExodar", roots = { [3524] = true, [3479] = true } },        -- ADT: Azurmythos / Meer
    { file = "Dalaran", roots = { [2817] = true }, zMin = 500 },             -- ADT: Kristallsangwald
}

Lib.VALID_MAPS = { [0] = true, [1] = true, [530] = true, [571] = true }

local function hasBit(v, bit)
    return math.floor((v or 0) / bit) % 2 == 1
end
Lib.HasBit = hasBit

-- Raenge eines Lehrers aus seinen Rang-Lernzaubern. rankSpells = { {spellId, reqLevel}, ... }
-- Rueckgabe: aufsteigende Rangliste (dedupliziert), levels[rank] = reqLevel. Unbekannte Spells ignoriert.
function Lib.RanksOf(skillLine, rankSpells)
    local map = Lib.RANK_SPELLS[skillLine] or {}
    local seen, ranks, levels = {}, {}, {}
    for _, rs in ipairs(rankSpells or {}) do
        local r = map[rs[1]]
        if r and not seen[r] then
            seen[r] = true
            ranks[#ranks + 1] = r
            levels[r] = rs[2]
        end
    end
    table.sort(ranks)
    return ranks, levels
end

-- Seite eines Lehrers: "A", "H" oder "N". ft = factionTemplates aus den Rohdaten.
-- Maskenbits: 1 Spieler, 2 Allianz, 4 Horde, 8 Monster.
function Lib.SideOf(tpl, ft, entry)
    if entry and Lib.SIDE_OVERRIDE[entry] then return Lib.SIDE_OVERRIDE[entry] end
    local r = ft and ft[tpl]
    if not r then return "N" end
    local our, friend, enemy = r.our or 0, r.friend or 0, r.enemy or 0
    if hasBit(our, 2) and not hasBit(our, 4) then return "A" end
    if hasBit(our, 4) and not hasBit(our, 2) then return "H" end
    -- keine eigene Spielerfraktion: Freund-/Feindmaske entscheidet (Taunka 1922: Freund Horde)
    if hasBit(friend, 2) and not hasBit(friend, 4) then return "A" end
    if hasBit(friend, 4) and not hasBit(friend, 2) then return "H" end
    if not hasBit(our, 8) then
        if hasBit(enemy, 4) and not hasBit(enemy, 2) then return "A" end
        if hasBit(enemy, 2) and not hasBit(enemy, 4) then return "H" end
    end
    return "N"
end

function Lib.RepOf(tpl)
    return Lib.REP[tpl]
end

function Lib.IsPlaceholder(t)
    if Lib.EXCLUDE[t.entry] then return true end
    return t.name == Lib.PROF_EN[t.skillLine] and (t.sub or "") == ""
end

-- Nur offene Welt (Kontinente) und Standardphase
function Lib.ValidSpawn(s)
    return Lib.VALID_MAPS[s.map] == true and (s.phase or 1) % 2 == 1
end

-- Oberste Zone (Area ohne Eltern) einer Area-ID
function Lib.RootOf(areaId, areas)
    local id, guard = areaId, 0
    while id and areas[id] and areas[id].parent and areas[id].parent ~= 0 and guard < 20 do
        id = areas[id].parent
        guard = guard + 1
    end
    return id
end

local function inRect(z, x, y)
    return z and z.left ~= z.right and y <= z.left and y >= z.right and x <= z.top and x >= z.bottom
end
Lib.InRect = inRect

-- Zone (mapFile) und ggf. Unterzone eines Spawns. Rueckgabe: mapFile|nil, subAreaId|nil
function Lib.ZoneOf(s, src)
    local area = s.adtArea or 0
    local root = Lib.RootOf(area, src.areas or {})
    for _, fix in ipairs(Lib.CITY_FIX) do
        local z = src.zones[fix.file]
        if z and z.worldMap == s.map and fix.roots[root] and inRect(z, s.x, s.y)
            and (not fix.zMax or s.z < fix.zMax) and (not fix.zMin or s.z > fix.zMin) then
            return fix.file, nil
        end
    end
    if not root or root == 0 then return nil end
    local files = {}
    for file in pairs(src.zones) do files[#files + 1] = file end
    table.sort(files)
    for _, file in ipairs(files) do
        local z = src.zones[file]
        if z.areaId == root and z.worldMap == s.map then
            local sub = nil
            if area ~= root and area ~= 0 then sub = area end
            return file, sub
        end
    end
    return nil
end

local function round1(v)
    return math.floor(v * 10 + 0.5) / 10
end

-- Weltkoordinaten -> Zonenprozent. WoW-Welt: +X Norden, +Y Westen.
function Lib.ToMapXY(z, x, y)
    local mx = (z.left - y) / (z.left - z.right) * 100
    local my = (z.top - x) / (z.top - z.bottom) * 100
    return round1(mx), round1(my)
end

local function sortedKeys(t)
    local keys = {}
    for k in pairs(t) do keys[#keys + 1] = k end
    table.sort(keys)
    return keys
end

-- Rohdaten -> Addon-Daten. Rueckgabe data, report (Liste von Meldungstexten)
function Lib.Build(src)
    local report = {}
    local function note(fmt, ...) report[#report + 1] = string.format(fmt, ...) end

    local data = { rankLevel = {}, zones = {}, areas = {}, trainers = {} }
    for _, key in pairs(Lib.SKILL_KEY) do data.trainers[key] = {} end

    local levelsSeen = {}
    for _, t in ipairs(src.trainers) do
        local key = Lib.SKILL_KEY[t.skillLine]
        if not key then
            note("skip %d %s: unbekannte SkillLine %s", t.entry, t.name, tostring(t.skillLine))
        elseif Lib.IsPlaceholder(t) then
            note("Platzhalter ausgeschlossen: %d %s", t.entry, t.name)
        else
            local ranks, levels = Lib.RanksOf(t.skillLine, t.rankSpells)
            levelsSeen[key] = levelsSeen[key] or {}
            for r, lvl in pairs(levels) do
                levelsSeen[key][r] = levelsSeen[key][r] or {}
                levelsSeen[key][r][lvl] = true
            end
            local f = Lib.SideOf(t.faction, src.factionTemplates, t.entry)
            local rep = Lib.RepOf(t.faction)
            local doneMap, rows = {}, 0
            for _, s in ipairs(t.spawns or {}) do
                if not Lib.ValidSpawn(s) then
                    note("Spawn verworfen (Instanz/Phase): %d %s guid %d map %d phase %d",
                        t.entry, t.name, s.guid, s.map, s.phase or 1)
                else
                    local file, sub = Lib.ZoneOf(s, src)
                    sub = Lib.SubAreaOf(t.entry, file, sub, src)
                    if not file then
                        note("Spawn ohne Zone verworfen: %d %s guid %d", t.entry, t.name, s.guid)
                    elseif not doneMap[file] then
                        doneMap[file] = true
                        local z = src.zones[file]
                        local x, y = Lib.ToMapXY(z, s.x, s.y)
                        if x <= 0 or x > 100 or y <= 0 or y > 100 then
                            note("Koordinate ausserhalb der Karte: %d %s %s %.1f %.1f", t.entry, t.name, file, x, y)
                        end
                        local row = {
                            id = t.entry, name = t.name, f = f, ranks = ranks,
                            map = file, x = x, y = y, area = sub, rep = rep,
                        }
                        if t.nameDe and t.nameDe ~= "" then row.nameDe = t.nameDe end
                        if #ranks == 0 then
                            row.spec = true
                            row.sub = t.sub
                            if t.subDe and t.subDe ~= "" then row.subDe = t.subDe end
                        end
                        local list = data.trainers[key]
                        list[#list + 1] = row
                        rows = rows + 1
                        data.zones[file] = {
                            c = z.c, en = z.en, de = z.de, capital = Lib.CAPITALS[file],
                        }
                        if sub then
                            local a = src.areas[sub]
                            data.areas[sub] = { en = a and a.en or "", de = a and a.de or "" }
                        end
                    end
                end
            end
            if rows == 0 then note("Lehrer ohne gueltigen Spawn: %d %s", t.entry, t.name) end
        end
    end

    -- Mindeststufe je Beruf und Rang (Schmiede/Juweliere: Grossmeister ab 60, sonst 65)
    for _, key in pairs(Lib.SKILL_KEY) do
        data.rankLevel[key] = {}
        local seen = levelsSeen[key] or {}
        for r = 1, 6 do
            local lv = seen[r] and sortedKeys(seen[r]) or {}
            if #lv > 1 then
                note("%s Rang %d: uneinheitliche ReqLevel %s, nehme %d", key, r, table.concat(lv, "/"), lv[1])
            end
            data.rankLevel[key][r] = lv[1] or 0
        end
    end

    for _, list in pairs(data.trainers) do
        table.sort(list, function(a, b)
            if a.id ~= b.id then return a.id < b.id end
            return a.map < b.map
        end)
    end
    return data, report
end

-- ---------------------------------------------------------------------------------------------
-- Deterministische Ausgabe
-- ---------------------------------------------------------------------------------------------

-- Lua-Stringliteral, nur ASCII (alles andere als \ddd)
function Lib.Quote(s)
    s = tostring(s)
    local out = { '"' }
    for i = 1, #s do
        local b = s:byte(i)
        if b == 34 then out[#out + 1] = '\\"'
        elseif b == 92 then out[#out + 1] = "\\\\"
        elseif b < 32 or b > 126 then out[#out + 1] = "\\" .. b
        else out[#out + 1] = string.char(b) end
    end
    out[#out + 1] = '"'
    return table.concat(out)
end
local Q = Lib.Quote

local function keyStr(k)
    if k:match("^[%a_][%w_]*$") then return k end
    return "[" .. Q(k) .. "]"
end

local TRAINER_FIELDS = { "id", "name", "nameDe", "f", "spec", "ranks", "sub", "subDe", "map", "x", "y", "area", "rep" }

local function fieldValue(name, v)
    if name == "ranks" then
        if #v == 0 then return "{}" end
        local p = {}
        for i, r in ipairs(v) do p[i] = tostring(r) end
        return "{ " .. table.concat(p, ", ") .. " }"
    elseif name == "x" or name == "y" then
        return string.format("%.1f", v)
    elseif type(v) == "string" then
        return Q(v)
    else
        return tostring(v)
    end
end

function Lib.Serialize(data)
    local L = {}
    local function add(s) L[#L + 1] = s end
    add("-- ProfessionPilot Professions/TrainerData.lua")
    add("-- Generiert von Tools/gen_trainers.lua aus Tools/data/trainer_source.lua - nicht von Hand aendern.")
    add("-- Quelle: TrinityCore-3.3.5-Welt-DB (Lehrer, Spawns, deDE-Namen) + Client-DBC/ADT (Zonen, Kartengrenzen).")
    add("-- f: A Allianz, H Horde, N neutral. ranks: 1 Lehrling .. 6 Grossmeister. x/y: Zonenprozent.")
    add("local PP = _G.ProfessionPilot")
    add("")
    add("PP.TrainerData = {")
    add("    rankLevel = {")
    for _, key in ipairs(sortedKeys(data.rankLevel)) do
        local lv = {}
        for r = 1, 6 do lv[r] = tostring(data.rankLevel[key][r] or 0) end
        add("        " .. key .. " = { " .. table.concat(lv, ", ") .. " },")
    end
    add("    },")
    add("    zones = {")
    for _, file in ipairs(sortedKeys(data.zones)) do
        local z = data.zones[file]
        local s = string.format("        %s = { c = %d, en = %s, de = %s", keyStr(file), z.c, Q(z.en), Q(z.de))
        if z.capital then s = s .. ", capital = " .. Q(z.capital) end
        add(s .. " },")
    end
    add("    },")
    add("    areas = {")
    for _, id in ipairs(sortedKeys(data.areas)) do
        local a = data.areas[id]
        add(string.format("        [%d] = { en = %s, de = %s },", id, Q(a.en), Q(a.de)))
    end
    add("    },")
    add("    trainers = {")
    for _, key in ipairs(sortedKeys(data.trainers)) do
        add("        " .. key .. " = {")
        for _, t in ipairs(data.trainers[key]) do
            local p = {}
            for _, name in ipairs(TRAINER_FIELDS) do
                local v = t[name]
                if v ~= nil then p[#p + 1] = name .. " = " .. fieldValue(name, v) end
            end
            add("            { " .. table.concat(p, ", ") .. " },")
        end
        add("        },")
    end
    add("    },")
    add("}")
    return table.concat(L, "\n") .. "\n"
end

return Lib
