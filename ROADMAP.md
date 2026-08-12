# Roadmap

This is the rough order of operations. It is not a promise that the PS1 will behave itself.

## Right Now

### STR playback

Get the generic STR/MDEC movie path actually decoding clean frames on runtime/hardware.

Current WIP has the v9 callback/completion diagnostics. Do not build more cutscene systems on top of it until the low-level player is proven.

### Public build

Get a fresh clone through setup + the complete WIP build without relying on old private CI state.

## Main Port

- finish Freeplay parity
- finish Character Select parity/cleanup
- finish the real in-song pause menu
- finish base Weeks 2, 5, and 6
- finish Weekend 1 events + cutscenes
- finish LE SSERAFIM content
- finish Pico Mixes + Pico Freeplay/animations
- finish console-relevant options + save behavior
- full memory/RAM/VRAM/disc-size pass
- real-hardware regression pass

## Release Candidate Stuff

- every required song boots and finishes
- no missing required assets
- cutscenes can play/skip safely
- memory-card behavior is sane
- no emulator-only dependencies
- clean build from the public repo
- credits/licenses/notices are complete
- disc still fits

## Extra Weird Stuff

Achievements, multiplayer, animated intros, and other treats are **after** the required game fits and works. Cool extras do not get to eat the disc before the actual game is done.
