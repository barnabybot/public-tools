# Wallpaper calendar

## Sub-features

- `wallpaper-one-shot` — Chrome shot of wallpaper.html.
- `wallpaper-full-export` — generate.sh (optional).

## How to get to it (user POV)

- Live desktop: in Plash, Add Website with the `file://` URL of `wallpaper-calendar/wallpaper.html` and no query string (`wallpaper-calendar/README.md` Set up). No `month` param means live mode.
- Static PNGs: `cd wallpaper-calendar && ./generate.sh [year]` (README "Static PNGs"). Optional for verification.
- System-wallpaper install is a different feature. Do not run `install.sh` to reach this page.

## Driving it with preview-shots

- `.cursor/skills/verify-public-tools/scripts/wallpaper-shot 2026 1 gradient`
- **Proof.** Non-empty PNG in evidence dir.

## Gotchas

- Same Chrome timeout behaviour as private tools repo copy.
- The one-shot URL sets `year`, `month`, and `style` only. With `month` set and `day` omitted, `wallpaper.html` uses today's day-of-month, clamped to that month — not day 1. On the 5th, `wallpaper-shot 2026 1 gradient` is 5 January.
- `generate.sh` always calls `/Applications/Google Chrome.app/...` and does not read `CHROME`. The one-shot helper does.
