-- ProfessionPilot Modules/MaterialTracker.lua
-- Tracks how many of each relevant material the character owns. Bags are
-- scanned live (bucketed BAG_UPDATE); the bank is only readable while open,
-- so its contents are cached in db.char.bankCounts across sessions.

local PP = _G.ProfessionPilot
local MaterialTracker = PP:NewModule("MaterialTracker", "AceEvent-3.0", "AceBucket-3.0")

local BANK_CONTAINER_ID = -1  -- BANK_CONTAINER constant in 3.3.5a

-- Set of item ids worth counting (all step materials of all professions).
local interest = {}

local function buildInterest()
    for _, prof in pairs(PP:GetProfessions()) do
        for _, step in ipairs(prof.steps) do
            for _, m in ipairs(step.materials) do
                interest[m.itemId] = true
            end
        end
    end
end

function MaterialTracker:OnEnable()
    buildInterest()
    self.bagCounts = {}
    self.bankOpen = false
    -- Oeffentliche API (PP:GetMaterialPlan): Taschenzahlen gelten erst nach dem
    -- ersten FullScan seit dem letzten Ladescreen als gelesen.
    PP.state.countsReady = false

    self:RegisterBucketEvent("BAG_UPDATE", 0.3, "OnBagUpdate")
    -- Fires only while the bank is open; safe to keep registered permanently.
    self:RegisterBucketEvent("PLAYERBANKSLOTS_CHANGED", 0.3, "OnBankSlotsChanged")
    self:RegisterEvent("PLAYER_LEAVING_WORLD", "OnLeavingWorld")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "FullScan")
    self:RegisterEvent("BANKFRAME_OPENED")
    self:RegisterEvent("BANKFRAME_CLOSED")
    self:RegisterMessage("PP_FORCE_SCAN", "FullScan")
end

local function scanContainer(bag, into)
    for slot = 1, GetContainerNumSlots(bag) do
        local link = GetContainerItemLink(bag, slot)
        if link then
            local itemId = PP.util.ItemIdFromLink(link)
            if itemId and interest[itemId] then
                local _, count = GetContainerItemInfo(bag, slot)
                into[itemId] = (into[itemId] or 0) + (count or 1)
            end
        end
    end
end

-- Merge live bag counts and cached bank counts into PP.counts.
function MaterialTracker:Publish()
    local counts = PP.counts
    for k in pairs(counts) do counts[k] = nil end

    for itemId, n in pairs(self.bagCounts) do
        counts[itemId] = { bags = n, bank = 0 }
    end
    local bankCounts = PP.db and PP.db.char.bankCounts or nil
    if bankCounts then
        for itemId, n in pairs(bankCounts) do
            local c = counts[itemId]
            if c then
                c.bank = n
            else
                counts[itemId] = { bags = 0, bank = n }
            end
        end
    end
    PP:Recompute()
end

function MaterialTracker:ScanBags()
    local bags = {}
    for bag = 0, NUM_BAG_SLOTS do
        scanContainer(bag, bags)
    end
    self.bagCounts = bags
end

function MaterialTracker:ScanBank()
    if not PP.db then return end
    local bank = {}
    scanContainer(BANK_CONTAINER_ID, bank)
    for bag = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
        scanContainer(bag, bank)
    end
    PP.db.char.bankCounts = bank
    PP.db.char.bankScanned = true
    PP:Debug("MaterialTracker: bank scanned")
end

function MaterialTracker:OnBagUpdate()
    self:ScanBags()
    if self.bankOpen then
        self:ScanBank()
    end
    self:Publish()
end

function MaterialTracker:FullScan()
    self:ScanBags()
    -- Nur der volle Scan (Ladescreen, /pp scan) setzt das Flag; ein BAG_UPDATE
    -- mitten im Login koennte noch unvollstaendige Taschen lesen.
    PP.state.countsReady = true
    self:Publish()
end

function MaterialTracker:OnLeavingWorld()
    PP.state.countsReady = false
end

function MaterialTracker:BANKFRAME_OPENED()
    self.bankOpen = true
    self:ScanBank()
    self:Publish()
end

function MaterialTracker:OnBankSlotsChanged()
    if self.bankOpen then
        self:ScanBank()
        self:Publish()
    end
end

function MaterialTracker:BANKFRAME_CLOSED()
    self.bankOpen = false
end
