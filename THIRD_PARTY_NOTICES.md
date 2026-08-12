# Third-Party Stuff

PSXFunkin COMPLETE sits on top of a pile of other projects. Keep their names and licenses attached to their work.

## PSXFunkin

The generated game source starts from `cuckydev/PSXFunkin` at commit `850e0207479d8fb658bdc7637f6bfbc28a2b4066`.

The upstream PSXFunkin repository identifies its code as **Mozilla Public License 2.0 (MPL-2.0)**. PSXFunkin-derived source files and modifications remain subject to the MPL where applicable.

## PSXFunkin Flop Engine reference

The base-week conversion reference is `Nintendo-Bro385/PSXFunkin-Flop-Engine` at commit `b3f4c5ff0f7656af8ed17498de6b6d7b7a8d967e`. Its repository identifies its code as **MPL-2.0**.

## Friday Night Funkin'

Funkin Crew's game source is published under **Apache License 2.0**. Their art, audio, video, music, characters, and other game content are a separate thing.

The `funkin.assets` repository says that game Content is proprietary, all rights reserved, and may not be publicly distributed by anyone but the copyright owner. Because of that, this repository stores conversion/build code instead of committing a second copy of those assets, and the public CI/release workflows do not upload generated game BIN/CUE files.

`Friday Night Funkin'` and its logo are trademarks of The Funkin' Crew Inc.

## psxavenc

`WonderfulToolchain/psxavenc` is pinned at `82f3871c5fe5e82e71016a6636aba25ddddf2ca8` and is licensed under the **zlib License**.

## mkpsxiso

`CookiePLMonster/mkpsxiso` is pinned at `e36a207a7e20c8f5ccfd58cf0906aae9d2192e58` and is licensed under **GNU GPL v2.0**. It is used as an external build tool; it is not vendored into this repository.

## PsyQ

Sony PsyQ files are **not included in this repository** and are not published by the CI/release workflows. Contributors must supply a compatible SDK/archive they are legally allowed to use.

## Mods / other material

Any third-party mod, code, asset, or tool not listed above remains owned/licensed by its respective author/project. Do not remove attribution just because the file is being converted for PS1.
