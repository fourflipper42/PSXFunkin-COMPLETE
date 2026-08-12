#!/usr/bin/env python3
from __future__ import annotations

import argparse
import shutil
import zipfile
from pathlib import Path, PurePosixPath


def merge_dir(src: Path, dst: Path) -> None:
    if src.is_dir():
        shutil.copytree(src, dst, dirs_exist_ok=True)


def overlay_linux_zip(archive: Path, out: Path) -> int:
    count = 0
    with zipfile.ZipFile(archive) as zf:
        for info in zf.infolist():
            if info.is_dir():
                continue
            parts = PurePosixPath(info.filename).parts
            try:
                asset_index = parts.index("assets")
            except ValueError:
                continue
            rel = parts[asset_index + 1 :]
            if not rel:
                continue
            target = out.joinpath(*rel)
            target.parent.mkdir(parents=True, exist_ok=True)
            with zf.open(info) as src, target.open("wb") as dst:
                shutil.copyfileobj(src, dst)
            count += 1
    return count


def require(out: Path, rel: str) -> None:
    path = out / rel
    if not path.exists():
        raise SystemExit(f"official v0.8.4 source missing after staging: {rel}")


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--asset-repo", type=Path, required=True)
    ap.add_argument("--linux-zip", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    args = ap.parse_args()

    if args.out.exists():
        shutil.rmtree(args.out)
    args.out.mkdir(parents=True)

    # Funkin merges preload/shared content at runtime. Recreate that useful flat
    # view for the PS1 conversion scripts, while keeping week/song roots intact.
    merge_dir(args.asset_repo / "preload", args.out)
    merge_dir(args.asset_repo / "shared", args.out)

    for name in (
        "fonts", "songs", "sserafim", "tutorial", "videos",
        "week1", "week2", "week3", "week4", "week5", "week6", "week7", "weekend1",
    ):
        merge_dir(args.asset_repo / name, args.out / name)

    extracted = overlay_linux_zip(args.linux_zip, args.out)
    if extracted == 0:
        raise SystemExit("official Linux archive did not contain an assets tree")

    for rel in (
        "images/charSelect",
        "songs/stress/Inst-pico.ogg",
        "data/songs/stress/stress-chart-pico.json",
        "weekend1",
        "sserafim",
    ):
        require(args.out, rel)

    print(f"Staged official v0.8.4 assets ({extracted} executable-bundled files overlaid).")


if __name__ == "__main__":
    main()
