# Wallpaper calendar

## Sub-features

- `wallpaper-one-shot`: Chrome shot of `wallpaper.html`.
- `wallpaper-full-export`: 48 PNGs from `generate.sh`, optional.

## How to get to it (user POV)

In Plash, choose Add Website and enter the file URL of
`wallpaper-calendar/wallpaper.html` without query parameters. The page shows
today's date, the month calendar and a monthly colour. It rearranges the layout
from a date seed and follows the system appearance. URL parameters can override
the date, style, appearance and font. G toggles the column grid.

For static images, run `./generate.sh [year]` from `wallpaper-calendar/`. It
renders twelve months, gradient and solid styles, and two display resolutions.
Set a generated PNG in System Settings. The system-wallpaper installer has its
own [feature entry](install-scripts.md).

## Source evidence

- Live selection and appearance: `wallpaper-calendar/wallpaper.html:209-228`.
- Colour, seeded layout and calendar: `wallpaper-calendar/wallpaper.html:230-350`.
- Grid and midnight/wake signals: `wallpaper-calendar/wallpaper.html:358-377`.
- Export loops and fixed Chrome path: `wallpaper-calendar/generate.sh:4-42`.

## Live recipe

From the repository root, after doctor:

```bash
.agents/skills/verify-public-tools/scripts/wallpaper-shot 2026 1 gradient 1280 720
```

Expect a fresh 1280 × 720 PNG and `wallpaper-calendar.json` in the evidence
directory. Inspect the image for the date digits, January, the mini calendar
with one highlighted day, and the Harbour Navy colour credit. The receipt
records the image SHA-256, size and Chrome outcome. The helper uses a fresh
profile and a fresh intermediate image, then removes the profile.

## Gotchas

- The shot sets year, month and style. An omitted day uses today's day of the
  month, clamped to the selected month. On the 5th, the recipe shows 5 January.
- `generate.sh` uses the fixed `/Applications/Google Chrome.app/...` executable.
  The one-shot helper accepts `CHROME`.
- Chrome can write the image before its process exits. A bounded timeout is
  accepted only with a valid PNG produced by that attempt.
- This recipe proves local rendering. Full export, native Plash, overnight
  rollover, wake recovery and macOS wallpaper application remain unverified.
