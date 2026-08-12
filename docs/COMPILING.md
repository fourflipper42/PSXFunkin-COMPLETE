# Compiling

This thing has a lot of moving parts. The helper scripts exist so you don't have to assemble the entire PS1 toolchain by hand every time.

# Recommended: Linux Dev Container

You need **Podman** or **Docker** on the host. Bazzite already ships with Podman, so this is also the least annoying Bazzite setup.

The repo does **not** redistribute PsyQ. Put a compatible converted PsyQ archive you are legally allowed to use in the ignored `.deps/` directory first:

```bash
mkdir -p .deps
cp /path/to/psyq-4_7-converted-light.zip .deps/psyq.zip
```

Then:

```bash
./dev.sh setup --psyq-zip .deps/psyq.zip
./dev.sh build
```

The first setup takes a while. It downloads the pinned PSXFunkin source, the exact v0.8.4 Funkin asset revision, the official v0.8.4 Linux build used for a few bundled sources, the base-week conversion reference, `psxavenc`, and `mkpsxiso`.

The finished local disc should end up at:

```text
out/PSXFunkin-COMPLETE-WIP.bin
out/PSXFunkin-COMPLETE-WIP.cue
```

Then run:

```bash
./play.sh
```

# Native Linux Build

You can skip the container and run the scripts directly if your system has the dependencies.

The build currently expects tools equivalent to:

- GCC / make
- Python 3 + Pillow
- Git + Git LFS
- CMake + Ninja
- Meson
- FFmpeg / ffprobe and development libraries
- MIPS little-endian GCC/binutils
- TinyXML2 development files

On Ubuntu/Debian, the dev container installs the known-good package set for you. On other distros, package names differ.

Then:

```bash
./setup.sh --psyq-zip /path/to/psyq-4_7-converted-light.zip
./build.sh
```

# Rebuilding

`upstream/` is disposable. The build resets it to the pinned baseline before applying the port again, so don't keep hand edits in there.

Change the public build/apply scripts instead and rebuild.

If your fetched dependencies get mangled:

```bash
make distclean
mkdir -p .deps
cp /path/to/psyq-4_7-converted-light.zip .deps/psyq.zip
./dev.sh setup --psyq-zip .deps/psyq.zip
./dev.sh build
```

`distclean` deletes generated/downloaded build trees. It does not touch the tracked source in this repo.

# What Is Pinned?

See `build-lock.env`. That file is the source of truth for the upstream/tool revisions and the official v0.8.4 Linux archive checksum.

The important inputs currently include:

- PSXFunkin
- Funkin v0.8.4 assets
- base-week PS1 reference
- psxavenc
- mkpsxiso

Building against random newer source/assets/tools is a good way to invent bugs nobody else can reproduce.

# Windows

Use [WINDOWS.md](WINDOWS.md). WSL2 + Docker Desktop is the supported sane route.
