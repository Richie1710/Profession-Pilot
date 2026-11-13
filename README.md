# ProfessionPilot

Ein Berufs-Leveling-Assistent für **World of Warcraft: Wrath of the Lich King 3.3.5a**.
Unterstützte Berufe (je 1–450, nach den Wowhead-Leveling-Pfaden): **Ingenieurskunst,
Schneiderei, Lederverarbeitung, Juwelenschleifen, Alchemie, Schmiedekunst,
Verzauberkunst und Inschriftenkunde**.

Das Addon erkennt automatisch deinen Engineering-Skill, zeigt dir den aktuellen
Abschnitt, das nächste herzustellende Rezept, die benötigten und vorhandenen
Materialien (Taschen + gecachte Bank) und warnt, wenn ein Rezept fehlt, Materialien
fehlen oder du deinen Berufslehrer besuchen musst.

## Unterstützte Version

- WoW-Client **3.3.5a (Build 12340)**, Interface `30300`
- Deutsche und englische Clients (weitere Sprachen fallen auf Englisch zurück)

## Installation

1. Den Ordner `ProfessionPilot` nach `<WoW>/Interface/AddOns/` kopieren
   (liegt er bereits dort: nichts zu tun).
2. WoW starten, im Charakterauswahl-Bildschirm unter „AddOns" prüfen, dass
   *ProfessionPilot* aktiviert ist.
3. Einloggen. Fertig — alle Bibliotheken (Ace3, LibDataBroker, LibDBIcon) sind
   eingebettet, es gibt keine externen Abhängigkeiten.

## Bedienung

| Aktion | Weg |
|---|---|
| Hauptfenster öffnen/schließen | `/pp` oder Minimap-Button (Linksklick) |
| Schrittübersicht 1–450 | `/pp steps` oder Button „Schritte" |
| Einkaufsliste | `/pp mats` oder Button „Material" |
| Optionen | `/pp config`, Rechtsklick auf Minimap-Button |
| Beruf wechseln (bei mehreren) | `/pp prof` — oder einfach das jeweilige Berufsfenster öffnen |
| Skills/Taschen neu einlesen | `/pp scan` |
| Debug-Modus umschalten | `/pp debug` |
| Einstellungen zurücksetzen | `/pp reset` |

`/professionpilot` und `/ph` sind Aliasse für `/pp`.

**Wichtig nach der Installation:** Öffne einmal dein Berufsfenster
(Ingenieurskunst bzw. Schneiderei), damit ProfessionPilot deine bekannten
Rezepte einlesen kann (3.3.5a bietet dafür keine API ohne offenes
Berufsfenster). Besuche außerdem einmal die Bank, damit Bankbestände gecacht
werden.

### Hauptfenster

- Aktueller Skill `x/450` und aktueller Abschnitt
- Nächstes Rezept mit Icon und Rezeptstatus
  (grün = bekannt, gelb = beim Lehrer lernbar, orange = Händler-Bauplan, rot = noch nicht lernbar)
