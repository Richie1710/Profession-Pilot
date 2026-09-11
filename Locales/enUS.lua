-- ProfessionPilot enUS locale (base, fallback for all clients).

local L = LibStub("AceLocale-3.0"):NewLocale("ProfessionPilot", "enUS", true)
if not L then return end

-- Main window
L["MAIN_TITLE"] = "ProfessionPilot"
L["SKILL_LABEL"] = "Skill: %d / %d"
L["SECTION_LABEL"] = "Section %d - %d"
L["NEXT_LABEL"] = "Next:"
L["CRAFTS_REMAINING"] = "%d crafts remaining"
L["CRAFTS_REMAINING_APPROX"] = "~%d crafts remaining"
L["NO_PROFESSION"] = "No supported profession learned.|nSupported: %s"
L["PROF_SWITCHED"] = "Active profession: %s"
L["DONE_ALL"] = "Congratulations - 450 reached!"
L["RANK_WARNING"] = "Skill cap reached - visit your trainer!"
L["RECIPE_KNOWN"] = "Recipe known"
L["RECIPE_LEARNABLE"] = "Learn at trainer (requires %d)"
L["RECIPE_NOT_YET"] = "Trainer recipe, requires skill %d"
L["RECIPE_VENDOR"] = "Blueprint sold by vendors"
L["RECIPE_UNKNOWN_HINT"] = "Open the Engineering window once so ProfessionPilot can scan your known recipes."
L["BTN_STEPS"] = "Steps"
L["BTN_MATS"] = "Materials"
L["BTN_OPTIONS"] = "Options"
L["BTN_CRAFT"] = "Craft"
L["BTN_OPEN_PROF"] = "Open profession"
L["CRAFT_TT_LEFT"] = "Left-click: craft 1"
L["CRAFT_TT_RIGHT"] = "Right-click: craft the section's remaining amount"

-- Step list
L["STEPLIST_TITLE"] = "%s 1-%d - Step Overview"
L["STATUS_COMPLETED"] = "completed"
L["STATUS_CURRENT"] = "current"
L["STATUS_UPCOMING"] = "not started"
L["STATUS_RECIPE_MISSING"] = "recipe missing"
L["STATUS_MATS_MISSING"] = "materials missing"
L["STATUS_RANK_MISSING"] = "training missing"
L["MILESTONE_LEARN"] = "Learn %s at the trainer"
L["CRAFT_COUNT"] = "x%d"
L["CRAFT_COUNT_APPROX"] = "~x%d"
L["SAVE_FOR_LATER"] = "Keep the crafted items - needed later!"
L["SOURCE_TRAINER"] = "Source: trainer"
L["SOURCE_VENDOR"] = "Source: vendor"
L["SOURCE_QUEST"] = "Source: quest"
L["RECIPE_QUEST"] = "Recipe from a quest"
L["ALTERNATIVE_LABEL"] = "Alternative:"

-- Rank names (UI only; detection uses skill caps, not names)
L["RANK_1"] = "Apprentice"
L["RANK_2"] = "Journeyman"
L["RANK_3"] = "Expert"
L["RANK_4"] = "Artisan"
L["RANK_5"] = "Master"
L["RANK_6"] = "Grand Master"

-- Material list
L["MATLIST_TITLE"] = "Shopping List"
L["TAB_CURRENT"] = "Current section"
L["TAB_TOTAL"] = "Up to 450"
L["COL_NEED"] = "Need"
L["COL_BAGS"] = "Bags"
L["COL_BANK"] = "Bank"
L["COL_MISSING"] = "Missing"
L["COL_COST"] = "Cost"
L["TOTAL_COST"] = "Missing base materials: ~%s (%s)"
L["CRAFT_FIRST"] = "craft first"
L["CRAFT_FIRST_N"] = "craft first: %dx"
L["EXPORT_CHAT"] = "Post missing to chat"
L["EXPORT_HEADER"] = "ProfessionPilot shopping list (missing materials):"
L["EXPORT_EMPTY"] = "Nothing missing - you are all set!"
L["BANK_NOT_SCANNED"] = "Bank not scanned yet - visit your bank once."
L["ITEM_LOADING"] = "(loading item %d)"

