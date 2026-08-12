# Assets

The repo stores **conversion code**, not a second copy of Funkin's asset library.

# Where Sources Come From

The setup scripts pin the official Funkin v0.8.4 asset revision and use the official v0.8.4 Linux release where the shipped game contains a source file that is not present in the normal asset tree.

PSXFunkin and a pinned PS1 conversion reference are also fetched during setup.

# Do Not Commit Downloaded Assets

Do not add any of these to Git:

- downloaded Funkin PNG/XML/JSON/audio/video files,
- generated TIM/ARC/XA/STR files,
- BIN/CUE/ISO images,
- PsyQ SDK files,
- random ripped assets from somebody else's build.

The generated/fetched directories are already ignored for a reason.

# Authentic Source Rule

When the port needs official game art/animation, use authentic source material and adapt it to PS1 limits.

Good adaptations include palette conversion, nearest-neighbor resizing where appropriate, splitting texture pages, converting audio/video formats, and changing runtime layout to fit hardware limits.

Do **not** invent a replacement frame or redraw missing official artwork just to fill a hole. If the source is missing, leave the gap visible and document it.

# Third-Party Stuff

Keep the original author/project attribution when a contribution uses third-party code or permitted third-party material. Do not remove existing credits to make the repository look cleaner.

If you're unsure whether something can be committed publicly, ask before putting it in a PR.