- Fortschrittsbalken innerhalb des Abschnitts, verbleibende Herstellungen
- **Craft-Button**: Ist das Berufsfenster zu, öffnet der Button es („Beruf
  öffnen"); ist es offen, craftet er das aktuelle Rezept direkt — Linksklick
  1×, Rechtsklick die Restmenge des Abschnitts (begrenzt durch vorhandene
  Materialien, Anzahl in Klammern). Es wird nie ohne Klick gecraftet.
- Materialzeilen mit `vorhanden / benötigt` (grün/rot)
- Hinweiszeile: Lehrer-Warnung, Werkzeug-/Aufhebe-Hinweise, Spezialisierung

### Schrittübersicht

Alle 40 Schritte plus Lehrer-Meilensteine (Geselle → Großmeister) mit Status:
grau ✓ abgeschlossen · gold aktuell · weiß offen · rot Ausbildung fehlt ·
orange Rezept fehlt · gelb Materialien fehlen. Tooltip je Schritt zeigt
Materialien mit Beständen, Quelle, Notizen und Alternativen.

### Einkaufsliste

Zwei Ansichten: **Aktueller Abschnitt** und **Bis 450** — beide hierarchisch.
Berufsintern craftbare Zwischenprodukte sind aufklappbare Knoten
(`[+]`/`[-]`): Ein Klick auf die Zeile steigt eine Ebene in den
Herstellungsbaum hinab und zeigt die Zutaten, skaliert auf die noch fehlende
Menge („zuerst herstellen: 15x"). Die Option **„Baum automatisch aufklappen"**
bestimmt, ob alles aufgeklappt startet oder du dich per Klick durchhangelst.
Jedes craftbare Zwischenprodukt trägt einen eigenen **Craft-Button**
(Linksklick 1×, Rechtsklick benötigte Menge; bei geschlossenem Berufsfenster
öffnet der Klick es zuerst) — so arbeitest du den Baum von unten nach oben
direkt aus dem Addon ab.
In der „Bis 450"-Ansicht stehen oben die direkten Schrittbedarfe; was das
Nachcraften fehlender Zwischenprodukte **zusätzlich** kostet, hängt als
Kind-Ebene darunter (z. B. Feuerpartikel: 20 direkt + 60 unter dem
Elementarsprengpulver) — nichts wird doppelt gezählt, Export und Kostensumme
laufen immer über den kompletten Baum. Bestände werden in Reihenfolge
verbraucht — ein Bronzebarren-Vorrat, der schon fürs Bronzegerüst eingeplant
ist, zählt beim Dingsda nicht noch einmal als vorhanden. Spalten:
Bedarf / Taschen / Bank / Fehlt.
Shift-Klick verlinkt ein Item in den Chat, der Export-Button druckt alle
fehlenden Materialien in dein Chatfenster.

**Craft-Warteschlange:** Der Button „Warteschlange starten" in der Einkaufsliste
arbeitet alle fehlenden Zwischenprodukte des aktuellen Schritts automatisch von
unten nach oben ab (ein Craft pro Serverbestätigung, stoppt bei Kampf,
Fensterschließen, Unterbrechung oder fehlenden Materialien; Sicherheitslimit
200 Crafts). Das Endprodukt craftest du weiter bewusst per Haupt-Button.

**Händlerkauf:** Stehst du vor einem Händler, der Materialien aus deiner Liste
führt (Faden, Phiolen, Flussmittel …), erscheint unter dem Händlerfenster eine
Leiste mit dem Knopf „Fehlendes kaufen" — Linksklick kauft, was dem aktuellen
Abschnitt fehlt, Rechtsklick alles aus der Gesamtansicht. Der Tooltip zeigt
vorher Mengen und Kosten; gekauft werden nur Basismaterialien, gedeckelt durch
Händlervorrat und dein Gold (Sonderwährung wird übersprungen). Bis die Käufe in
den Taschen gezählt sind, ist der Knopf gesperrt — kein Doppelkauf. Materialien,
die das Addon bei einem Händler gesehen hat, tragen in der Einkaufsliste die
Markierung „(Händler)" samt Stückpreis im Tooltip (accountweit gemerkt).
Abschaltbar in den Optionen („Kaufleiste am Händler").

**Kostenberater:** Bei geöffnetem Berufsfenster vergleicht das Addon die
Reagenzienkosten deklarierter Alternativrezepte („Günstiger: … spart ~Xg pro
Herstellung" im Hauptfenster) und markiert Zwischenprodukte in der
Einkaufsliste mit „kaufen!", wenn das AH sie billiger hergibt als ihre Zutaten.

**Skillup-Telemetrie:** Das Addon misst deine echten Skillup-Raten pro Rezept
(wichtig auf Private-Servern mit anderen Raten). Ab 5 beobachteten Crafts
fließt die Messung in die Restmengen-Prognose ein — erkennbar am Zusatz
„(gemessen)" im Hauptfenster.

**Twink-Bestände:** Tooltips in der Einkaufsliste zeigen, wie viel deine
anderen Charaktere (mit Addon eingeloggt) von einem Material besitzen.

**DataBroker-Text:** LDB-Anzeigen (Titan Panel, ChocolateBar) zeigen
„Skill/450 | 26x Rezeptname" live an (Option abschaltbar).

**Schmelz-Infos:** Barren-Materialien tragen im Tooltip die Bergbau-Info
(„Schmelzbar aus: 2x Saroniterz, Bergbau 400") — rein informativ.

**Preise (optional):** Ist Auctioneer (Auc-Advanced) oder Auctionator
installiert oder hat das Addon schon Händlerpreise gemerkt, zeigt die
Einkaufsliste zusätzlich eine Kosten-Spalte und die Gesamtkosten der fehlenden
**Basismaterialien** (gemerkter Händlerpreis vor Auctioneer-Marktwert vor
Auctionator-Scanpreis; 5-Minuten-Cache für AH-Preise). Zwischenprodukte mit
„zuerst herstellen"-Marker werden bewusst nicht eingepreist — ihre Zutaten
stehen bereits expandiert in der Liste, sonst würde doppelt gezählt. Ohne
Preis-Addon und ohne gemerkte Händlerpreise fehlt die Spalte einfach;
abschaltbar in den Optionen.

## Datenquelle und bekannte Guide-Abweichungen

Basis sind die Wowhead-Guides *WotLK Classic Engineering/Tailoring Leveling
1-450* (DOM-Extraktion vom 2026-08-08; die Seiten sind JavaScript-gerendert und
ohne Browser nicht lesbar — dokumentierte Einschränkung). Alle 81 Rezept-Spell-IDs,
hergestellten Item-IDs und (für Classic/TBC-Rezepte) Lernbar-ab-Werte wurden
gegen die AtlasLoot-Daten für exakt diesen 3.3.5a-Client verifiziert; Reagenzien
wurden stichprobenartig gegen Wowhead-Spellseiten geprüft (u.a. Runenstoffballen
= 4 Runenstoff, der WotLK-Wert). Zur Laufzeit ruft das Addon niemals Webseiten
auf — alle Daten sind statisch eingebettet.

Die **aggregierten Einkaufslisten der Guides sind in sich inkonsistent** und
werden bewusst nicht übernommen; ProfessionPilot berechnet Gesamtbedarfe immer
aus den Schrittdaten:

| Material | Guide-Liste | Korrekt (aus Schritten) |
|---|---|---|
| Kristallisierte Erde (Engineering) | 68 | 10 |
| Feuer-/Erdpartikel (Engineering) | 20 / 40 | 80 / 160 (Rauchsignale!) |
| Kobaltbarren (Engineering) | 280 | bis zu 338 (fehlende Bolzen/Auslöser) |
| Froststoff (Tailoring) | 2975 | 4050 (595 Ballen produziert, 810 verbraucht) |
| Schwarztuch (Tailoring) | 12 | 56 |
| Leinenstoff (Tailoring) | 204 | 206 |

Mengen mit `~` sind Schätzungen für gelbe/grüne Rezeptbereiche und hängen von
Glück und Serverraten ab. Im Debug-Modus vergleicht das Addon bei geöffnetem
Berufsfenster die Datenreagenzien mit den echten Client-Werten und meldet
Abweichungen.

## Architektur

```
ProfessionPilot/
├── ProfessionPilot.toc        Interface 30300, SavedVariables: ProfessionPilotDB
├── embeds.xml                 Bibliotheks-Ladereihenfolge
├── Libs/                      Ace3 r960 (Teilmenge), LibDataBroker, LibDBIcon
├── Locales/                   AceLocale: enUS (Basis), deDE
├── Core/
│   ├── Core.lua               AceAddon-Bootstrap, Slash, Snapshot-Bau (PP_SNAPSHOT)
│   ├── Database.lua           AceDB-Defaults (profile/char)
│   ├── Calc.lua               PURE Berechnungslogik + Link-Parser (headless testbar)
│   ├── Shopping.lua           PURE Einkaufsplanung für den Händlerkauf
│   ├── MaterialPlan.lua       PURE Material-API: flache Blattliste + String (siehe „Öffentliche API“)
│   └── ProfessionRegistry.lua Registrierung + Validierung der Berufsdaten
├── Modules/
│   ├── SkillTracker.lua       Skill/Cap via GetSkillLineInfo (lokalisierungsfrei)
│   ├── RecipeTracker.lua      Bekannte Rezepte aus dem Berufsfenster cachen
│   ├── MaterialTracker.lua    Taschen live (gebuckeltes BAG_UPDATE), Bank gecacht
│   ├── PriceSource.lua        Gemerkte Händlerpreise + optional Auctioneer/Auctionator
│   ├── MerchantBuyer.lua      Händlerkauf: Sortiment lesen, Preise merken, kaufen
│   ├── PublicAPI.lua          PP:GetMaterialPlan / GetMaterialPlanString (dünner WoW-Teil)
│   └── Crafter.lua            Craft-Button-Logik (DoTradeSkill)
├── Professions/               Reine Daten, je 1–450, IDs AtlasLoot-verifiziert
│   ├── Engineering.lua        40 Schritte
│   ├── Tailoring.lua          36 Schritte
│   ├── Leatherworking.lua     31 Schritte
│   ├── Jewelcrafting.lua      27 Schritte
│   ├── Alchemy.lua            30 Schritte
│   ├── Blacksmithing.lua      44 Schritte
│   ├── Enchanting.lua         44 Schritte (Craft-API, s.u.)
│   └── Inscription.lua        38 Schritte
├── UI/                        MainWindow, StepList, MaterialList, MerchantBar, Minimap, Options
├── Tests/                     Headless-Tests (Lua 5.1), nicht im TOC
└── docs/superpowers/          Design-Spec und Implementierungsplan
```

Datenfluss: Events → Tracker aktualisieren State → `PP:Recompute()` ruft die pure
`Calc`-Schicht → Snapshot → UI rendert per `PP_SNAPSHOT`-Message. Kein OnUpdate,
keine Frame-weise Neuberechnung.

Bewusste 3.3.5a-Besonderheiten:

- Genau **eine** globale Variable `ProfessionPilot` (der private Addon-Namespace
  `local name, ns = ...` existiert erst seit 4.0). Benannte Frames
  (`ProfessionPilotMainFrame` …) sind für `UISpecialFrames`/ESC nötig.
- Rezeptnamen/-icons kommen aus `GetSpellInfo` (funktioniert offline aus den
  Client-DBCs); `GetItemInfo` kann für ungecachte Items `nil` liefern — die UI
  zeigt dann einen Platzhalter, primt den Cache per Tooltip und rendert nach.
- Berufserkennung über `GetSkillLineInfo`-Name == `GetSpellInfo(4036)` — keine
  hartkodierten lokalisierten Namen.

## Öffentliche API

Andere Addons und Bots (z. B. der WRobot-ProfessionLeveler, Issue
Richie1710/ProfessionLeveler#26) können die Materialplanung lesen, ohne die
Oberfläche zu berühren. Die API ist versioniert (`ProfessionPilot.API_VERSION`,
aktuell `1`) und rechnet für **jeden** registrierten Beruf, den der Charakter
beherrscht, nicht nur für den aktiven. Sie schaltet den aktiven Beruf nicht um,
und die Einstellungen `showUpcoming` und `includeBank` des Fensters haben auf das
Ergebnis keinen Einfluss.

```lua
local plan = ProfessionPilot:GetMaterialPlan(key, toSkill, opts)   -- Tabelle
local s    = ProfessionPilot:GetMaterialPlanString(key, toSkill, opts)   -- String
```

| Parameter | Bedeutung |
|---|---|
| `key` | Berufsschlüssel: `engineering`, `tailoring`, `leatherworking`, `jewelcrafting`, `alchemy`, `blacksmithing`, `enchanting`, `inscription` |
| `toSkill` | Zielskill, frei wählbar. `nil` = Berufsmaximum (450), größere Werte werden auf das Maximum begrenzt. Schrittgenau: Jeder Schritt, der vor `toSkill` beginnt, wird komplett gerechnet; `plan.coveredToSkill` nennt den tatsächlichen Endpunkt (`toSkill` 375 liegt im Lederschritt 350-380, abgedeckt bis 380). |
| `opts.includeBank` | Bankbestand mitzählen (Standard `false`, also nur Taschen). Die Bankzahlen sind der Cache des letzten Bankbesuchs. Bei der String-Variante darf stattdessen ein Boolean als dritter Parameter stehen. |

### Rückgabe als Tabelle

```lua
{
  ok = true, apiVersion = 1,
  profession = "leatherworking", skill = 290, cap = 300, maxSkill = 450,
  toSkill = 450, coveredToSkill = 450,
  includeBank = false,
  countsReady = true,     -- false: Taschenzahlen seit dem Ladescreen noch nicht gelesen
  bankScanned = true,     -- false: Bank noch nie gelesen, bank ist überall 0
  leaves = {              -- nur Rohstoffe, nach itemId sortiert
    { itemId = 8170, need = 120, bags = 12, bank = 100, have = 12, missing = 108 },
    ...
  },
  intermediates = {       -- Zwischenprodukte, die noch hergestellt werden müssen
    { itemId = 38425, recipeSpellId = 50936, crafts = 22 },
  },
}
```

- `need`: Bedarf bis `toSkill`, **inklusive** der Zutaten aufgelöster
  Zwischenprodukte (die Heavy-Borean-Kette ist in `33568` Borean Leather
  eingerechnet). Zwischenprodukte selbst erscheinen nicht in `leaves`.
  **`need` ist kein stabiler Bruttobedarf:** Es hängt vom Bestand an
  Zwischenprodukten ab. Mit 10 Heavy Borean Leather in den Taschen sinkt der
  Borean-Bedarf von 2315 auf 2255 (12 statt 22 Crafts der Kette).
- `bags`, `bank`: tatsächlicher Bestand. `have` = `bags` (+ `bank` mit `includeBank`),
  also der gezählte Bestand, nicht gedeckelt.
- **`missing` ist die verbindliche Zahl** (Farmmenge). Der Bestand eines Items wird
  genau einmal abgezogen, auch wenn es direkt und über Zwischenprodukte gebraucht
  wird. `missing` ist **nicht** immer `need - have`: Stellt ein Levelschritt im
  Bereich das Item selbst her (Ausbeute und Überschuss durch `numMade` werden
  gutgeschrieben), ist `missing` kleiner. Beispiel Lederverarbeitung 1 → 100 mit
  39 Light Leather: `need` 230, `have` 39, `missing` 172 (nicht 191), denn der
  Schritt 1-20 liefert 19 Light Leather. Es gilt immer
  `0 <= missing <= max(0, need - have)`, Gleichheit nur, wenn kein Schritt im
  Bereich das Item herstellt (z. B. Lederverarbeitung 290 → 450). Der Aufrufer
  benutzt `missing`, nie `need - have`.
- Fehler liefern ebenfalls eine Tabelle, nie `nil`: `{ ok = false, error = code, apiVersion = 1 }`.

| `error` | Bedeutung |
|---|---|
| `not_ready` | Addon-Datenbank oder Berufserkennung noch nicht initialisiert (direkt nach dem Laden) |
| `unknown_profession` | kein registrierter Beruf mit diesem Schlüssel |
| `no_profession` | Beruf registriert, der Charakter beherrscht ihn nicht |
| `bad_args` | Schlüssel oder `toSkill` unbrauchbar |

### Bereitschaft (`countsReady`)

`countsReady` ist `false`, bis nach einem Ladescreen der volle Taschenscan lief
(`PLAYER_ENTERING_WORLD`, `/pp scan`). Der Plan wird trotzdem berechnet, aber
`missing` ist dann überall zu hoch. Wer ihn für Entscheidungen nutzt, wartet auf
`countsReady == true` und fragt neu.

### String-Variante für `Lua.LuaDoString`

Aus dem Spiel kommen nur Strings zurück (WRobot: `Lua.LuaDoString<string>(...)`).
Format, Felder durch `|` getrennt, ohne Itemnamen:

```
v1|<state>|<profession>|<skill>|<cap>|<toSkill>|<covered>|<includeBank>|<bankScanned>|<leaves>|<crafts>
```

| Nr. | Feld | Inhalt |
|---|---|---|
| 0 | `v1` | `API_VERSION`; vor dem Parsen prüfen |
| 1 | `state` | `ready` oder `notready` (siehe `countsReady`) |
| 2 | `profession` | Berufsschlüssel |
| 3 | `skill` | aktueller Skill |
| 4 | `cap` | aktuelles Rang-Maximum |
| 5 | `toSkill` | angefragter Zielskill (auf das Berufsmaximum begrenzt) |
| 6 | `covered` | `coveredToSkill`: bis hierhin rechnet der Plan tatsächlich (Schrittgrenze, kann über `toSkill` liegen) |
| 7 | `includeBank` | `1` oder `0` |
| 8 | `bankScanned` | `1`: Bank wurde schon einmal gelesen. `0`: `bank` ist überall 0, auch mit `includeBank=1` |
| 9 | `leaves` | `itemId:need:bags:bank:missing`, durch `;` getrennt, nach itemId sortiert. `missing` ist verbindlich (siehe oben) |
| 10 | `crafts` | `itemId:recipeSpellId:crafts`, durch `;` getrennt |

Leere Listen sind leere Felder. Fehler: `v1|err|<code>` mit den Codes der Tabelle
oben (Feld 2 ist der Code). Beispiel, Lederverarbeitung 290 → 450 ohne Bestand
(Taschen leer, Bank nie gelesen):

```
v1|ready|leatherworking|290|300|450|450|0|0|2325:10:0:0:10;8170:120:0:0:120;14341:32:0:0:32;21887:450:0:0:450;33568:2315:0:0:2315;35622:18:0:0:18;35627:50:0:0:50;36860:50:0:0:50;37705:65:0:0:65;38558:10:0:0:10;43102:15:0:0:15;44128:10:0:0:10|38425:50936:22
```

Aufruf aus dem Bot (Lua-Seite, `pcall` fängt ein fehlendes Addon ab):

```lua
local ok, s = pcall(function()
    return ProfessionPilot and ProfessionPilot.API_VERSION == 1
        and ProfessionPilot:GetMaterialPlanString("leatherworking", 450, false) or ""
end)
return ok and s or ""
```

`ProfessionPilot.MaterialPlan.Parse(s)` zerlegt den String wieder in eine Tabelle
(gleiche Felder wie oben, ohne `maxSkill`).

Hinweise für den Parser auf der C#-Seite (WRobot):
- An `|` teilen und **leere Felder behalten**: `s.Split('|')`, nicht mit
  `StringSplitOptions.RemoveEmptyEntries`. Leere Listen sind leere Felder und
  dürfen die Nummerierung nicht verschieben.
- **Mindestens 11 Felder verlangen** (Nr. 0 bis 10) und **zusätzliche Felder am Ende
  ignorieren**: Innerhalb von `v1` werden spätere Erweiterungen nur hinten angehängt.
  Feld 0 muss genau `v1` sein, sonst abbrechen. Bei Feld 1 `err` ist Feld 2 der
  Fehlercode und es gibt keine weiteren Felder.
- Zahlen mit `int.TryParse(s, NumberStyles.Integer, CultureInfo.InvariantCulture, out n)`
  lesen (alle Werte sind ganzzahlig und nicht negativ).
- Listen an `;` teilen, Einträge an `:` (5 bzw. 3 Teile), leere Liste = leerer String.
- Bei `notready` oder Fehler `not_ready` kurz warten und neu fragen, bei `bankScanned=0`
  und `includeBank=1` nicht auf Bankzahlen bauen.

Ändert sich das Format inkompatibel, steigt `API_VERSION`.

## Einen weiteren Beruf hinzufügen

1. Neue Datei `Professions/<Beruf>.lua` anlegen und im TOC eintragen.
2. `PP:RegisterProfession{...}` mit `key`, `professionSpellId` (Rang-1-Spell),
   `maxSkill`, `ranks` und sortierter `steps`-Liste aufrufen. Pflichtfelder je
   Schritt: `minSkill`, `maxSkill`, `recipeSpellId`, `learnAtSkill`,
   `estimatedCrafts`, `materials` (Gesamtmengen; `craftedBy` für
   Zwischenprodukte, deren Produzent ein früherer Schritt ist). Optional:
   `craftedItemId`, `numMade`, `approximate`, `saveForLater`, `source`
   (`"trainer"|"vendor"`), `sourceItemId`, `notesKey`, `alternatives`.
3. Die Registry validiert beim Laden (Sortierung, Teilbarkeit der Mengen,
   craftedBy-Referenzen) — Fehler schlagen in den Headless-Tests auf.
4. Locale-Keys für neue Notizen in `Locales/enUS.lua` + `deDE.lua` ergänzen.
5. Tests in `Tests/` ergänzen (`test_engineering_data.lua` als Vorlage).

Der SkillTracker erkennt automatisch jeden registrierten Beruf. Beherrscht ein
Charakter mehrere, wird die letzte Auswahl pro Charakter gespeichert; gewechselt
wird per `/pp prof` oder automatisch beim Öffnen des jeweiligen Berufsfensters.

## Tests

Headless-Suite (kein WoW nötig), benötigt einen Lua-5.1-Interpreter:

```
lua5.1 Tests/run_tests.lua           # komplette Suite (228 Assertions)
lua5.1 Tests/run_tests.lua test_calc # einzelne Datei
```

Abgedeckt: Statuslogik und Grenzfälle (1/30/50/51/137/200/449/450), Datenintegrität
(40 Schritte, keine Lücken 1–449, verifizierte Anker-IDs, Materialsummen),
Aggregation mit Kettenauflösung (Unter-/Überproduktion, numMade-Überschuss,
Bank-Toggle), Link-Parser.

### Manuelle Testcheckliste (3.3.5a-Client)

- [ ] Charakter **ohne** Engineering: Hauptfenster zeigt Hinweis, keine Fehler
- [ ] Engineering frisch gelernt (Skill 1): Schritt 1 aktuell, 60 Raue Steine gelistet
- [ ] Skill mitten im Abschnitt (z. B. 137): anteilige Restmengen plausibel
- [ ] Skill exakt an Grenze (z. B. 200): nächster Abschnitt wird aktuell
- [ ] Skill 449: „noch 2 Herstellungen", 20 Saronit; Skill 450: Glückwunsch-Text
- [ ] Rezept unbekannt: orange/rote Kennzeichnung; nach Lernen + Fenster öffnen grün
- [ ] Taschen leer vs. Materialien vorhanden: Zähler und Farben aktualisieren live
- [ ] Bank nie besucht: Hinweis in Einkaufsliste; nach Bankbesuch Bankspalte gefüllt
- [ ] `/reload`: Fensterzustand, Position, Rezept-/Bank-Cache bleiben erhalten
- [ ] Charakterwechsel: getrennte Rezept-/Bank-Caches (char-DB), Profil geteilt
- [ ] Deutscher und englischer Client: lokalisierte Rezept-/Materialnamen
- [ ] Lehrer-Cap erreicht (z. B. 75 als Lehrling): rote Warnung im Hauptfenster
- [ ] Berufsfenster offen + `/pp debug`: keine „reagent mismatch"-Meldungen
- [ ] Händler mit Faden/Phiolen öffnen: Leiste unter den Reitern „Händler/Rückkauf" (Standard-UI und ElvUI), Summen plausibel
- [ ] Linksklick kauft die Abschnittsmenge, Rechtsklick die Gesamtmenge; Chat-Zusammenfassung; Knopf bis zur Ankunft gesperrt
- [ ] Händler ohne passende Ware: keine Leiste; Option „Kaufleiste am Händler" aus: keine Leiste
- [ ] Nach dem Händlerbesuch: „(Händler)"-Markierung und Stückpreis in der Einkaufsliste, Kosten auch ohne AH-Addon

## Bekannte Einschränkungen

- **Nach Addon-Updates, die neue Dateien mitbringen, WoW komplett neu starten** —
  `/reload` führt nur die beim Client-Start eingelesene Dateiliste erneut aus;
  neue TOC-Einträge werden erst beim nächsten Start geladen.

- Bekannte Rezepte werden erst nach einmaligem Öffnen des Berufsfensters erkannt.
- Bankbestände sind ein Cache vom letzten Bankbesuch (Gildenbank wird nicht gezählt).
- `estimatedCrafts` in gelben/grünen Bereichen sind Schätzwerte; bei parallelen
  Schrittfenstern sind Restmengen mitten im Fenster Obergrenzen.
- Es wird ein Beruf zur Zeit angezeigt; Wechsel per `/pp prof` oder Öffnen des
  Berufsfensters.
- Erz→Barren-Ketten *außerhalb* des Berufs (Bergbau/Schmelzen) werden nicht
  aufgelöst; gezählt wird das Endmaterial (z. B. Barren). Ebenso werden die
  Schneiderei-Spezialstoffe (Mondgespinst/Schwarztuch/Zaubertuch) als
  Basismaterial gezählt, nicht über ihre Cooldown-Rezepte aufgelöst.
- Nordend-Rezepte tragen `learnAtSkill` = Schrittbeginn (AtlasLoot führt für
  WotLK-Lehrerrezepte keine Skill-Werte); das ist bewusst konservativ.
- **Verzauberkunst** nutzt in 3.3.5a die alte Craft-API: Rezept-Scan und
  Craft-Button funktionieren, aber pro Klick wird genau 1× gewirkt (DoCraft
  kennt keine Wiederholungszahl; Verzauberungen brauchen ohnehin ein Ziel).
  Reine Verzauberungs-Schritte haben kein herstellbares Item (kein Icon-Link).
- **Juwelenschleifen/Inschriftenkunde**: „Beliebiger Schliff/beliebige
  Glyphe"-Fenster sind mit einem repräsentativen Lehrer-Rezept modelliert
  (Hinweistext erklärt das); Sondieren/Mahlen wird nicht aufgelöst — Edelsteine
  und Pigmente zählen als Basismaterial.
- Zwei Reagenzien-Restunsicherheiten aus den Guides (Strange Tarot,
  repräsentative Glyphen-Tintenkosten) sind offen markiert — der Debug-Modus
  (`/pp debug` + Berufsfenster öffnen) prüft Reagenzien automatisch gegen den
  Client und meldet Abweichungen.
- **Händlerkauf** gilt für den aktiven Beruf (Wechsel per `/pp prof`). Bei
  eingeschalteter Bank-Option wird Bankbestand nicht nachgekauft. Freier
  Taschenplatz wird nicht vorab geprüft — lehnt der Server ab (Taschen voll),
  zeigt die Leiste nach wenigen Sekunden den echten Rest. Käufe über das
  Händlerfenster oder Auto-Restock-Addons sperren den Knopf ebenfalls, bis sie
  gezählt sind; Wege, die `BuyMerchantItem` umgehen (Ziehen in die Tasche,
  ElvUI-Alt-Klick-Stapelkauf), erkennt er erst nach der Taschenzählung — direkt
  danach also nicht sofort auf „Fehlendes kaufen" klicken.

## Transparenzhinweis (KI-Unterstützung)

Dieses Addon wurde **KI-unterstützt entwickelt** (AI-assisted): Analyse,
Architektur, Quellcode, Tests und Dokumentation entstanden mit Unterstützung
von Claude (Anthropic) unter menschlicher Anleitung und Prüfung. Die
Spieldaten (Rezepte, Item-IDs, Mengen) stammen aus den genannten Quellen
(Wowhead-Guides, AtlasLoot-Clientdaten) und wurden maschinell extrahiert und
gegengeprüft.

Zur Einordnung: Das Addon selbst **enthält und verwendet zur Laufzeit keine
KI** — es ist deterministischer Lua-Code ohne Netzwerkzugriff. Der Hinweis
betrifft ausschließlich den Entstehungsprozess.

*This addon was developed with AI assistance (Claude by Anthropic) under
human direction and review. The addon itself contains no AI at runtime.*

## Lizenz / Credits

Eingebettete Bibliotheken: Ace3 (Limited BSD, wowace.com), LibDataBroker-1.1,
LibDBIcon-1.0. Leveling-Pfad: Wowhead WotLK Classic Engineering Guide.
