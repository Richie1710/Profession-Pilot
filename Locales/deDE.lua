-- ProfessionPilot deDE locale.

local L = LibStub("AceLocale-3.0"):NewLocale("ProfessionPilot", "deDE")
if not L then return end

-- Hauptfenster
L["MAIN_TITLE"] = "ProfessionPilot"
L["SKILL_LABEL"] = "Skill: %d / %d"
L["SECTION_LABEL"] = "Abschnitt %d - %d"
L["NEXT_LABEL"] = "Als N\195\164chstes:"
L["CRAFTS_REMAINING"] = "noch %d Herstellungen"
L["CRAFTS_REMAINING_APPROX"] = "noch ~%d Herstellungen"
L["NO_PROFESSION"] = "Kein unterst\195\188tzter Beruf erlernt.|nUnterst\195\188tzt: %s"
L["PROF_SWITCHED"] = "Aktiver Beruf: %s"
L["DONE_ALL"] = "Gl\195\188ckwunsch - 450 erreicht!"
L["RANK_WARNING"] = "Skill-Limit erreicht - besuche deinen Lehrer!"
L["RECIPE_KNOWN"] = "Rezept bekannt"
L["RECIPE_LEARNABLE"] = "Beim Lehrer lernbar (ab %d)"
L["RECIPE_NOT_YET"] = "Lehrerrezept, ben\195\182tigt Skill %d"
L["RECIPE_VENDOR"] = "Bauplan beim H\195\164ndler erh\195\164ltlich"
L["RECIPE_UNKNOWN_HINT"] = "\195\150ffne einmal das Ingenieurskunst-Fenster, damit ProfessionPilot deine bekannten Rezepte einlesen kann."
L["BTN_STEPS"] = "Schritte"
L["BTN_MATS"] = "Material"
L["BTN_OPTIONS"] = "Optionen"
L["BTN_CRAFT"] = "Herstellen"
L["BTN_OPEN_PROF"] = "Beruf \195\182ffnen"
L["CRAFT_TT_LEFT"] = "Linksklick: 1x herstellen"
L["CRAFT_TT_RIGHT"] = "Rechtsklick: Restmenge des Abschnitts herstellen"

-- Schrittliste
L["STEPLIST_TITLE"] = "%s 1-%d - Schritt\195\188bersicht"
L["STATUS_COMPLETED"] = "abgeschlossen"
L["STATUS_CURRENT"] = "aktuell"
L["STATUS_UPCOMING"] = "noch nicht begonnen"
L["STATUS_RECIPE_MISSING"] = "Rezept fehlt"
L["STATUS_MATS_MISSING"] = "Materialien fehlen"
L["STATUS_RANK_MISSING"] = "Ausbildung fehlt"
L["MILESTONE_LEARN"] = "%s beim Lehrer lernen"
L["CRAFT_COUNT"] = "x%d"
L["CRAFT_COUNT_APPROX"] = "~x%d"
L["SAVE_FOR_LATER"] = "Hergestellte Gegenst\195\164nde aufheben - werden sp\195\164ter gebraucht!"
L["SOURCE_TRAINER"] = "Quelle: Lehrer"
L["SOURCE_VENDOR"] = "Quelle: H\195\164ndler"
L["SOURCE_QUEST"] = "Quelle: Quest"
L["RECIPE_QUEST"] = "Rezept aus einer Quest"
L["ALTERNATIVE_LABEL"] = "Alternative:"

-- Rangnamen (nur Anzeige; Erkennung l\195\164uft \195\188ber Skill-Caps)
L["RANK_1"] = "Lehrling"
L["RANK_2"] = "Geselle"
L["RANK_3"] = "Experte"
L["RANK_4"] = "Fachmann"
L["RANK_5"] = "Meister"
L["RANK_6"] = "Gro\195\159meister"

