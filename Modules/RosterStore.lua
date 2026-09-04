-- ProfessionPilot Modules/RosterStore.lua
-- Account-wide material roster (ALT ROSTER): persists each character's total
-- material counts (bags + cached bank, from PP.counts) into db.global.roster
-- so the shopping list can show what the player's other characters already
-- own. Self-contained -- no Altoholic or other inventory addon required.
--
-- Freshness: an entry is only as current as that character's last login; its
-- bank portion only as current as that character's last bank visit (it rides
-- on MaterialTracker's db.char.bankCounts cache).
--
-- Storage shape:
--   PP.db.global.roster["Name - Realm"] = {
--       counts = { [itemId] = total },   -- bags + bank, tracked items > 0
--       updated = time(),
--   }

local PP = _G.ProfessionPilot
local RosterStore = PP:NewModule("RosterStore", "AceEvent-3.0")

local PRUNE_AGE = 90 * 24 * 60 * 60   -- drop entries not updated for 90 days

-- "Name - Realm" identity of the logged-in character.
local function charKey()
    local name = UnitName("player")
    local realm = GetRealmName()
    if not name or name == "" or not realm then return nil end
    return name .. " - " .. realm
end

-- Display helper: strip the realm suffix when it matches the player's realm.
local function shortName(key, playerRealm)
    local name, realm = key:match("^(.-) %- (.+)$")
    if name and realm == playerRealm then return name end
    return key
end

-- Order-independent checksum over a totals table. Cheap change detection so
-- the frequent PP_SNAPSHOT trigger does not rewrite SavedVariables when
-- nothing changed. Exact within Lua's double range for any realistic bags.
local function checksum(totals)
    local sum = 0
    for itemId, n in pairs(totals) do
        sum = sum + itemId * 1000003 + n
    end
    return sum
end

-- Pure aggregation (headless-tested, no WoW API): sums `itemId` over every
-- roster entry EXCEPT `selfKey`. Returns total, breakdown where breakdown is
-- an array of { name = rosterKey, count = n } sorted by count descending
-- (name ascending on ties), or nil when the total is 0. Malformed roster
-- entries are skipped. Callers shorten `name` for display themselves.
function RosterStore.Aggregate(roster, selfKey, itemId)
    if type(roster) ~= "table" or not itemId then return 0, nil end
    local total, breakdown = 0, {}
    for key, entry in pairs(roster) do
        if key ~= selfKey and type(entry) == "table"
            and type(entry.counts) == "table" then
            local n = entry.counts[itemId]
            if type(n) == "number" and n > 0 then
                total = total + n
                breakdown[#breakdown + 1] = { name = key, count = n }
            end
        end
    end
    if total == 0 then return 0, nil end
    table.sort(breakdown, function(a, b)
        if a.count ~= b.count then return a.count > b.count end
        return a.name < b.name
    end)
    return total, breakdown
end

-- db.global.roster accessor; creates the subtable when the AceDB defaults do
-- not declare it (AceDB always provides the global section). nil before init.
local function rosterTable()
    local db = PP.db
    if not db or not db.global then return nil end
    if not db.global.roster then db.global.roster = {} end
    return db.global.roster
end

function RosterStore:OnEnable()
    self.lastChecksum = nil
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnEnteringWorld")
    -- Cheap trigger: PP_SNAPSHOT fires after every MaterialTracker publish
    -- (and other recomputes); PersistCounts skips unchanged writes.
    self:RegisterMessage("PP_SNAPSHOT", "OnSnapshot")
end

function RosterStore:OnEnteringWorld()
    if not self.prunedThisSession then
        self.prunedThisSession = true
        self:Prune()
    end
    -- Force one write per session even with unchanged counts so `updated`
    -- stays fresh for characters that log in but never loot anything.
    self.lastChecksum = nil
    self:PersistCounts()
end

function RosterStore:OnSnapshot()
    self:PersistCounts()
end

-- Write this character's bags+bank totals into the roster -- only when they
-- actually changed since the last write (checksum throttle).
function RosterStore:PersistCounts()
    local roster = rosterTable()
    local key = charKey()
    if not roster or not key then return end

    local totals = {}
    for itemId, c in pairs(PP.counts or {}) do
        local n = (c.bags or 0) + (c.bank or 0)
        if n > 0 then totals[itemId] = n end
    end

    local sum = checksum(totals)
    if sum == self.lastChecksum then return end
    self.lastChecksum = sum

    roster[key] = { counts = totals, updated = time() }
    PP:Debug("RosterStore: persisted counts for", key)
end

-- Drop roster entries older than PRUNE_AGE (plus malformed ones); the own
-- character is rewritten right afterwards by the login persist.
function RosterStore:Prune()
    local roster = rosterTable()
    if not roster then return end
    local cutoff = time() - PRUNE_AGE
    local stale = {}
    for key, entry in pairs(roster) do
        if type(entry) ~= "table" or type(entry.updated) ~= "number"
            or entry.updated < cutoff then
            stale[#stale + 1] = key
        end
    end
    for i = 1, #stale do
        roster[stale[i]] = nil
        PP:Debug("RosterStore: pruned stale entry", stale[i])
    end
end

-- How much of `itemId` the player's OTHER characters own. Returns
-- total, breakdown; breakdown = array of { name, count } sorted descending,
-- realm stripped from names on the player's own realm; 0, nil when none.
function RosterStore:GetOthers(itemId)
    local roster = rosterTable()
    if not roster then return 0, nil end
    local total, breakdown = RosterStore.Aggregate(roster, charKey(), itemId)
    if breakdown then
        local playerRealm = GetRealmName()
        for i = 1, #breakdown do
            breakdown[i].name = shortName(breakdown[i].name, playerRealm)
        end
    end
    return total, breakdown
end
