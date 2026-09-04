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

if git rev-parse -q --verify "refs/tags/v$new" >/dev/null; then
    echo "FEHLER: Tag v$new existiert bereits." >&2
    exit 1
fi

sed -i.bak "s/^## Version:.*/## Version: $new/" "$ADDON.toc" && rm -f "$ADDON.toc.bak"

# Die bisher unveroeffentlichten Eintraege werden zur neuen Version;
# darueber entsteht ein frischer, leerer Unreleased-Abschnitt.
if [ -f CHANGELOG.md ]; then
    awk -v ver="$new" -v day="$(date +%Y-%m-%d)" '
        /^## \[Unreleased\]$/ && !seen {
            print "## [Unreleased]"
            print ""
            print "## [" ver "] - " day
            seen = 1
            next
        }
        { print }
    ' CHANGELOG.md > CHANGELOG.tmp && mv CHANGELOG.tmp CHANGELOG.md
    git add CHANGELOG.md
fi

git add "$ADDON.toc"
git commit -q -m "Release v$new"
git tag -a "v$new" -m "ProfessionPilot v$new"

echo "$old -> $new. Tag v$new angelegt."
echo "Pushen mit:  git push && git push origin v$new"
