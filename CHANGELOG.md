# Changelog

Format nach [Keep a Changelog](https://keepachangelog.com/de/1.1.0/),
Versionierung nach [Semantic Versioning](https://semver.org/lang/de/).
Die Versionsnummer in `ProfessionPilot.toc` ist die Quelle der Wahrheit;
der Git-Tag `vX.Y.Z` muss dazu passen.

## [Unreleased]

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
