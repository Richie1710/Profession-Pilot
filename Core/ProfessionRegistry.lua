-- ProfessionPilot Core/ProfessionRegistry.lua
-- Registration point for profession data modules. Pure Lua (headless testable).
-- Validation runs at registration so broken static data fails loudly in tests
-- instead of producing silent nonsense in game.

local PP = _G.ProfessionPilot

local professions = {}

local function validateStep(profKey, index, step, producers)
    local where = ("profession '%s' step %d"):format(profKey, index)
    assert(type(step.minSkill) == "number" and type(step.maxSkill) == "number"
        and step.minSkill < step.maxSkill, where .. ": invalid skill window")
    assert(type(step.recipeSpellId) == "number", where .. ": missing recipeSpellId")
    assert(type(step.learnAtSkill) == "number", where .. ": missing learnAtSkill")
    assert(type(step.estimatedCrafts) == "number" and step.estimatedCrafts > 0,
        where .. ": invalid estimatedCrafts")
    assert(type(step.materials) == "table", where .. ": missing materials")

    for i = 1, #step.materials do
        local m = step.materials[i]
        assert(type(m.itemId) == "number" and type(m.amount) == "number",
            where .. (": material %d malformed"):format(i))
        assert(m.amount % step.estimatedCrafts == 0,
            where .. (": material %d amount %d not divisible by %d crafts")
            :format(i, m.amount, step.estimatedCrafts))
        if m.craftedBy then
            assert(producers[m.craftedBy],
                where .. (": material %d craftedBy %d has no earlier producing step")
                :format(i, m.craftedBy))
        end
    end
end

function PP:RegisterProfession(prof)
    assert(type(prof) == "table" and type(prof.key) == "string",
        "RegisterProfession: profession table with string key required")
    assert(type(prof.professionSpellId) == "number",
        "RegisterProfession: professionSpellId required")
    assert(type(prof.steps) == "table" and #prof.steps > 0,
        "RegisterProfession: steps required")

    local producers = {}
    local lastMin = -1
    for i = 1, #prof.steps do
        local step = prof.steps[i]
        assert(step.minSkill >= lastMin,
            ("profession '%s': steps not sorted at index %d"):format(prof.key, i))
        lastMin = step.minSkill
        validateStep(prof.key, i, step, producers)
        producers[step.recipeSpellId] = step
    end

    prof.producers = producers
    professions[prof.key] = prof
    return prof
end

function PP:GetProfession(key)
    return professions[key]
end

function PP:GetProfessions()
    return professions
end
