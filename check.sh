#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

python3 tools/repo_check.py
python3 tools/verify_build_lock.py
python3 -m py_compile scripts/*.py scripts/ps1asset/*.py tools/*.py

for script in setup.sh build.sh check.sh play.sh dev.sh tools/build_wip.sh; do
    bash -n "$script"
done

echo "Source checks passed."
