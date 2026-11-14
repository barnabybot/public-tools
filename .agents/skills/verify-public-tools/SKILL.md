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

```bash
test -f wallpaper-calendar/wallpaper.html
test -x "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" || test -n "${CHROME:-}"
echo 'ok: ready'
```

## Drive

```bash
RUN_ID=$(date -u +%Y%m%dT%H%M%SZ)
.cursor/skills/verify-public-tools/scripts/wallpaper-shot 2026 1 gradient 1280 720
```

Optional full export: `(cd wallpaper-calendar && ./generate.sh 2026)`.

## Evidence / Cleanup

PNGs under `scratchpad/verify-public-tools/<RUN_ID>/`. Leave them after Chrome teardown. Never install LaunchAgents in automation.

## Helpers

`.cursor/skills/verify-public-tools/scripts/wallpaper-shot [year] [month] [style] [w] [h]`