-- Step notes
L["NOTE_TOOL"] = "This is a profession tool - keep it!"
L["NOTE_LEARN_JOURNEYMAN"] = "Learn Journeyman rank (from skill 50) or you will stop at 75."
L["NOTE_LEARN_EXPERT"] = "Learn Expert rank (from skill 125) or you will stop at 150."
L["NOTE_LEARN_ARTISAN"] = "Learn Artisan rank (skill 200, character level 35) or you will stop at 225."
L["NOTE_LEARN_ARTISAN_ENG"] = "Learn Artisan Engineering (skill 200, character level 35). At level 35 you may also specialize (Gnomish/Goblin - Goblin is required for Sapper Charges)."
L["NOTE_LEARN_MASTER"] = "Learn Master rank (Outland trainers, Shattrath or Dalaran)."
L["NOTE_LEARN_GRANDMASTER"] = "Learn Grand Master rank (Northrend trainers or Dalaran)."
L["NOTE_VENDOR_WSF"] = "Blueprint: White Smoke Flare is sold by engineering suppliers in Outland, the Exodar and Silvermoon City."
L["NOTE_VENDOR_IMBUED"] = "Pattern: Bolt of Imbued Netherweave is sold in Shattrath City."
L["NOTE_VENDOR_DALARAN"] = "The pattern for this recipe is sold in Dalaran."
L["NOTE_FROSTWEAVE_STOCK"] = "The later steps consume far more bolts than this step yields for skill-ups - the shopping list already includes the extra frostweave."
L["ALT_REQ_GOBLIN"] = "Goblin engineers only"
L["ALT_CLOTH_CHOICE"] = "depending on available cloth/specialization"
L["ALT_MAT_CHOICE"] = "depending on available materials"

-- Jewelcrafting
L["NOTE_VENDOR_JC_AGATE"] = "Design: Pendant of the Agate Shield is sold by vendors in the Wetlands (Alliance) or Thousand Needles (Horde)."
L["NOTE_JC_ANY_GEM"] = "Any uncommon gem cut works - use whatever is cheapest."
L["NOTE_JC_PRISM_CD"] = "20 hour cooldown - this final stretch takes several days."

-- Alchemy
L["NOTE_ALCHEMY_SPEC"] = "At skill 325 / level 68 you can pick an Alchemy specialization (Potions, Elixirs or Transmutation) via quests in Hellfire Peninsula."
L["NOTE_ALCHEMY_RESEARCH"] = "At skill 400, Northrend Alchemy Research lets you create an Alchemist Stone trinket - craft it before 420 if you want it."
L["NOTE_VENDOR_TANARIS"] = "Recipe: Philosopher's Stone is sold by a vendor in Gadgetzan, Tanaris."
L["NOTE_VENDOR_ZANGARMARSH"] = "Recipe: Super Mana Potion is vendor-sold (limited stock, Zangarmarsh)."

-- Blacksmithing
L["NOTE_QUEST_IMPERIAL"] = "Plans: Imperial Plate Bracers are a reward from the repeatable thorium turn-in quest 'Imperial Plate Bracers' in Gadgetzan."
L["NOTE_VENDOR_WARD"] = "Plans: Lesser Ward of Shielding is sold by vendors in Shadowmoon Valley (Alliance) and Hellfire Peninsula (Horde)."

-- Enchanting
L["NOTE_DISENCHANT"] = "Disenchanting low-level items also grants skill points in this range and yields the dust you need."
L["NOTE_VENDOR_ASHENVALE"] = "The formula is sold by a vendor in Ashenvale (Alliance) or Stonetalon Mountains (Horde)."
L["NOTE_VENDOR_SILITHUS"] = "Formula: Lesser Mana Oil is sold by a vendor in Silithus."
L["NOTE_VENDOR_UC_DARNASSUS"] = "Formula: Greater Stamina is Bind on Pickup and sold in Undercity (Horde) or Darnassus (Alliance)."
L["NOTE_VENDOR_MOONGLADE"] = "Formula: Runed Arcanite Rod is sold by a vendor in Moonglade."
L["NOTE_VENDOR_SHATTRATH"] = "Formula: Superior Wizard Oil is sold in Shattrath City."
L["NOTE_VENDOR_HELLFIRE"] = "Formula: Runed Adamantite Rod is sold in Hellfire Peninsula (Alliance) or Terokkar Forest (Horde)."

-- Inscription
L["NOTE_INSC_MILLING"] = "Pigments come from milling herbs (Milling ability, 5 herbs per use). Milling itself gives no skill-ups."
L["NOTE_INSC_ANY_GLYPH"] = "Craft any glyph that is yellow or orange for you - the listed glyph is just one trainer-taught option with the same ink cost."
L["NOTE_INSC_RESEARCH"] = "Northrend Inscription Research: discovers a random new glyph technique. 20-hour cooldown - one research per day."

-- Minimap / LDB
L["MINIMAP_LEFT"] = "Left-click: toggle main window"
L["MINIMAP_RIGHT"] = "Right-click: options"

