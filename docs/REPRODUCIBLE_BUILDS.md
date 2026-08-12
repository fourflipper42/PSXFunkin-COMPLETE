# Reproducible Build Inputs

The goal is simple: if two people are debugging the same commit, they should not secretly be building against different upstream repos/tools.

`build-lock.env` pins the important moving parts:

- PSXFunkin commit
- Funkin asset commit
- base-week reference commit
- psxavenc commit
- mkpsxiso commit
- official Funkin v0.8.4 Linux archive + SHA-256

`setup.sh` reads that file directly. `./check.sh` rejects missing/non-exact Git pins.

After a successful build, `out/BUILD-MANIFEST.txt` records the port commit, all build-lock values, the disc/executable hashes, and output sizes.

# Is The BIN Byte-For-Byte Reproducible Yet?

Not guaranteed.

Host/container package versions are not completely frozen to individual package hashes yet, and old PS1 tooling can have its own nondeterminism. The important source/tool revisions are pinned now, which makes bug reports much more useful, but do not call two builds "identical" unless their SHA-256 values actually match.

If exact deterministic output becomes a release requirement, the next step is pinning the container image by digest and freezing every apt/toolchain package used by that image.
