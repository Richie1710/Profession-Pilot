-- ProfessionPilot Core/Stats.lua
-- Pure skill-up telemetry math: turns per-recipe observations collected by
-- Modules/SkillStats.lua ({ crafts = n, ups = n }) into refined "remaining
-- crafts" estimates. Guide values (step.estimatedCrafts) assume standard
-- 1x skill-up rates; private servers often deviate, so measured rates win
-- once enough data exists.
-- No WoW API calls, no saved state -- headless testable under plain Lua 5.1
-- (Tests/test_stats.lua), same contract as Core/Calc.lua.

local PP = _G.ProfessionPilot
local Stats = {}
PP.Stats = Stats

local ceil = math.ceil
local floor = math.floor
local max = math.max

-- Sample-size thresholds for RefinedRemaining's blend.
local MIN_SAMPLE = 5    -- below this many crafts the observation is ignored
local FULL_SAMPLE = 20  -- from here the measured rate replaces the guide value

-- Smoothed skill-up probability from an observation record { crafts, ups }.
-- Laplace smoothing -- (ups + 1) / (crafts + 2) -- keeps small samples from
-- swinging to the extremes (5 straight skill-ups is not proof of p = 1).
-- Returns nil when there is no usable observation (fewer than MIN_SAMPLE
-- crafts, or no record at all). Note p can reach or exceed 1 where +2
-- skill-up procs or boosted server rates make ups outrun crafts.
function Stats.ObservedRate(observed)
    if type(observed) ~= "table" then return nil end
    local crafts = observed.crafts or 0
    if crafts < MIN_SAMPLE then return nil end
    return ((observed.ups or 0) + 1) / (crafts + 2)
end

-- Remaining crafts to finish `step` from `skill`, refined by telemetry.
--   baseline: identical to Calc.GetRemainingCrafts -- the guide estimate
--             prorated linearly across the step's skill window.
--   refined:  remaining skill points / observed skill-up probability.
-- Blend by sample size: >= FULL_SAMPLE crafts trust the measurement alone,
-- >= MIN_SAMPLE average both estimates, anything less keeps the baseline.
-- Returns remaining, measured -- `measured` is true when observed data
-- actually influenced the number (so the UI can label it).
function Stats.RefinedRemaining(step, skill, observed)
    if skill >= step.maxSkill then return 0, false end

    local from = max(skill, step.minSkill)
    local span = step.maxSkill - step.minSkill
    local baseline = ceil(step.estimatedCrafts * (step.maxSkill - from) / span)

    local p = Stats.ObservedRate(observed)
    if not p then return baseline, false end

    -- p == 1 falls out naturally: ceil(points / 1) == points, one craft per
    -- skill point; p > 1 yields even fewer crafts.
    local refined = ceil((step.maxSkill - from) / p)

    if observed.crafts >= FULL_SAMPLE then
        return refined, true
    end
    return floor((baseline + refined) / 2 + 0.5), true
end

return Stats