-- Materialliste
L["MATLIST_TITLE"] = "Einkaufsliste"
L["TAB_CURRENT"] = "Aktueller Abschnitt"
L["TAB_TOTAL"] = "Bis 450"
L["COL_NEED"] = "Bedarf"
L["COL_BAGS"] = "Taschen"
L["COL_BANK"] = "Bank"
L["COL_MISSING"] = "Fehlt"
L["COL_COST"] = "Kosten"
L["TOTAL_COST"] = "Fehlende Basismaterialien: ~%s (%s)"
L["CRAFT_FIRST"] = "zuerst herstellen"
L["CRAFT_FIRST_N"] = "zuerst herstellen: %dx"
L["EXPORT_CHAT"] = "Fehlendes in den Chat"
L["EXPORT_HEADER"] = "ProfessionPilot Einkaufsliste (fehlende Materialien):"
L["EXPORT_EMPTY"] = "Nichts fehlt - alles vorhanden!"
L["BANK_NOT_SCANNED"] = "Bank noch nicht eingelesen - besuche einmal deine Bank."
L["ITEM_LOADING"] = "(lade Gegenstand %d)"

-- Schrittnotizen
L["NOTE_TOOL"] = "Das ist ein Berufswerkzeug - aufheben!"
L["NOTE_LEARN_JOURNEYMAN"] = "Lerne den Gesellen-Rang (ab Skill 50), sonst ist bei 75 Schluss."
L["NOTE_LEARN_EXPERT"] = "Lerne den Experten-Rang (ab Skill 125), sonst ist bei 150 Schluss."
L["NOTE_LEARN_ARTISAN"] = "Lerne den Fachmann-Rang (Skill 200, Charakterstufe 35), sonst ist bei 225 Schluss."
L["NOTE_LEARN_ARTISAN_ENG"] = "Lerne Fachmann der Ingenieurskunst (Skill 200, Charakterstufe 35). Ab Stufe 35 ist auch die Spezialisierung m\195\182glich (Gnomen-/Gobliningenieur - Goblin wird f\195\188r Sprengladungen ben\195\182tigt)."
L["NOTE_LEARN_MASTER"] = "Lerne den Meister-Rang (Lehrer in der Scherbenwelt, Shattrath oder Dalaran)."
L["NOTE_LEARN_GRANDMASTER"] = "Lerne den Gro\195\159meister-Rang (Lehrer in Nordend oder Dalaran)."
L["NOTE_VENDOR_WSF"] = "Bauplan: Wei\195\159es Rauchsignal wird von Ingenieursbedarf-H\195\164ndlern in der Scherbenwelt, Exodar und Silbermond verkauft."
L["NOTE_VENDOR_IMBUED"] = "Muster: Magieerf\195\188llter Netherstoffballen wird in Shattrath verkauft."
L["NOTE_VENDOR_DALARAN"] = "Das Muster f\195\188r dieses Rezept wird in Dalaran verkauft."
L["NOTE_FROSTWEAVE_STOCK"] = "Die sp\195\164teren Schritte verbrauchen deutlich mehr Ballen, als dieser Schritt f\195\188r Skillpunkte liefert - die Einkaufsliste enth\195\164lt den zus\195\164tzlichen Froststoff bereits."
L["ALT_REQ_GOBLIN"] = "Nur Gobliningenieure"
L["ALT_CLOTH_CHOICE"] = "je nach verf\195\188gbarem Stoff/Spezialisierung"
L["ALT_MAT_CHOICE"] = "je nach verf\195\188gbaren Materialien"

-- Juwelenschleifen
L["NOTE_VENDOR_JC_AGATE"] = "Vorlage: Anh\195\164nger des Achatschilds wird von H\195\164ndlern im Sumpfland (Allianz) bzw. in Tausend Nadeln (Horde) verkauft."
L["NOTE_JC_ANY_GEM"] = "Jeder Schliff eines ungew\195\182hnlichen Edelsteins z\195\164hlt - nimm den billigsten."
L["NOTE_JC_PRISM_CD"] = "20 Stunden Abklingzeit - dieser letzte Abschnitt dauert mehrere Tage."

-- Alchemie
L["NOTE_ALCHEMY_SPEC"] = "Ab Skill 325 / Stufe 68 kannst du eine Alchemie-Spezialisierung w\195\164hlen (Tr\195\164nke, Elixiere oder Transmutation) - Quests auf der H\195\182llenfeuerhalbinsel."
L["NOTE_ALCHEMY_RESEARCH"] = "Ab Skill 400 kannst du per Alchemistische Forschung Nordends einen Alchemistenstein herstellen - vor Skill 420 anfertigen, wenn du ihn nutzen willst."
L["NOTE_VENDOR_TANARIS"] = "Rezept: Stein der Weisen wird von einem H\195\164ndler in Gadgetzan (Tanaris) verkauft."
L["NOTE_VENDOR_ZANGARMARSH"] = "Rezept: Erstklassiger Manatrank wird von H\195\164ndlern verkauft (begrenzter Vorrat, Zangarmarsch)."

