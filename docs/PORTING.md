# How The Port Is Put Together

PSXFunkin COMPLETE is built *on top of* a pinned PSXFunkin checkout. The finished generated C/asset tree is not stored directly in this repo.

That is intentional.

# The Short Version

`setup.sh` creates local source/dependency trees:

```text
upstream/             pinned PSXFunkin checkout
official-v084/        staged official Funkin v0.8.4 sources
psx-week-reference/   pinned PS1 base-week reference
.deps/                build tools + SDK files
```

`build.sh` then runs the port pipeline over `upstream/` and produces the disc in `out/`.

# Build Scripts vs Apply Scripts

A rough rule:

- **build scripts** convert source data (PNG, JSON, OGG, video, Animate/Sparrow data) into PS1 formats.
- **apply scripts** change PSXFunkin source/XML so the converted data is actually used.

For example, a character might need both an asset builder that makes TIM/ARC data and an apply script that adds the runtime code/stage definition/disc entries.

# Do Not Edit `upstream/` And Call It Done

The build resets `upstream/` to the pinned baseline. Hand edits there disappear.

If you prototype a fix directly in `upstream/src`, that's fine. Once it works, move that change into the appropriate apply script or patch before submitting it.

# PS1 Rules That Matter A Lot

Keep an eye on:

- RAM and stack use,
- VRAM placement and CLUT overlap,
- CD seek/stream behavior,
- raw MODE2 sector alignment,
- XA/STR sector layout,
- ISO9660 filename limits used by the port,
- fixed-point/timing differences,
- real hardware behavior.

A desktop PC being able to brute-force something is not evidence that the PS1 can.

# Current Content Pipeline

The current WIP pipeline includes the V-Slice menu/Freeplay work, Character Select, pause menu, base Week 2/5/6 material, console options/saves, Weekend 1, LE SSERAFIM content, and Pico Mix work.

Not every subsystem is finished. See [STATUS.md](STATUS.md) before assuming a green build means the entire game is runtime-approved.
