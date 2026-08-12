# Current Status

Very WIP. Very playable in places. Very capable of finding a new and exciting way to break a PlayStation.

# Integrated In The Current WIP Pipeline

- V-Slice-style menu foundation and Freeplay work
- Character Select v7.1 work
- real pause menu work
- missing base Week 2 / 5 / 6 content
- console options + memory-card/save work
- Weekend 1 content/events/cutscenes
- LE SSERAFIM collaboration content
- Pico character/freeplay/mix content

"Integrated" does not mean every part is final or runtime-approved.

# Current Big Blocker

STR movie playback is the main low-level problem being worked on right now.

The movie path can locate/start/return from the test stream, but decoded output has been corrupt on runtime tests. The current WIP has extra MDEC completion diagnostics to narrow that down.

Until that is solved, movie-heavy content should be treated as unfinished even if its conversion/build steps pass.

# Testing Priority

1. real PlayStation behavior
2. DuckStation/runtime testing
3. build/CI validation

A green CI job is not a gameplay test.

# What To Work On

Good contributions right now include:

- STR/MDEC/CD-stream debugging
- hardware testing and reproducible bug reports
- build reliability / Linux setup fixes
- PS1 performance, RAM, VRAM, and disc-layout fixes
- parity fixes that use authentic source assets
- cleanup that makes the port easier to understand without changing behavior

If you're about to rewrite a working subsystem, open an issue first. There may be hardware constraints or old failure cases that are not obvious from one file.