-- Schmiedekunst
L["NOTE_QUEST_IMPERIAL"] = "Pl\195\164ne: Imperiale Plattenarmschienen gibt es als Belohnung der wiederholbaren Thorium-Abgabequest 'Imperiale Plattenarmschienen' in Gadgetzan."
L["NOTE_VENDOR_WARD"] = "Pl\195\164ne: Geringer Zauberschutz der Abschirmung wird von H\195\164ndlern im Schattenmondtal (Allianz) und auf der H\195\182llenfeuerhalbinsel (Horde) verkauft."

-- Verzauberkunst
L["NOTE_DISENCHANT"] = "Das Entzaubern niedrigstufiger Gegenst\195\164nde gibt in diesem Bereich ebenfalls Fertigkeitspunkte und liefert den ben\195\182tigten Staub."
L["NOTE_VENDOR_ASHENVALE"] = "Die Formel wird von einem H\195\164ndler im Eschental (Allianz) bzw. im Steinkrallengebirge (Horde) verkauft."
L["NOTE_VENDOR_SILITHUS"] = "Formel: Geringes Man\195\182l wird von einem H\195\164ndler in Silithus verkauft."
L["NOTE_VENDOR_UC_DARNASSUS"] = "Formel: Gro\195\159e Ausdauer ist beim Aufheben gebunden und wird in Unterstadt (Horde) bzw. Darnassus (Allianz) verkauft."
L["NOTE_VENDOR_MOONGLADE"] = "Formel: Runenverzierte Arkanitrute wird von einem H\195\164ndler in der Mondlichtung verkauft."
L["NOTE_VENDOR_SHATTRATH"] = "Formel: \195\156berragendes Zauber\195\182l wird in Shattrath verkauft."
L["NOTE_VENDOR_HELLFIRE"] = "Formel: Runenverzierte Adamantitrute wird auf der H\195\182llenfeuerhalbinsel (Allianz) bzw. im Wald von Terokkar (Horde) verkauft."

-- Inschriftenkunde
L["NOTE_INSC_MILLING"] = "Pigmente gewinnst du durch das Mahlen von Kr\195\164utern (F\195\164higkeit 'Mahlen', 5 Kr\195\164uter pro Anwendung). Mahlen selbst gibt keine Fertigkeitspunkte."
L["NOTE_INSC_ANY_GLYPH"] = "Stelle beliebige Glyphen her, die f\195\188r dich gelb oder orange sind - die angezeigte Glyphe ist nur ein beim Lehrer erlernbares Beispiel mit gleichen Tintenkosten."
L["NOTE_INSC_RESEARCH"] = "Inschriftenforschung von Nordend: entdeckt eine zuf\195\164llige neue Glyphentechnik. 20 Stunden Abklingzeit - eine Forschung pro Tag."

-- Minimap / LDB
L["MINIMAP_LEFT"] = "Linksklick: Hauptfenster ein-/ausblenden"
L["MINIMAP_RIGHT"] = "Rechtsklick: Optionen"

-- Optionen
L["OPT_GENERAL"] = "Allgemein"
L["OPT_LOCK"] = "Fenster sperren"
L["OPT_LOCK_DESC"] = "Verhindert das Verschieben des Hauptfensters."
L["OPT_SCALE"] = "Fenstergr\195\182\195\159e"
L["OPT_MINIMAP"] = "Minimap-Button anzeigen"
L["OPT_ONLY_CURRENT"] = "Nur aktuellen Abschnitt anzeigen"
L["OPT_ONLY_CURRENT_DESC"] = "Blendet abgeschlossene Schritte und erledigte Meilensteine in der Schritt\195\188bersicht aus."
L["OPT_AUTO_EXPAND"] = "Baum automatisch aufklappen"
L["OPT_AUTO_EXPAND_DESC"] = "Zeigt craftbare Zwischenprodukte in der Einkaufsliste komplett aufgeklappt. Wenn aus: Klick auf ein craftbares Item klappt eine Ebene auf."
L["OPT_SHOW_UPCOMING"] = "Kommende Materialien anzeigen"
L["OPT_SHOW_UPCOMING_DESC"] = "Nimmt Materialien zuk\195\188nftiger Abschnitte in die Einkaufsliste auf."
L["OPT_INCLUDE_BANK"] = "Bankmaterialien ber\195\188cksichtigen"
L["OPT_INCLUDE_BANK_DESC"] = "Z\195\164hlt gecachte Bankbest\195\164nde als vorhanden."
L["OPT_ALTERNATIVES"] = "Alternative Rezepte anzeigen"
L["OPT_SHOW_PRICES"] = "Preise anzeigen"
L["OPT_SHOW_PRICES_DESC"] = "Zeigt die gesch\195\164tzten Kosten fehlender Basismaterialien: zuerst gemerkte H\195\164ndlerpreise, sonst Scandaten von Auctioneer oder Auctionator."
L["OPT_TOOLTIPS"] = "Tooltips aktivieren"
L["OPT_DEBUG"] = "Debug-Modus"
L["OPT_DEBUG_DESC"] = "Gibt Diagnosemeldungen im Chatfenster aus."

