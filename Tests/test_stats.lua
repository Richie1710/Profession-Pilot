-- Tests for Core/Stats.lua: Laplace smoothing, sample-size blending and
-- agreement with Calc.GetRemainingCrafts' linear baseline.

local PP = _G.ProfessionPilot
local Stats = PP.Stats
local Calc = PP.Calc

-- Same shape as the test_calc step: window 51-75 (span 24), 30 estimated
-- crafts, so the guide's implied rate is 24/30 = 0.8 ups per craft.
local step = {
    minSkill = 51, maxSkill = 75, recipeSpellId = 3923, learnAtSkill = 30,
    estimatedCrafts = 30,
    materials = { { itemId = 2840, amount = 30 } },
}

-- ObservedRate --------------------------------------------------------------
T.eq(Stats.ObservedRate(nil), nil, "nil observed -> nil")
T.eq(Stats.ObservedRate({}), nil, "empty observed -> nil")
T.eq(Stats.ObservedRate({ crafts = 4, ups = 4 }), nil, "crafts < 5 -> nil")
T.eq(Stats.ObservedRate({ crafts = 5, ups = 0 }), 1 / 7,
    "Laplace smoothing: (0+1)/(5+2)")
T.eq(Stats.ObservedRate({ crafts = 5 }), 1 / 7, "missing ups counts as 0")
T.eq(Stats.ObservedRate({ crafts = 10, ups = 4 }), 5 / 12,
    "Laplace smoothing: (4+1)/(10+2)")
T.eq(Stats.ObservedRate({ crafts = 98, ups = 49 }), 0.5,
    "large sample approaches the raw rate")
T.eq(Stats.ObservedRate({ crafts = 8, ups = 9 }), 1,
    "+2 procs can push the smoothed rate to 1")

-- RefinedRemaining: no / insufficient data -> baseline -----------------------
local r, m = Stats.RefinedRemaining(step, 63, nil)
T.eq(r, Calc.GetRemainingCrafts(step, 63), "no data -> matches Calc baseline")
T.eq(r, 15, "baseline at midpoint = 15")
T.eq(m, false, "no data -> not measured")

r, m = Stats.RefinedRemaining(step, 63, { crafts = 4, ups = 1 })
T.eq(r, 15, "crafts < 5 -> baseline")
T.eq(m, false, "crafts < 5 -> not measured")

r = Stats.RefinedRemaining(step, 40, nil)
T.eq(r, Calc.GetRemainingCrafts(step, 40), "below window -> Calc baseline")
T.eq(r, 30, "below window -> full guide estimate")

-- RefinedRemaining: window end ------------------------------------------------
r, m = Stats.RefinedRemaining(step, 75, { crafts = 50, ups = 25 })
T.eq(r, 0, "skill at window end -> 0")
T.eq(m, false, "completed step -> not measured")
T.eq(Stats.RefinedRemaining(step, 80, { crafts = 50, ups = 25 }), 0,
    "past window -> 0")

-- RefinedRemaining: full sample (>= 20 crafts) -> pure refined ----------------
-- p = (18+1)/(38+2) = 0.475; points = 75-63 = 12; ceil(12/0.475) = 26
r, m = Stats.RefinedRemaining(step, 63, { crafts = 38, ups = 18 })
T.eq(r, 26, "full sample -> refined only (26, not baseline 15)")
T.eq(m, true, "full sample -> measured")

-- p = 1 fast path: exactly one craft per remaining skill point
-- p = (29+1)/(28+2) = 1; points = 12; ceil(12/1) = 12
r, m = Stats.RefinedRemaining(step, 63, { crafts = 28, ups = 29 })
T.eq(r, 12, "p = 1 -> remaining crafts == remaining points")
T.eq(m, true, "p = 1 path is measured")

-- clamping below the window still applies with data
-- p = (10+1)/(20+2) = 0.5; points clamp to 75-51 = 24; 24/0.5 = 48
r, m = Stats.RefinedRemaining(step, 40, { crafts = 20, ups = 10 })
T.eq(r, 48, "clamped remaining points divided by measured rate")
T.eq(m, true, "clamped case still measured")

-- RefinedRemaining: blend zone (5 <= crafts < 20) -----------------------------
-- p = 5/12; refined = ceil(12/(5/12)) = ceil(28.8) = 29; round((15+29)/2) = 22
r, m = Stats.RefinedRemaining(step, 63, { crafts = 10, ups = 4 })
T.eq(r, 22, "blend: round((baseline 15 + refined 29)/2) = 22")
T.eq(m, true, "blend -> measured")

-- blend with an optimistic small sample refines DOWNWARD too
-- p = (5+1)/(5+2) = 6/7; refined = ceil(12/(6/7)) = 14; round((15+14)/2) = 15
r, m = Stats.RefinedRemaining(step, 63, { crafts = 5, ups = 5 })
T.eq(r, 15, "blend rounds (15+14)/2 = 14.5 up to 15")
T.eq(m, true, "minimal sample -> measured")
