#!/usr/bin/env python3
from __future__ import annotations

import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

REQUIRED = (
    "README.md",
    "CONTRIBUTING.md",
    "docs/COMPILING.md",
    "docs/STATUS.md",
    "setup.sh",
    "build.sh",
    "scripts/build_v084_charselect_full.py",
    "scripts/apply_v084_charselect_full.py",
    "scripts/build_pico_mix_content.py",
)

BAD_ROOTS = (
    "upstream/",
    "official-v084/",
    "official-assets/",
    "psx-week-reference/",
    ".deps/",
    "build/",
    "out/",
)

BAD_SUFFIXES = (".bin", ".cue", ".iso", ".ps-exe")


def tracked() -> list[str]:
    proc = subprocess.run(
        ["git", "ls-files"], cwd=ROOT, check=True, text=True, capture_output=True
    )
    return [line for line in proc.stdout.splitlines() if line]


def main() -> None:
    missing = [name for name in REQUIRED if not (ROOT / name).is_file()]
    if missing:
        raise SystemExit("Missing contributor/build files: " + ", ".join(missing))

    bad: list[str] = []
    for name in tracked():
        low = name.lower()
        if any(name.startswith(root) for root in BAD_ROOTS):
            bad.append(name)
        if low.endswith(BAD_SUFFIXES):
            bad.append(name)
    if bad:
        raise SystemExit("Generated/downloaded files are tracked: " + ", ".join(sorted(set(bad))))

    print("Repository layout looks good.")


if __name__ == "__main__":
    main()
