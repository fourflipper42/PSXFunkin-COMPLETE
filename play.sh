#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUE="$ROOT/out/PSXFunkin-COMPLETE-WIP.cue"

if [[ ! -s "$CUE" ]]; then
    echo "No WIP disc found at out/PSXFunkin-COMPLETE-WIP.cue"
    echo "Build it first with ./build.sh or ./dev.sh build."
    exit 1
fi

if command -v duckstation-qt >/dev/null 2>&1; then
    exec duckstation-qt "$CUE"
elif command -v duckstation >/dev/null 2>&1; then
    exec duckstation "$CUE"
elif command -v flatpak >/dev/null 2>&1 && flatpak info org.duckstation.DuckStation >/dev/null 2>&1; then
    exec flatpak run org.duckstation.DuckStation "$CUE"
else
    echo "Disc is ready: $CUE"
    echo "Open it in DuckStation or another PS1 emulator."
fi
