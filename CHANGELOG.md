# Changelog

Format nach [Keep a Changelog](https://keepachangelog.com/de/1.1.0/),
Versionierung nach [Semantic Versioning](https://semver.org/lang/de/).
Die Versionsnummer in `ProfessionPilot.toc` ist die Quelle der Wahrheit;
der Git-Tag `vX.Y.Z` muss dazu passen.

## [Unreleased]

### Hinzugefügt
- Öffentliche, versionierte API für andere Addons und Bots (Issue
  Richie1710/ProfessionLeveler#26): `ProfessionPilot:GetMaterialPlan(key, toSkill, opts)`
  liefert eine flache Liste der Basismaterialien (`itemId, need, bags, bank,
  have, missing`) bis zu einem frei wählbaren Zielskill, mit aufgelösten
  Zwischenprodukten und ohne Doppelzählung des Bestands. `GetMaterialPlanString`
  gibt dieselben Daten als stabilen String für `Lua.LuaDoString` zurück
  (`v1|ready|leatherworking|290|300|450|450|0|0|itemId:need:bags:bank:missing;…|…`,
  mit `coveredToSkill` und `bankScanned`). `missing` ist die verbindliche
  Farmmenge; `need - have` ist nur eine Obergrenze, weil Levelschritte im
  Bereich Items selbst herstellen können (Lederverarbeitung 1 → 100 mit 39 Light
  Leather: `need` 230, `missing` 172). `need` hängt außerdem vom Bestand an
  Zwischenprodukten ab.
  Die API rechnet für jeden erlernten Beruf, nicht nur den aktiven, ändert
  weder den aktiven Beruf noch Einstellungen und meldet Fehler als Code
  (`not_ready`, `unknown_profession`, `no_profession`, `bad_args`) statt `nil`.
  `countsReady` zeigt, ob die Taschenzahlen nach dem Ladescreen gelesen sind.
  Beschreibung im README unter „Öffentliche API“.

## [0.10.0] - 2026-09-11

### Behoben
- Neu gelernte Rezepte wurden nicht erkannt, und der Knopf im Hauptfenster
  war dann deaktiviert (Issue #1) — der Rezept-Cache füllt sich aber nur beim
  Öffnen des Berufsfensters, es gab also keinen Ausweg. Bei geschlossenem
  Fenster bietet der Knopf jetzt immer „Beruf öffnen" an, und `RecipeTracker`
  gleicht bei `LEARNED_SPELL_IN_TAB` das Zauberbuch ab (`IsSpellKnown`),
  erkennt frisch Gelerntes also auch ohne offenes Fenster.
- `RecipeTracker`: C stack overflow beim Öffnen eines Berufsfensters.
  `ExpandTradeSkillSubClass` löste `TRADE_SKILL_UPDATE` aus und rief damit
  den eigenen Handler endlos rekursiv auf. Jetzt mit Wiedereintritts-Sperre,
  und es werden nur noch tatsächlich eingeklappte Kategorien aufgeklappt.

### Hinzugefügt
- Händlerkauf: Steht man vor einem Händler, der Materialien aus der
  Einkaufsliste führt, kauft ein Knopf unter dem Händlerfenster die fehlende
  Menge (Linksklick aktueller Abschnitt, Rechtsklick Gesamtansicht) — gedeckelt
  durch Händlervorrat und Gold, gesperrt bis zur Ankunft in den Taschen.
- Händlerpreise: Gesehene Händlerpreise werden accountweit gemerkt, in der
  Einkaufsliste als „(Händler)" markiert und in Kostenspalte, Gesamtsumme und
  Kostenberater verwendet — auch ohne Auctioneer/Auctionator.
- Git-Repository, `.gitattributes` (LF), CI-Workflow für die Testsuite,
  Release-Workflow und Packaging-Skript.

### Geändert
- Die Option „Auktionspreise anzeigen" heißt jetzt „Preise anzeigen" und
  umfasst gemerkte Händlerpreise.

## [0.9.0]

- Erste versionierte Fassung: 8 Berufe 1–450, Craft-Queue, Kostenberater,
  Telemetrie, Twink-Roster, Schmelz-Infos.
