# PSXFunkin COMPLETE

A WIP conversion of all of the new V-Slice content into PSXFunkin

## Status

In the oven

This repo is the public WIP source. Stuff can and will break while the port is being worked on.

## Getting Started

**If you just want to mess with the current build, start with the [compiling guide](docs/COMPILING.md).**

On Linux/Bazzite, the easiest route is the included dev container. Put a legally obtained compatible converted PsyQ archive somewhere inside the ignored `.deps/` folder, then:

```bash
mkdir -p .deps
cp /path/to/psyq-4_7-converted-light.zip .deps/psyq.zip
./dev.sh setup --psyq-zip .deps/psyq.zip
./dev.sh build
./play.sh
```

`setup` downloads the pinned upstream repos and official v0.8.4 source assets. None of that downloaded stuff gets committed here.

- [Compiling](docs/COMPILING.md)
- [Windows / WSL](docs/WINDOWS.md)
- [Testing](docs/TESTING.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [How this port is put together](docs/PORTING.md)
- [Reproducible build inputs](docs/REPRODUCIBLE_BUILDS.md)
- [Asset rules](docs/ASSETS.md)
- [Current WIP status](docs/STATUS.md)
- [Roadmap](ROADMAP.md)

## Contributing

Want to help? Cool. Read the [Contributing Guide](CONTRIBUTING.md) before opening a PR.

## Repository layout

- `scripts/` — asset conversion, chart conversion, source patching, and build-support tools.
- `scripts/ps1asset/` — PlayStation-oriented texture and archive utilities.
- `patches/` — source patches used by the build process.
- `tools/` — contributor setup/build checks and asset staging.
- `build-lock.env` — exact source/tool revisions used by setup.
- `sitecustomize.py` — Python compatibility support used by the tooling.

## Credits

- Friday Night Funkin' — Funkin' Crew and its contributors.
- PSXFunkin — cuckydev and contributors.
- PSXFunkin COMPLETE - fourflipper and contributors.

See [LICENSING.md](LICENSING.md) and [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for licensing/redistribution notes.

This repository contains an unofficial fan port and is not affiliated with or endorsed by Sony Interactive Entertainment (OR FUNKIN CREW!!!)
