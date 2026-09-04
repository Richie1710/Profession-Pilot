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

**Auktionspreise (optional):** Ist Auctioneer (Auc-Advanced) oder Auctionator
installiert, zeigt die Einkaufsliste zusätzlich eine Kosten-Spalte und die
Gesamtkosten der fehlenden **Basismaterialien** (Auctioneer-Marktwert bevorzugt,
sonst Auctionator-Scanpreis; 5-Minuten-Cache). Zwischenprodukte mit
„zuerst herstellen"-Marker werden bewusst nicht eingepreist — ihre Zutaten
stehen bereits expandiert in der Liste, sonst würde doppelt gezählt. Ohne
Preis-Addon fehlt die Spalte einfach; abschaltbar in den Optionen.

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
│   └── ProfessionRegistry.lua Registrierung + Validierung der Berufsdaten
├── Modules/
│   ├── SkillTracker.lua       Skill/Cap via GetSkillLineInfo (lokalisierungsfrei)
│   ├── RecipeTracker.lua      Bekannte Rezepte aus dem Berufsfenster cachen
│   ├── MaterialTracker.lua    Taschen live (gebuckeltes BAG_UPDATE), Bank gecacht
│   ├── PriceSource.lua        Optional: Auctioneer-/Auctionator-Preise
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
├── UI/                        MainWindow, StepList, MaterialList, Minimap, Options
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
