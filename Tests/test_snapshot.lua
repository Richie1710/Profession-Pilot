-- End-to-end scenarios over the full Engineering data: the same ctx
-- combinations Core:Recompute feeds into Calc, checked at skill milestones.

local PP = _G.ProfessionPilot
local Calc = PP.Calc
local eng = PP:GetProfession("engineering")
local steps = eng.steps

local function ctx(skill, cap, known, counts, includeBank)
    return { skill = skill, cap = cap, known = known or {},
        counts = counts or {}, includeBank = includeBank, maxSkill = 450 }
end

-- Fresh character, skill 1, cap 75 (Apprentice).
local c = ctx(1, 75)
T.eq(Calc.GetCurrentStepIndex(steps, 1), 1, "skill 1 -> first step")
T.eq(Calc.GetRemainingCrafts(steps[1], 1), 60, "skill 1 -> full 60 powders")
local st, fl = Calc.GetStepStatus(steps[1], c)
T.eq(st, "upcoming", "step 1 not completed at skill 1")
T.eq(fl.rankBlocked, false, "step 1 not rank blocked at cap 75")
st, fl = Calc.GetStepStatus(steps[5], c)  -- 75-90 needs Journeyman
T.eq(fl.rankBlocked, true, "step 5 rank blocked at cap 75")

-- Mid-window inside the parallel 135-150 pair, cap 225.
c = ctx(137, 225)
T.eq(Calc.GetCurrentStepIndex(steps, 137), 10, "137 -> heavy blasting powder")
T.eq(Calc.GetRemainingCrafts(steps[10], 137), 26, "ceil(30*13/15) = 26")
st = Calc.GetStepStatus(steps[11], c)
T.eq(st, "upcoming", "parallel gizmo step waits its turn")
st = Calc.GetStepStatus(steps[9], c)
T.eq(st, "completed", "scope step done at 137")

-- Exact section boundary 200 (Artisan freshly learned, cap 300).
c = ctx(200, 300)
T.eq(Calc.GetCurrentStepIndex(steps, 200), 17, "200 -> unstable trigger")
st, fl = Calc.GetStepStatus(steps[16], c)
T.eq(st, "completed", "mithril tube step completed exactly at 200")
st, fl = Calc.GetStepStatus(steps[17], c)
T.eq(fl.rankBlocked, false, "trigger step open with cap 300")

-- Same boundary but rank cap still 200: everything further is blocked.
c = ctx(200, 200)
st, fl = Calc.GetStepStatus(steps[17], c)
T.eq(fl.rankBlocked, true, "trigger step blocked at cap 200")

-- Vendor recipe status at 340 with nothing known.
c = ctx(340, 375)
st, fl = Calc.GetStepStatus(steps[28], c)
T.eq(steps[28].source, "vendor", "step 28 is the vendor recipe")
T.eq(fl.recipeKnown, false, "flare unknown")
T.eq(fl.recipeLearnable, true, "flare learnable at 340")

-- Known recipes reflected.
c = ctx(340, 375, { [30341] = true })
st, fl = Calc.GetStepStatus(steps[28], c)
T.eq(fl.recipeKnown, true, "flare known when cached")

-- 449: two army knives to go; 450: done.
c = ctx(449, 450)
T.eq(Calc.GetCurrentStepIndex(steps, 449), 40, "449 -> army knife step")
T.eq(Calc.GetRemainingCrafts(steps[40], 449), 2, "2 crafts left at 449")
local needs = Calc.GetStepMaterialNeeds(steps[40], 449)
T.eq(needs[1].need, 20, "20 saronite at 449")
T.eq(Calc.GetCurrentStepIndex(steps, 450), nil, "450 -> path complete")

-- Materials complete vs missing on the current step with full bags.
c = ctx(1, 75, {}, { [2835] = { bags = 60, bank = 0 } })
st, fl = Calc.GetStepStatus(steps[1], c)
T.eq(fl.matsMissing, false, "60 rough stones satisfy step 1")
c = ctx(1, 75, {}, { [2835] = { bags = 59, bank = 0 } })
st, fl = Calc.GetStepStatus(steps[1], c)
T.eq(fl.matsMissing, true, "59 rough stones do not")

-- Bank-only stock respects the includeBank switch.
c = ctx(1, 75, {}, { [2835] = { bags = 0, bank = 60 } }, true)
st, fl = Calc.GetStepStatus(steps[1], c)
T.eq(fl.matsMissing, false, "bank stone counts when enabled")
c = ctx(1, 75, {}, { [2835] = { bags = 0, bank = 60 } }, false)
st, fl = Calc.GetStepStatus(steps[1], c)
T.eq(fl.matsMissing, true, "bank stone ignored when disabled")

-- Aggregate at a boundary honors toSkill (current section only view).
local r = Calc.AggregateMaterials(eng, ctx(200, 300), { toSkill = 215 })
local mithril
for _, e in ipairs(r.entries) do
    if e.itemId == 3860 then mithril = e end
end
T.eq(mithril and mithril.need, 20, "section-only aggregate: trigger mithril only")
