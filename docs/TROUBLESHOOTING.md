# Troubleshooting

The build has a lot of opportunities to be annoying. Here are the common ones.

# Start With This

```bash
./check.sh
```

If that passes but setup/build does not, rerun the failing command and keep the useful error output.

# "PsyQ compatibility files are missing"

The SDK is not stored in this repo.

Use a compatible converted archive:

```bash
./dev.sh setup --psyq-zip /path/to/psyq-4_7-converted-light.zip
```

Or use the same fetch route as the existing build setup:

```bash
./dev.sh setup --fetch-psyq
```

# Git LFS Files Look Like Tiny Text Files

Run:

```bash
git lfs install
git -C .deps/funkin-assets lfs pull
./dev.sh setup
```

# Setup Got Halfway Through And Died

Usually just rerun it. Setup is meant to reuse downloads/build tools that already finished.

If the dependency trees are genuinely cursed:

```bash
make distclean
./dev.sh setup --fetch-psyq
```

# Podman Permission / SELinux Weirdness

`dev.sh` uses a labeled bind mount on Podman (`:Z`) and `--userns=keep-id`, which is the normal Bazzite/Fedora path.

If you moved the repo onto a filesystem Podman cannot relabel, clone it somewhere under your home directory and try again.

# DuckStation Did Not Open

`play.sh` checks for native `duckstation-qt`, `duckstation`, then the Flatpak build.

If none are installed, it still prints the generated CUE path. Open that file manually in your PS1 emulator.

# The Build Compiles But The Game Is Broken

Welcome to PS1 development.

Check [TESTING.md](TESTING.md) and [STATUS.md](STATUS.md). A successful compiler/CI run only proves the compiler/CI run succeeded. Runtime, CD streaming, VRAM, timing, and real hardware can still disagree.

# Still Stuck?

Open a **Compiling Help** issue and include:

- your OS,
- commit SHA,
- the command you ran,
- the full useful error output.

Please do not post a screenshot containing only the final `FAILED` line. The interesting part is usually above it.
