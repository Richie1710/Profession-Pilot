-- Tests for Core/Calc.lua: step status, current step, remaining crafts, needs.

local PP = _G.ProfessionPilot
local Calc = PP.Calc

local step = {
    minSkill = 51, maxSkill = 75, recipeSpellId = 3923, learnAtSkill = 30,
    estimatedCrafts = 30,
    materials = {
        { itemId = 2840, amount = 30 },
        { itemId = 4357, amount = 60, craftedBy = 3918 },
    },
}

-- GetCurrentStepIndex ------------------------------------------------------
T.eq(Calc.GetCurrentStepIndex({ step }, 50), 1, "skill below window -> step is next")
T.eq(Calc.GetCurrentStepIndex({ step }, 51), 1, "window start")
T.eq(Calc.GetCurrentStepIndex({ step }, 74), 1, "last point inside window")
T.eq(Calc.GetCurrentStepIndex({ step }, 75), nil, "maxSkill reached -> done")

local s1 = { minSkill = 1, maxSkill = 30, recipeSpellId = 3918, learnAtSkill = 1,
    estimatedCrafts = 30, materials = {} }
local p1 = { minSkill = 135, maxSkill = 150, recipeSpellId = 2, learnAtSkill = 125,
    estimatedCrafts = 30, materials = {} }
local p2 = { minSkill = 135, maxSkill = 150, recipeSpellId = 3, learnAtSkill = 125,
    estimatedCrafts = 15, materials = {} }
T.eq(Calc.GetCurrentStepIndex({ s1, p1, p2 }, 137), 2,
    "parallel window: first non-completed step wins")
T.eq(Calc.GetCurrentStepIndex({ s1, p1, p2 }, 150), nil, "all done at 150")

-- GetRemainingCrafts -------------------------------------------------------
T.eq(Calc.GetRemainingCrafts(step, 40), 30, "below window -> full amount")
T.eq(Calc.GetRemainingCrafts(step, 51), 30, "window start -> full amount")
T.eq(Calc.GetRemainingCrafts(step, 63), 15, "midpoint -> half")
T.eq(Calc.GetRemainingCrafts(step, 74), 2, "ceil(30*1/24) = 2")
T.eq(Calc.GetRemainingCrafts(step, 75), 0, "done -> 0")
T.eq(Calc.GetRemainingCrafts(step, 80), 0, "past window -> 0")

local one = { minSkill = 50, maxSkill = 51, recipeSpellId = 7430, learnAtSkill = 50,
    estimatedCrafts = 1, materials = { { itemId = 2840, amount = 6 } } }
T.eq(Calc.GetRemainingCrafts(one, 50), 1, "1-point window full")
T.eq(Calc.GetRemainingCrafts(one, 51), 0, "1-point window done")

-- GetStepMaterialNeeds -----------------------------------------------------
local needs = Calc.GetStepMaterialNeeds(step, 63)
T.eq(#needs, 2, "two materials")
T.eq(needs[1].itemId, 2840, "material 1 id")
T.eq(needs[1].need, 15, "15 crafts x 1 copper")
T.eq(needs[2].need, 30, "15 crafts x 2 powder")
T.eq(needs[2].craftedBy, 3918, "craftedBy carried through")
T.eq(#Calc.GetStepMaterialNeeds(step, 75), 0, "no needs when completed")

-- GetStepStatus ------------------------------------------------------------
local st, fl = Calc.GetStepStatus(step, { skill = 75, cap = 150, known = {}, counts = {} })
T.eq(st, "completed", "status completed at maxSkill")

st, fl = Calc.GetStepStatus(step, { skill = 60, cap = 150, known = {}, counts = {} })
T.eq(st, "upcoming", "status upcoming (caller assigns current)")
T.eq(fl.recipeKnown, false, "recipe unknown")
T.eq(fl.recipeLearnable, true, "learnable at 60 (learnAt 30)")
T.eq(fl.rankBlocked, false, "cap 150 does not block 51-75")
T.eq(fl.matsMissing, true, "empty bags -> mats missing")

st, fl = Calc.GetStepStatus(step, { skill = 60, cap = 75, known = { [3923] = true },
    counts = { [2840] = { bags = 30, bank = 0 }, [4357] = { bags = 60, bank = 0 } } })
T.eq(fl.recipeKnown, true, "recipe known")
T.eq(fl.matsMissing, false, "full bags -> nothing missing")

st, fl = Calc.GetStepStatus(step, { skill = 20, cap = 75, known = {}, counts = {} })
T.eq(fl.recipeLearnable, false, "not learnable at 20")

local late = { minSkill = 300, maxSkill = 320, recipeSpellId = 30305, learnAtSkill = 300,
    estimatedCrafts = 40, materials = {} }
st, fl = Calc.GetStepStatus(late, { skill = 290, cap = 300, known = {}, counts = {} })
T.eq(fl.rankBlocked, true, "cap 300 blocks step starting at 300")
st, fl = Calc.GetStepStatus(late, { skill = 290, cap = 375, known = {}, counts = {} })
T.eq(fl.rankBlocked, false, "cap 375 unblocks")

-- bank handling in matsMissing
local bctx = { skill = 60, cap = 150, known = {}, includeBank = true,
    counts = { [2840] = { bags = 0, bank = 30 }, [4357] = { bags = 0, bank = 60 } } }
st, fl = Calc.GetStepStatus(step, bctx)
T.eq(fl.matsMissing, false, "bank counts included when includeBank")
bctx.includeBank = false
st, fl = Calc.GetStepStatus(step, bctx)
T.eq(fl.matsMissing, true, "bank ignored when not includeBank")

-- Registry -----------------------------------------------------------------
local prof = {
    key = "test", professionSpellId = 4036, maxSkill = 450,
    ranks = { 75, 150, 225, 300, 375, 450 },
    steps = { s1, step },
}
PP:RegisterProfession(prof)
T.eq(PP:GetProfession("test"), prof, "registry returns registered profession")
T.ok(PP:GetProfessions()["test"], "registry lists professions")

T.err(function()
    PP:RegisterProfession({ key = "bad1", professionSpellId = 1, maxSkill = 450,
        ranks = {}, steps = { step, s1 } })
end, "unsorted steps rejected")

T.err(function()
    PP:RegisterProfession({ key = "bad2", professionSpellId = 1, maxSkill = 450,
        ranks = {}, steps = { { minSkill = 1, maxSkill = 30, recipeSpellId = 9,
            learnAtSkill = 1, estimatedCrafts = 7,
            materials = { { itemId = 5, amount = 10 } } } } })
end, "non-integral per-craft amount rejected")

T.err(function()
    PP:RegisterProfession({ key = "bad3", professionSpellId = 1, maxSkill = 450,
        ranks = {}, steps = { { minSkill = 1, maxSkill = 30, recipeSpellId = 9,
            learnAtSkill = 1, estimatedCrafts = 10,
            materials = { { itemId = 5, amount = 10, craftedBy = 999 } } } } })
end, "craftedBy without producing step rejected")
