#!/usr/bin/env python3
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LOCK = ROOT / "build-lock.env"

REQUIRED_SHA1 = {
    "PSXFUNKIN_COMMIT",
    "FUNKIN_ASSETS_COMMIT",
    "WEEK_REFERENCE_COMMIT",
    "PSXAVENC_COMMIT",
    "MKPSXISO_COMMIT",
}


def read_lock() -> dict[str, str]:
    values: dict[str, str] = {}
    for raw in LOCK.read_text().splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        key, sep, value = line.partition("=")
        if not sep or not key or not value:
            raise SystemExit(f"Bad build-lock.env line: {raw!r}")
        values[key] = value
    return values


def main() -> None:
    values = read_lock()
    missing = sorted(REQUIRED_SHA1 - values.keys())
    if missing:
        raise SystemExit("Missing build pins: " + ", ".join(missing))
    for key in REQUIRED_SHA1:
        if not re.fullmatch(r"[0-9a-f]{40}", values[key]):
            raise SystemExit(f"{key} is not an exact 40-char Git SHA")
    if not re.fullmatch(r"[0-9a-f]{64}", values.get("FUNKIN_LINUX_SHA256", "")):
        raise SystemExit("FUNKIN_LINUX_SHA256 is not an exact SHA-256")
    if values.get("FUNKIN_LINUX_TAG") != "v0.8.4":
        raise SystemExit("This WIP currently expects Funkin v0.8.4")
    print("Build lock looks good.")


if __name__ == "__main__":
    main()
