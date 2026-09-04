#!/usr/bin/env bash
# Setzt eine neue Version und legt den passenden Release-Tag an.
#
#   Tools/bump_version.sh 1.0.0
#
# Die TOC-Datei ist die einzige Quelle der Wahrheit fuer die Versionsnummer;
# Tag und CHANGELOG werden daraus abgeleitet. Der Release-Workflow prueft,
# dass Tag und TOC uebereinstimmen.
set -euo pipefail

ADDON="ProfessionPilot"
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

new="${1:-}"
echo "$new" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$' \
  || { echo "Aufruf: Tools/bump_version.sh <major.minor.patch>" >&2; exit 1; }

old="$(sed -n 's/^## Version:[[:space:]]*//p' "$ADDON.toc" | tr -d '\r')"
[ "$old" != "$new" ] || { echo "FEHLER: Version ist bereits $new." >&2; exit 1; }

[ -z "$(git status --porcelain)" ] \
  || { echo "FEHLER: Arbeitsverzeichnis nicht sauber -- erst committen." >&2; exit 1; }

git rev-parse -q --verify "refs/tags/v$new" >/dev/null \
  && { echo "FEHLER: Tag v$new existiert bereits." >&2; exit 1; } || true

sed -i.bak "s/^## Version:.*/## Version: $new/" "$ADDON.toc" && rm -f "$ADDON.toc.bak"

# Unveroeffentlichte Eintraege bekommen die neue Versionsueberschrift.
if [ -f CHANGELOG.md ]; then
    sed -i.bak "s/^## \[Unreleased\]$/## [$new] - $(date +%Y-%m-%d)/" CHANGELOG.md
    rm -f CHANGELOG.md.bak
    sed -i.bak "1,/^# /s/^# \(.*\)$/# \1\n\n## [Unreleased]/" CHANGELOG.md
    rm -f CHANGELOG.md.bak
fi

git add "$ADDON.toc" CHANGELOG.md 2>/dev/null || git add "$ADDON.toc"
git commit -q -m "Release v$new"
git tag -a "v$new" -m "ProfessionPilot v$new"

echo "$old -> $new. Tag v$new angelegt."
echo "Pushen mit:  git push && git push origin v$new"
