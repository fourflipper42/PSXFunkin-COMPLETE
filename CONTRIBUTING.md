# Contributing

Hey! If you want to help get Funkin' running on a PS1, you're in the right place.

You can help by fixing bugs, improving the build tools, porting missing behavior, testing on hardware, or just filing a really good bug report.

# Before You Start

- Read the [compiling guide](docs/COMPILING.md).
- Check the [current status](docs/STATUS.md) and [roadmap](ROADMAP.md) so you don't spend three hours fixing something that is already being torn apart.
- Read the [asset rules](docs/ASSETS.md) and [third-party notices](THIRD_PARTY_NOTICES.md).
- Run `./check.sh` before you open a PR.
- Keep changes focused. One bug/fix/feature per PR is way easier to review.

This port targets the **original PlayStation first**. DuckStation is great for iteration, but emulator-only success is not the finish line.

# Working on the Port

Do not treat `upstream/` as source code you should commit. It is a generated PSXFunkin worktree and gets wiped/rebuilt.

Most changes belong in one of these places:

- `scripts/build_*.py` for converting official source assets into PS1-friendly data.
- `scripts/apply_*.py` for changing the generated PSXFunkin C/XML tree.
- `scripts/ps1asset/` for reusable PS1 asset tools.
- `patches/` for small changes that belong directly on the pinned PSXFunkin baseline.

Read [PORTING.md](docs/PORTING.md) if that sounds weird. It makes more sense once you've built the thing once.

# Assets

**Do not commit downloaded Funkin' assets, music, videos, disc images, or SDK files.**

The setup script fetches/stages official sources locally. Generated `TIM`, `ARC`, `XA`, `STR`, `BIN`, and `CUE` files stay out of Git too.

If the official source does not contain an animation/frame we need, do not draw a fake replacement just to make the build pass. Leave the gap obvious and mention it in your PR.

More detail is in [ASSETS.md](docs/ASSETS.md).

# Pull Requests

Make a branch in your fork instead of doing all your work directly on `main`.

A good PR should say:

- what changed,
- why it changed,
- how you tested it,
- whether you tested it on DuckStation and/or real hardware.

Screenshots or short recordings are extremely useful for visual/runtime changes.

If your change touches CD streaming, XA, STR playback, memory use, VRAM, timing, or controller behavior, please test more than just "it compiled."

# Licensing

This project contains material under different licenses/ownership. Read `LICENSING.md` and `THIRD_PARTY_NOTICES.md` before importing or copying code/assets from somewhere else.

Do not assume a PR can relicense third-party material just because it is being added to this repository.

# Code Comments

Comment the weird parts, not every line.

Good comments explain **why** the code is doing something strange: PS1 hardware limits, a disc-layout requirement, an upstream quirk, a fixed-point workaround, etc.

# Bugs and Build Problems

Use the issue templates. Include the exact commit you tested and enough information for somebody else to reproduce it.

If the console gives you an error code or the emulator log says something useful, include it. "it broke lol" is spiritually valid but not very debuggable.