-- Kostenberater
L["ADVICE_ALT_CHEAPER"] = "G\195\188nstiger: %s (spart ~%s pro Herstellung)"
L["ADVICE_ALT_DETAIL"] = "~%s statt ~%s an Reagenzien"
L["ADVICE_BUY"] = "kaufen!"
L["ADVICE_BUY_TT"] = "Kaufen ist ~%s g\195\188nstiger als selbst herzustellen."

-- Warteschlange
L["QUEUE_EMPTY"] = "Nichts herzustellen - keine fehlenden Zwischenprodukte."
L["QUEUE_DONE"] = "Warteschlange fertig - alle Zwischenprodukte hergestellt."
L["QUEUE_ABORTED"] = "Warteschlange abgebrochen - Zauber fehlgeschlagen oder unterbrochen."
L["QUEUE_BLOCKED"] = "Warteschlange blockiert - kein Rezept der Warteschlange ist gerade herstellbar."
L["QUEUE_CLOSED"] = "Warteschlange gestoppt - Berufsfenster geschlossen."
L["QUEUE_COMBAT"] = "Warteschlange gestoppt - du bist im Kampf."
L["QUEUE_LIMIT"] = "Warteschlange gestoppt - Sicherheitslimit von %d Herstellungen erreicht."
L["QUEUE_STOPPED"] = "Warteschlange gestoppt."
L["BTN_QUEUE_START"] = "Warteschlange starten"
L["BTN_QUEUE_STOP"] = "Warteschlange stoppen"

-- Twink-Best\195\164nde
L["ROSTER_TT_HEADER"] = "Andere Charaktere: %d"
L["ROSTER_TT_LINE"] = "%s: %d"
L["OPT_SHOW_ROSTER"] = "Twink-Best\195\164nde anzeigen"
L["OPT_SHOW_ROSTER_DESC"] = "Zeigt in den Tooltips der Einkaufsliste, wie viel deine anderen Charaktere von einem Material besitzen."

-- Telemetrie / LDB / Schmelzen
L["STATS_MEASURED_SUFFIX"] = "(gemessen)"
L["OPT_LDB_TEXT"] = "Fortschritt als DataBroker-Text"
L["OPT_LDB_TEXT_DESC"] = "Zeigt Skill und aktuellen Schritt in LDB-Anzeigen (Titan Panel, ChocolateBar). Der Minimap-Button ist davon unabh\195\164ngig."
L["SMELT_FROM"] = "Schmelzbar aus: %dx %s (Bergbau %d)"
L["SMELT_FROM_COMBO"] = "Geschmolzen aus: %s (Bergbau %d)"
L["SMELT_YIELD"] = "Ergibt %dx pro Schmelzvorgang"

-- H\195\164ndlerkauf
L["PRICE_SRC_VENDOR"] = "H\195\164ndler"

-- Slash / Sonstiges
L["SLASH_HELP"] = "ProfessionPilot-Befehle: /pp show | steps | mats | prof | config | scan | debug | reset"
L["DEBUG_ON"] = "Debug-Modus aktiviert."
L["DEBUG_OFF"] = "Debug-Modus deaktiviert."
L["PROFILE_RESET"] = "Einstellungen zur\195\188ckgesetzt."
L["SCAN_DONE"] = "Skills und Taschen neu eingelesen."
