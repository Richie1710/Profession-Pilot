-- Syntax-loads (loadfile, no execution) every Lua file referenced in the TOC
-- plus catches TOC references to missing files. Modules/ and UI/ files touch
-- WoW API at file scope and cannot be executed headless; parsing them under
-- real Lua 5.1 still guards against syntax regressions and 5.2+ constructs.

local root = ((arg and arg[0] or ""):match("^(.*)[/\\]") or ".") .. "/.."

local toc = io.open(root .. "/ProfessionPilot.toc", "r")
T.ok(toc ~= nil, "ProfessionPilot.toc opens")
if not toc then return end

local count = 0
for line in toc:lines() do
    line = line:gsub("%s+$", ""):gsub("^%s+", "")
    if line ~= "" and not line:match("^##") and line:match("%.lua$") then
        local path = root .. "/" .. line:gsub("\\", "/")
        local chunk, err = loadfile(path)
        T.ok(chunk ~= nil, "parses: " .. line
            .. (chunk and "" or (" -> " .. tostring(err))))
        count = count + 1
    end
end
toc:close()

T.eq(count, 33, "all 33 addon Lua files listed in TOC")
