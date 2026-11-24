# Wallpaper previews

## How to get to it (user POV)

Open `wallpaper-calendar/compare.html` in a browser. Choose a month, day and
gradient or solid style to update its wallpaper frame. Open
`wallpaper-calendar/year.html` to see all twelve months. Its day and style
controls update every frame.

## Source evidence

- Comparison controls and frame URL: `wallpaper-calendar/compare.html:20-51`.
- Twelve-month grid and controls: `wallpaper-calendar/year.html:22-51`.
- Date clamping in the shared template: `wallpaper-calendar/wallpaper.html:221-225`.

Both preview pages currently set `year=2026` in frame URLs, at `compare.html:42`
and `year.html:44`. Neither page has a year control. Keep this product limitation
visible when reviewing later years.

## Live recipe

From the repository root, after doctor:

```bash
.agents/skills/verify-public-tools/scripts/verify wallpaper-previews
```

The drive opens fresh headless Chrome with Python Playwright. It selects
February, enters day 31 and chooses solid style in the comparison page. It
checks the rendered month, clamped day and solid background inside the frame.
It then changes the year overview to day 31 and solid, checks all twelve frames
and records the rendered years. It fails on browser page errors.

Expect `wallpaper-previews.json`, `compare-dom.html` and `year-dom.html` in the
evidence directory. The context closes and the isolated profile is removed.
This checks actual controls and frame content. Visual layout, native Safari
and Plash need separate checks.
