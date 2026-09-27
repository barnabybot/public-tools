# Calendar wallpaper

A macOS desktop wallpaper that shows today's date, a mini calendar for the
month and one colour per month. The layout is dealt again each day from a
date-seeded shuffle. The same date always gives the same layout.

One HTML page drives it. It runs live on the desktop through Plash, and it
exports static PNGs through headless Chrome.

## Requirements

- **macOS.** The system-wallpaper sync uses launchd, AppleScript and a Swift
  display watcher.
- **[Plash](https://apps.apple.com/app/plash/id1494023538)** (free, Mac App
  Store). Plash shows the live page as the desktop. Without it you get the
  static PNGs only.
- **[Google Chrome](https://www.google.com/chrome/)** in `/Applications`.
  Headless Chrome renders the PNGs for `generate.sh` and for the daily
  system-wallpaper refresh.
- **Xcode Command Line Tools** (`xcode-select --install`) for the display
  watcher. Optional: skip it if you use one screen.

## Set up

1. Clone this repo anywhere, for example `~/Projects/public-tools`.
2. In Plash, choose **Add Website** and enter the file URL of
   `wallpaper.html`, for example
   `file:///Users/<you>/Projects/public-tools/wallpaper-calendar/wallpaper.html`.
   With no query parameters the page runs in live mode. It shows the current
   month, rings today, rolls over at midnight and follows macOS light and
   dark appearance.
3. Run `./install.sh`. This loads two LaunchAgents:
   - a daily refresh at 00:04 and at login, which renders today's PNG with
     Chrome and sets it as the system wallpaper on every desktop. The menu-bar
     strip, the lock screen and any display without Plash then match the
     live page. Each run also pre-renders tomorrow, so a wake after midnight
     updates in seconds.
   - a display watcher, which reapplies the current PNG when a screen is
     connected or disconnected.

   Approve the automation prompt if macOS shows one on the first run.

To remove the agents:

```bash
for n in wallpaper-calendar wallpaper-calendar-display-watch; do
  launchctl bootout "gui/$(id -u)" ~/Library/LaunchAgents/$n.plist
  rm ~/Library/LaunchAgents/$n.plist
done
```

## Static PNGs

```bash
./generate.sh          # current year
./generate.sh 2027     # any other year
```

This writes 12 months × 2 styles (gradient, solid) × 2 resolutions to `out/`.
The default resolutions are 5120×2880 (Studio Display) and 4480×2520 (24-inch
iMac). Edit `RESOLUTIONS` in `generate.sh` for other screens. Set a PNG in
System Settings → Wallpaper.

## Configuration

All settings are in the `CONFIG` block at the top of `wallpaper.html`:

- **`palette`**: 12 entries of `name`, `hex` and `moods`. The hex drives the
  fill, the gradient (converted to OKLCH at runtime) and the printed colour
  credit. Add `ink:"dark"` or `ink:"light"` to a month to override the
  automatic ink flip.
- **`defaultStyle`**: `gradient` or `solid`.
- **`appearance`**: `light`, `dark` or `auto` (follows macOS in live mode).
- **`font`**: `helvetica` (default) or `mono`. Both are system fonts.
- **`weekNumbers`**: ISO week column in the mini calendar (off by default).
- **`mondayFirst`**: week start.

URL parameters override the config:
`wallpaper.html?year=2027&month=3&day=14&style=solid&appearance=dark`.
Add `?grid=1`, or press G in a browser, to show the 12-column grid.

`compare.html` previews one month at a time. `year.html` shows all twelve.

## Notes

- Gradients interpolate in OKLab with a 3% grain layer, which removes most
  banding at 5K.
- The layout keeps content clear of the menu bar, the Dock and the
  desktop-icon column.
