# Compiling

This thing has a lot of moving parts. The helper scripts exist so you don't have to assemble the entire PS1 toolchain by hand every time.

# Recommended: Linux Dev Container

You need **Podman** or **Docker** on the host. Bazzite already ships with Podman, so this is also the least annoying Bazzite setup.

From the repo root:

```bash
./dev.sh setup --fetch-psyq
./dev.sh build
```

The first setup takes a while. It downloads the pinned PSXFunkin source, the exact v0.8.4 Funkin asset revision, the official v0.8.4 Linux build used for a few bundled sources, the base-week conversion reference, `psxavenc`, and `mkpsxiso`.

The finished disc should end up at:

```text
out/PSXFunkin-COMPLETE-WIP.bin
out/PSXFunkin-COMPLETE-WIP.cue
```

Then run:

```bash
./play.sh
```

# PsyQ

PSXFunkin still builds against a converted PsyQ compatibility tree.

The SDK is **not stored in this repository**.

You have two setup options:

```bash
./dev.sh setup --psyq-zip /path/to/psyq-4_7-converted-light.zip
```

or use the same legacy mirror route used by the existing PSXFunkin build setup:

```bash
./dev.sh setup --fetch-psyq
```

If you already have compatible `include/` and `lib/` directories, put them at `.deps/psyq/include` and `.deps/psyq/lib`.

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
./setup.sh --fetch-psyq
./build.sh
```

# Rebuilding

`upstream/` is disposable. The build resets it to the pinned PSXFunkin commit before applying the port again, so don't keep hand edits in there.

Change the public build/apply scripts instead and rebuild.

If your fetched dependencies get mangled:

```bash
make distclean
./dev.sh setup --fetch-psyq
./dev.sh build
```

`distclean` deletes generated/downloaded build trees. It does not touch the tracked source in this repo.

# What Gets Downloaded?

The important pins are:

- PSXFunkin: `850e0207479d8fb658bdc7637f6bfbc28a2b4066`
- Funkin v0.8.4 asset tree: `d1d027d4747aaba151c6df121ea736c31d6aed38`
- Base-week PS1 reference: `b3f4c5ff0f7656af8ed17498de6b6d7b7a8d967e`

Keeping these pinned matters. Building against random newer assets/source will eventually produce extremely stupid bugs.
