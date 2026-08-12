#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

for path in upstream official-v084 psx-week-reference .deps/psxavenc/build/psxavenc .deps/bin/mkpsxiso; do
    if [[ ! -e "$path" ]]; then
        echo "Missing $path"
        echo "Run ./setup.sh first (or ./dev.sh setup on Linux)."
        exit 1
    fi
done

if [[ ! -d .deps/psyq/include || ! -d .deps/psyq/lib ]]; then
    echo "PsyQ compatibility files are missing."
    echo "Run ./setup.sh --psyq-zip FILE or ./setup.sh --fetch-psyq."
    exit 1
fi

exec bash tools/build_wip.sh
