-- Tests for RosterStore.Aggregate (pure aggregation over the
-- db.global.roster shape) plus the GetOthers wrapper under stubbed WoW API.
-- The module file is runtime code, so it is loaded here under local stubs;
-- wow_stubs.lua stays untouched.

local PP = _G.ProfessionPilot

-- Local stub extension: minimal AceAddon-style NewModule so the module file
-- can be dofile'd headless. Mixin names ("AceEvent-3.0") are ignored; the
-- Register* methods the module calls in OnEnable are no-ops (OnEnable is
-- never invoked here, but the stubs keep the table safe to poke).
PP.NewModule = function(self, name)
    local m = {
        RegisterEvent = function() end,
        RegisterMessage = function() end,
        RegisterBucketEvent = function() end,
    }
    PP._lastModule = m
    return m
end

-- WoW API the module touches at runtime (never inside Aggregate).
_G.UnitName = function() return "Testchar" end
_G.GetRealmName = function() return "TestRealm" end
_G.time = os.time

local testDir = ((arg and arg[0] or ""):match("^(.*)[/\\]") or ".")
dofile(testDir .. "/../Modules/RosterStore.lua")

local RosterStore = PP._lastModule
local Aggregate = RosterStore and RosterStore.Aggregate

T.ok(type(Aggregate) == "function", "roster: Aggregate exported on module")
if type(Aggregate) ~= "function" then return end

local SELF = "Testchar - TestRealm"

-- Fixture: own char owns plenty (must never count), three valid alts, one
-- cross-realm alt, plus zero/empty/malformed entries that must be skipped.
local roster = {
    ["Testchar - TestRealm"]    = { counts = { [2835] = 99, [7777] = 123 },
                                    updated = 1000 },
    ["Bankalt - TestRealm"]     = { counts = { [2835] = 40, [2589] = 10 },
                                    updated = 1000 },
    ["Miner - TestRealm"]       = { counts = { [2835] = 60 }, updated = 1000 },
    ["Crossrealm - OtherRealm"] = { counts = { [2835] = 5 }, updated = 1000 },
    ["Zeroguy - TestRealm"]     = { counts = { [2835] = 0 }, updated = 1000 },
    ["Emptyalt - TestRealm"]    = { counts = {}, updated = 1000 },
    ["Broken - TestRealm"]      = { updated = 1000 },  -- no counts table
    ["Garbage - TestRealm"]     = true,                -- not even a table
}

-- Sums others, excludes the own character, skips zero counts.
local total, breakdown = Aggregate(roster, SELF, 2835)
T.eq(total, 105, "roster: total sums the other characters only")
T.eq(#breakdown, 3, "roster: one breakdown row per alt with count > 0")

-- Sorted descending by count; names are raw roster keys at this layer.
T.eq(breakdown[1].name, "Miner - TestRealm", "roster: biggest stack first")
T.eq(breakdown[1].count, 60, "roster: biggest count value")
T.eq(breakdown[2].name, "Bankalt - TestRealm", "roster: middle stack second")
T.eq(breakdown[2].count, 40, "roster: middle count value")
T.eq(breakdown[3].name, "Crossrealm - OtherRealm", "roster: smallest last")
T.eq(breakdown[3].count, 5, "roster: smallest count value")

-- Single owner elsewhere.
total, breakdown = Aggregate(roster, SELF, 2589)
T.eq(total, 10, "roster: single-owner total")
T.eq(#breakdown, 1, "roster: single-owner breakdown length")
T.eq(breakdown[1].name, "Bankalt - TestRealm", "roster: single-owner name")

-- Item only the player owns -> nothing from others.
total, breakdown = Aggregate(roster, SELF, 7777)
T.eq(total, 0, "roster: own-only item totals 0")
T.eq(breakdown, nil, "roster: own-only item has no breakdown")

-- Item nobody owns.
total, breakdown = Aggregate(roster, SELF, 4242)
T.eq(total, 0, "roster: unknown item totals 0")
T.eq(breakdown, nil, "roster: unknown item has no breakdown")

-- Empty / absent roster -> 0, nil.
total, breakdown = Aggregate({}, SELF, 2835)
T.eq(total, 0, "roster: empty roster totals 0")
T.eq(breakdown, nil, "roster: empty roster has no breakdown")
total, breakdown = Aggregate(nil, SELF, 2835)
T.eq(total, 0, "roster: nil roster totals 0")
T.eq(breakdown, nil, "roster: nil roster has no breakdown")

-- Roster containing only the own character -> 0, nil.
total, breakdown = Aggregate(
    { [SELF] = { counts = { [2835] = 99 }, updated = 1 } }, SELF, 2835)
T.eq(total, 0, "roster: self-only roster totals 0")
T.eq(breakdown, nil, "roster: self-only roster has no breakdown")

-- Equal counts tie-break deterministically by name ascending.
local tieRoster = {
    ["Bbb - R"] = { counts = { [42] = 7 } },
    ["Aaa - R"] = { counts = { [42] = 7 } },
    ["Ccc - R"] = { counts = { [42] = 9 } },
}
total, breakdown = Aggregate(tieRoster, "Zzz - R", 42)
T.eq(total, 23, "roster: tie fixture total")
T.eq(breakdown[1].name, "Ccc - R", "roster: highest count still first")
T.eq(breakdown[2].name, "Aaa - R", "roster: tie broken by name ascending")
T.eq(breakdown[3].name, "Bbb - R", "roster: tie loser last")

-- GetOthers: guarded when no db exists (headless / pre-OnInitialize).
local savedDb = PP.db
PP.db = nil
total, breakdown = RosterStore:GetOthers(2835)
T.eq(total, 0, "roster: GetOthers without db totals 0")
T.eq(breakdown, nil, "roster: GetOthers without db has no breakdown")

-- GetOthers with a stubbed db: same aggregation, names shortened for the
-- player's own realm, foreign realms kept fully qualified.
PP.db = { global = { roster = roster } }
total, breakdown = RosterStore:GetOthers(2835)
T.eq(total, 105, "roster: GetOthers total matches Aggregate")
T.eq(breakdown[1].name, "Miner", "roster: same-realm name shortened")
T.eq(breakdown[2].name, "Bankalt", "roster: second same-realm name shortened")
T.eq(breakdown[3].name, "Crossrealm - OtherRealm",
    "roster: foreign realm kept in full")
PP.db = savedDb
