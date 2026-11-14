# Install scripts

## Sub-features

- `install-present` — `wallpaper-calendar/install.sh` exists and is executable.

## How to get to it (user POV)

- From `wallpaper-calendar/`, run `./install.sh` (`wallpaper-calendar/README.md`, Set up step 3). The repo root README only links to that directory.

## Driving it with preview-shots

- `test -x wallpaper-calendar/install.sh`
- Do **not** run install in automated proof (may touch LaunchAgents / wallpaper).
- **Proof.** Presence check transcript.

## Gotchas

- install.sh is consequential — presence only for verify.
