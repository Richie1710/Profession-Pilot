-- ProfessionPilot Tools/gen_trainers.lua (Lua 5.1)
-- Erzeugt Professions/TrainerData.lua aus Tools/data/trainer_source.lua.
--
--   lua5.1 Tools/gen_trainers.lua [source] [out]
--
-- Defaults: Tools/data/trainer_source.lua -> Professions/TrainerData.lua (Pfade relativ zu
-- diesem Skript, das Arbeitsverzeichnis ist egal). Meldungen (ausgeschlossene Platzhalter,
-- verworfene Spawns, ...) gehen auf stderr.

local toolsDir = (arg and arg[0] or ""):match("^(.*)[/\\]") or "."
local Lib = dofile(toolsDir .. "/trainer_gen_lib.lua")

local srcPath = arg[1] or (toolsDir .. "/data/trainer_source.lua")
local outPath = arg[2] or (toolsDir .. "/../Professions/TrainerData.lua")

local src = dofile(srcPath)
local data, report = Lib.Build(src)
for _, line in ipairs(report) do io.stderr:write(line, "\n") end

local text = Lib.Serialize(data)
local f = assert(io.open(outPath, "wb"))
f:write(text)
f:close()

local total = 0
local parts = {}
local keys = {}
for key in pairs(data.trainers) do keys[#keys + 1] = key end
table.sort(keys)
for _, key in ipairs(keys) do
    total = total + #data.trainers[key]
    parts[#parts + 1] = key .. " " .. #data.trainers[key]
end
io.stderr:write(string.format("TrainerData: %d Eintraege (%s) -> %s\n", total, table.concat(parts, ", "), outPath))
