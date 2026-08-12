# GitHub Repo Settings

A few useful settings live on GitHub itself instead of in Git. They need repo-admin access.

## Topics

Recommended:

`ps1`, `playstation`, `friday-night-funkin`, `fnf`, `homebrew`, `psxfunkin`, `game-port`

## Main Branch Rule

For `main`:

- require a pull request before merging for outside contributors
- require the `Source checks / check` status check
- block force pushes/deletion for normal contributors
- keep repository administrators as a bypass so the maintainer can still repair/release the repo

Do **not** require `Full WIP build` yet. It is manual and the current port is still a WIP runtime/build checkpoint.

## General

Useful toggles:

- automatically delete head branches after merge
- allow squash merge
- enable Discussions if you want general port questions/ideas somewhere other than Issues

The source/release workflow files are already in the repository; these settings just make GitHub enforce the intended flow.
