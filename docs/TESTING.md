# Testing

There are three different levels of "works" here:

1. the source/build scripts pass,
2. the disc runs in an emulator,
3. the disc behaves correctly on an actual PlayStation.

We care about all three.

# Quick Checks

Before a PR:

```bash
./check.sh
```

For runtime changes, build the current WIP:

```bash
./dev.sh build
./play.sh
```

# DuckStation

DuckStation is the main fast test target. Test the exact thing you changed instead of only booting to the title screen and calling it a day.

For visual changes, compare motion as well as screenshots. Timing, VRAM uploads, texture corruption, and CD streaming bugs can look fine for one frame.

# Real Hardware

If your change touches any of these, real-hardware testing is especially useful:

- CD/XA/STR streaming
- memory or stack usage
- GPU/VRAM uploads
- controller/input timing
- save/memory-card code
- anything that is suspiciously perfect only in an emulator

Burned-disc testing should use the generated MODE2/2352 BIN/CUE.

# Bug Reports

Please include:

- commit SHA,
- emulator + version or PS1 model,
- what you expected,
- what actually happened,
- exact steps to reproduce,
- logs/error codes if there are any,
- a screenshot/recording when it helps.

CI passing is useful. It is not proof that the PS1 agrees with us.
