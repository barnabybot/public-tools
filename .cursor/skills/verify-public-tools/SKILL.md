---
name: verify-public-tools
description: >
  Verify barnabybot/public-tools (shared Mac tools, currently wallpaper-calendar)
  with a single Chrome screenshot of wallpaper.html. Use after editing the
  calendar template or generate.sh. Prefer one-shot proof over full generate.sh.
---

# verify-public-tools

Proof under `scratchpad/verify-public-tools/`.

## Launch

```bash
test -f wallpaper-calendar/wallpaper.html
test -x wallpaper-calendar/generate.sh
```

## Doctor

`ok: ready` is printed only when both checks pass. On a machine without the Mac Chrome path, export `CHROME` to a Chrome binary first; an empty `CHROME` is not ready.

```bash
test -f wallpaper-calendar/wallpaper.html \
  && { test -x "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" || test -n "${CHROME:-}"; } \
  && echo 'ok: ready'
```

## Drive

```bash
RUN_ID=$(date -u +%Y%m%dT%H%M%SZ)
.cursor/skills/verify-public-tools/scripts/wallpaper-shot 2026 1 gradient 1280 720
```

The helper exits 0 when that PNG is non-empty. Headless Chrome may still die with the 25s alarm after the file is written; the helper stops that Chrome and removes its profile, and that signal does not fail the shot.

Optional full export: `(cd wallpaper-calendar && ./generate.sh 2026)`.

## Evidence / Cleanup

PNGs under `scratchpad/verify-public-tools/<RUN_ID>/`. Leave them after Chrome teardown. Never install LaunchAgents in automation.

## Helpers

`.cursor/skills/verify-public-tools/scripts/wallpaper-shot [year] [month] [style] [w] [h]`
