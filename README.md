# PSXFunkin COMPLETE

A WIP conversion of all of the new V-Slice content into PSXFunkin

## Status

In the oven

This repo is the public WIP source. Stuff can and will break while the port is being worked on.

## Getting Started

**If you just want to mess with the current build, start with the [compiling guide](docs/COMPILING.md).**

On Linux, the easiest route is the included dev container:

```bash
./dev.sh setup --fetch-psyq
./dev.sh build
./play.sh
```

`setup` downloads the pinned upstream repos and official v0.8.4 source assets. None of that downloaded stuff gets committed here.

- [Compiling](docs/COMPILING.md)
- [Testing](docs/TESTING.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [How this port is put together](docs/PORTING.md)
- [Asset rules](docs/ASSETS.md)
- [Current WIP status](docs/STATUS.md)

## Contributing

Want to help? Cool. Read the [Contributing Guide](CONTRIBUTING.md) before opening a PR.

## Repository layout

- `scripts/` — asset conversion, chart conversion, source patching, and build-support tools.
- `scripts/ps1asset/` — PlayStation-oriented texture and archive utilities.
- `patches/` — source patches used by the build process.
- `tools/` — contributor setup/build checks and asset staging.
- `sitecustomize.py` — Python compatibility support used by the tooling.

## Credits

- Friday Night Funkin' — Funkin' Crew and its contributors.
- PSXFunkin — cuckydev and contributors.
- PSXFunkin COMPLETE - fourflipper and contributors.

This repository contains an unofficial fan port and is not affiliated with or endorsed by Sony Interactive Entertainment (OR FUNKIN CREW!!!)
