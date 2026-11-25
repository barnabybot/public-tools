# Install scripts

## Sub-features

- `install-preflight`: shell syntax, expanded LaunchAgent templates and targets.
- `install-boundary`: the actual installer stops inside a read-only sandbox.
- `native-refresh`: daily rendering, wallpaper application and display events.

## How to get to it (user POV)

Run `./install.sh` from `wallpaper-calendar/` after installing Chrome and
configuring Plash. It writes two LaunchAgent definitions and bootstraps them.
The refresh runs at login and 00:04, applies today's image to every desktop and
stages tomorrow's image. The Swift watcher reapplies the image after a display
change. This changes the user's macOS session.

## Source evidence

- Installer writes and launchctl calls: `wallpaper-calendar/install.sh:4-17`.
- Daily schedule: `wallpaper-calendar/wallpaper-calendar.plist:7-20`.
- Watcher entry point: `wallpaper-calendar/wallpaper-calendar-display-watch.plist:7-20`.
- Apply and staging: `wallpaper-calendar/refresh-system-wallpaper.sh:9-18,36-57`.
- Display callback and debounce: `wallpaper-calendar/watch-display-changes.swift:16-69`.

## Live recipe

From the repository root, after doctor:

```bash
.agents/skills/verify-public-tools/scripts/verify install-scripts
```

The drive checks shell syntax and parses both expanded plist templates in
memory. It resolves their executable and script targets. It proves that the
macOS sandbox denies a scratch write, then attempts the actual installer with
all file writes and launchctl execution denied. Expect `Operation not permitted`
from the installer and an `install-scripts.json` receipt. No LaunchAgent files
are created or loaded. No wallpaper is changed.

## Reachability limits

Live activation is `verified-unreachable` within an automated pass that forbids
LaunchAgent writes. The attempted route and sandbox denial are in the receipt.
Its prerequisite is explicit authorisation for native installation and desktop
changes. Daily refresh, overnight staging, Swift compilation, display events
and native application require a separate approved session. The safe recipe
does not claim they work. Keep any pre-existing `wallpaper-calendar/out/`.
