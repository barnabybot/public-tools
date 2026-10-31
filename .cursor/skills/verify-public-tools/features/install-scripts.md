# Install scripts

## Sub-features

- `install-present` — `wallpaper-calendar/install.sh` exists and is executable.

## How to get to it (user POV)

- Run install.sh from README.

## Driving it with preview-shots

- `test -x wallpaper-calendar/install.sh`
- Do **not** run install in automated proof (may touch LaunchAgents / wallpaper).
- **Proof.** Presence check transcript.

## Gotchas

- install.sh is consequential — presence only for verify.
