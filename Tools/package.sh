#!/usr/bin/env bash
# Baut ein installierbares Addon-Zip aus dem aktuellen Arbeitsstand.
#
#   Tools/package.sh [ausgabeverzeichnis]
#
# Ergebnis: <ausgabe>/ProfessionPilot-<version>.zip mit genau einem
# Ordner "ProfessionPilot/" auf oberster Ebene -- WoW verlangt, dass der
# Ordnername exakt dem TOC-Dateinamen entspricht.
#
# Es werden nur von Git verwaltete Dateien verpackt (respektiert also die
# .gitignore), abzueglich der reinen Entwicklungs-Artefakte unten.
set -euo pipefail

ADDON="ProfessionPilot"
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out="${1:-$root/dist}"
# Absolut machen (relativ zum Aufrufer): zip laeuft spaeter im Staging-Verzeichnis.
mkdir -p "$out" && out="$(cd "$out" && pwd)"
cd "$root"

version="$(sed -n 's/^## Version:[[:space:]]*//p' "$ADDON.toc" | tr -d '\r')"
[ -n "$version" ] && echo "$version" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+' \
  || { echo "FEHLER: keine gueltige '## Version:' in $ADDON.toc" >&2; exit 1; }

# Nicht ins Spiel gehoerende Pfade (Regex, auf Repo-relative Pfade angewandt).
EXCLUDE='^(Tests/|Tools/|docs/|\.github/|\.git|\.playwright-mcp/)'

stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT
mkdir -p "$stage/$ADDON"

count=0
while IFS= read -r f; do
    if echo "$f" | grep -Eq "$EXCLUDE"; then continue; fi
    mkdir -p "$stage/$ADDON/$(dirname "$f")"
    cp "$f" "$stage/$ADDON/$f"
    count=$((count + 1))
done < <(git ls-files)

[ "$count" -gt 0 ] || { echo "FEHLER: keine Dateien zum Verpacken." >&2; exit 1; }
[ -f "$stage/$ADDON/$ADDON.toc" ] || { echo "FEHLER: $ADDON.toc fehlt im Paket." >&2; exit 1; }

zipfile="$out/$ADDON-$version.zip"
rm -f "$zipfile"

if command -v zip >/dev/null 2>&1; then
    (cd "$stage" && zip -qr "$zipfile" "$ADDON")
elif command -v powershell.exe >/dev/null 2>&1; then
    # Git Bash unter Windows bringt kein zip mit.
    powershell.exe -NoProfile -Command \
        "Compress-Archive -Path '$(cygpath -w "$stage/$ADDON")' -DestinationPath '$(cygpath -w "$zipfile")' -Force" >/dev/null
else
    echo "FEHLER: weder 'zip' noch 'powershell.exe' gefunden." >&2
    exit 1
fi

echo "$ADDON $version -> $zipfile ($count Dateien)"
