# Releasing

Public releases are **source-only for now**.

Funkin's asset repository marks the game's art/audio/video/content as proprietary and not for public redistribution. Do not attach a generated game BIN/CUE to a public GitHub release unless the necessary redistribution rights have been explicitly cleared.

# Source Prerelease

The repo has a `Source release` workflow. Push a tag beginning with `v`:

```bash
git tag -a v0.1.0 -m "v0.1.0"
git push origin v0.1.0
```

GitHub Actions runs source checks and creates a prerelease with generated notes. GitHub automatically provides source ZIP/TAR archives.

# Before Tagging

- `./check.sh` passes
- current `main` is the commit you actually want to tag
- `CHANGELOG.md` is updated
- `docs/STATUS.md` is honest about what works
- licensing/credits are still accurate
- if you have a local full build, save `out/BUILD-MANIFEST.txt` somewhere with your test notes

# Test Builds

Contributors can build their own local BIN/CUE from official sources using the compiling guide. The public workflow intentionally uploads only non-game reports/checksums, not the generated disc image.
