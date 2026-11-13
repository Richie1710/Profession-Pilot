-- ProfessionPilot headless test runner (Lua 5.1).
-- Usage: lua5.1 run_tests.lua            -- run full manifest
--        lua5.1 run_tests.lua test_calc  -- run single file (without .lua)

local scriptDir = arg[0]:match("^(.*)[/\\]") or "."

local MANIFEST = {
    "test_calc",
    "test_advisor",
    "test_stats",
    "test_engineering_data",
    "test_tailoring_data",
    "test_leatherworking_data",
    "test_jewelcrafting_data",
    "test_alchemy_data",
    "test_blacksmithing_data",
    "test_enchanting_data",
    "test_inscription_data",
    "test_smelting",
    "test_aggregate",
    "test_tree",
    "test_queue",
    "test_shopping",
    "test_parsers",
    "test_snapshot",
    "test_roster",
    "test_crafter",
    "test_recipetracker",
    "test_pricesource",
    "test_merchantbuyer",
    "test_materialplan",
    "test_publicapi",
    "test_materialtracker",
    "test_load_all",
}

dofile(scriptDir .. "/wow_stubs.lua")

local T = { pass = 0, fail = 0, current = "?" }
_G.T = T

local function report(ok, label, detail)
    if ok then
        T.pass = T.pass + 1
    else
        T.fail = T.fail + 1
        print(string.format("FAIL [%s] %s%s", T.current, label or "?", detail or ""))
    end
end

function T.eq(actual, expected, label)
    local ok = actual == expected
    report(ok, label, ok and "" or string.format(" (expected %s, got %s)",
        tostring(expected), tostring(actual)))
end

function T.ok(value, label)
    report(not not value, label, "")
end

function T.err(fn, label)
    local ok = pcall(fn)
    report(not ok, label, ok and " (expected error, got none)" or "")
end

-- Load production code under test (pure files only).
local CODE = {
    "/../Core/Calc.lua",
    "/../Core/MaterialPlan.lua",
    "/../Core/Advisor.lua",
    "/../Core/Queue.lua",
    "/../Core/Shopping.lua",
    "/../Core/Stats.lua",
    "/../Core/SmeltData.lua",
    "/../Core/ProfessionRegistry.lua",
    "/../Professions/Engineering.lua",
    "/../Professions/Tailoring.lua",
    "/../Professions/Leatherworking.lua",
    "/../Professions/Jewelcrafting.lua",
    "/../Professions/Alchemy.lua",
    "/../Professions/Blacksmithing.lua",
    "/../Professions/Enchanting.lua",
    "/../Professions/Inscription.lua",
}
for _, rel in ipairs(CODE) do
    local ok, err = pcall(dofile, scriptDir .. rel)
    if not ok then
        print("LOAD FAIL: " .. rel .. " -> " .. tostring(err))
        os.exit(1)
    end
end

local files = {}
if arg[1] then
    files[1] = arg[1]
else
    for i, name in ipairs(MANIFEST) do files[i] = name end
end

for _, name in ipairs(files) do
    T.current = name
    local ok, err = pcall(dofile, scriptDir .. "/" .. name .. ".lua")
    if not ok then
        T.fail = T.fail + 1
        print("ERROR [" .. name .. "] " .. tostring(err))
    end
end

print(string.format("Tests: %d passed, %d failed", T.pass, T.fail))
os.exit(T.fail == 0 and 0 or 1)