-- Options
L["OPT_GENERAL"] = "General"
L["OPT_LOCK"] = "Lock window"
L["OPT_LOCK_DESC"] = "Prevents dragging the main window."
L["OPT_SCALE"] = "Window scale"
L["OPT_MINIMAP"] = "Show minimap button"
L["OPT_ONLY_CURRENT"] = "Show only current section"
L["OPT_ONLY_CURRENT_DESC"] = "Hides completed steps and passed milestones in the step overview."
L["OPT_AUTO_EXPAND"] = "Expand crafting tree automatically"
L["OPT_AUTO_EXPAND_DESC"] = "Shows craftable intermediates fully expanded in the shopping list. When off, click a craftable item to drill down one level."
L["OPT_SHOW_UPCOMING"] = "Show upcoming materials"
L["OPT_SHOW_UPCOMING_DESC"] = "Include materials for future sections in the shopping list."
L["OPT_INCLUDE_BANK"] = "Include bank materials"
L["OPT_INCLUDE_BANK_DESC"] = "Count cached bank contents as available."
L["OPT_ALTERNATIVES"] = "Show alternative recipes"
L["OPT_SHOW_PRICES"] = "Show prices"
L["OPT_SHOW_PRICES_DESC"] = "Shows the estimated cost of missing base materials: remembered vendor prices first, otherwise Auctioneer or Auctionator scan data."
L["OPT_TOOLTIPS"] = "Enable tooltips"
L["OPT_DEBUG"] = "Debug mode"
L["OPT_DEBUG_DESC"] = "Prints diagnostic messages to the chat frame."

-- Cost advisor
L["ADVICE_ALT_CHEAPER"] = "Cheaper: %s (saves ~%s per craft)"
L["ADVICE_ALT_DETAIL"] = "~%s instead of ~%s in reagents"
L["ADVICE_BUY"] = "buy!"
L["ADVICE_BUY_TT"] = "Buying is ~%s cheaper than crafting from ingredients."

-- Craft queue
L["QUEUE_EMPTY"] = "Nothing to craft - no missing intermediates."
L["QUEUE_DONE"] = "Craft queue finished - all intermediates crafted."
L["QUEUE_ABORTED"] = "Craft queue aborted - cast failed or interrupted."
L["QUEUE_BLOCKED"] = "Craft queue blocked - no queued recipe is craftable right now."
L["QUEUE_CLOSED"] = "Craft queue stopped - profession window closed."
L["QUEUE_COMBAT"] = "Craft queue stopped - you are in combat."
L["QUEUE_LIMIT"] = "Craft queue stopped - safety limit of %d combines reached."
L["QUEUE_STOPPED"] = "Craft queue stopped."
L["BTN_QUEUE_START"] = "Start craft queue"
L["BTN_QUEUE_STOP"] = "Stop craft queue"

-- Alt roster
L["ROSTER_TT_HEADER"] = "Other characters: %d"
L["ROSTER_TT_LINE"] = "%s: %d"
L["OPT_SHOW_ROSTER"] = "Show alt inventory"
L["OPT_SHOW_ROSTER_DESC"] = "Shows in the shopping list tooltips how much of a material your other characters own."

-- Telemetry / LDB / smelting
L["STATS_MEASURED_SUFFIX"] = "(measured)"
L["OPT_LDB_TEXT"] = "Show progress in DataBroker text"
L["OPT_LDB_TEXT_DESC"] = "Shows skill and current step in LDB display addons (Titan Panel, ChocolateBar). The minimap button is unaffected."
L["SMELT_FROM"] = "Smeltable from: %dx %s (Mining %d)"
L["SMELT_FROM_COMBO"] = "Smelted from: %s (Mining %d)"
L["SMELT_YIELD"] = "Yields %dx per smelt"

-- Vendor buying
L["PRICE_SRC_VENDOR"] = "Vendor"
L["BUY_DONE"] = "Buying: %s (%s)"
L["BUY_NOTHING"] = "This vendor sells nothing you are missing for that."
L["BUY_NOTE_CAPPED_STOCK"] = "%s: vendor only has %d in stock"
L["BUY_NOTE_CAPPED_MONEY"] = "%s: gold only covers %d"
L["BUY_NOTE_SKIP_STOCK"] = "%s: sold out"
L["BUY_NOTE_SKIP_MONEY"] = "%s: not enough gold"
L["BUY_NOTE_SKIP_CURRENCY"] = "%s: costs a special currency - skipped"
L["BTN_BUY_MISSING"] = "Buy missing"
L["BUY_BUSY"] = "Buying..."
L["BUY_SUMMARY"] = "Section: %s   %s: %s"
L["BUY_TT_LEFT"] = "Left-click: current section"
L["BUY_TT_RIGHT"] = "Right-click: %s"
L["BUY_TT_NOTHING"] = "nothing from this vendor"
L["OPT_MERCHANT_BAR"] = "Buy bar at vendors"
L["OPT_MERCHANT_BAR_DESC"] = "Shows a button below the vendor window that buys the missing base materials this vendor sells (left-click: current section, right-click: overall view)."

-- Slash / misc
L["SLASH_HELP"] = "ProfessionPilot commands: /pp show | steps | mats | prof | config | scan | debug | reset"
L["DEBUG_ON"] = "Debug mode enabled."
L["DEBUG_OFF"] = "Debug mode disabled."
L["PROFILE_RESET"] = "Settings reset."
L["SCAN_DONE"] = "Rescanned skills and bags."
