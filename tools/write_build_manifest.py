#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def lock_lines() -> list[str]:
    return [
        line.strip()
        for line in (ROOT / "build-lock.env").read_text().splitlines()
        if line.strip() and not line.lstrip().startswith("#")
    ]


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--disc", type=Path, required=True)
    ap.add_argument("--exe", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    args = ap.parse_args()

    commit = subprocess.run(
        ["git", "rev-parse", "HEAD"], cwd=ROOT, check=True, text=True, capture_output=True
    ).stdout.strip()

    lines = [
        "PSXFunkin COMPLETE build manifest",
        f"PORT_COMMIT={commit}",
        *lock_lines(),
        f"DISC_SHA256={sha256(args.disc)}",
        f"EXE_SHA256={sha256(args.exe)}",
        f"DISC_BYTES={args.disc.stat().st_size}",
        f"EXE_BYTES={args.exe.stat().st_size}",
        "",
    ]
    args.out.write_text("\n".join(lines))


if __name__ == "__main__":
    main()
