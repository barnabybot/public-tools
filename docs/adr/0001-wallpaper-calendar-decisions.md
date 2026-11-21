# ADR 0001: wallpaper calendar rendering and refresh decisions

- Status: Accepted
- Date: 2026-11-21
- Extracted from: `wallpaper-calendar/generate.sh`, `wallpaper-calendar/refresh-system-wallpaper.sh`, and `wallpaper-calendar/wallpaper.html`

## Context

The wallpaper calendar scripts and template relied on inline comments to explain headless Chrome timeout workarounds, macOS wallpaper cache flushing, pre-rendered midnight swaps, OKLCH gradient clamping, and Plash wake recovery. Recording those constraints here keeps the executable scripts and template free of explanatory comments under the comment ratchet.

## Decisions

1. **Hard timeouts and temp outputs for headless Chrome (`generate.sh`, `refresh-system-wallpaper.sh`).** Chrome's updater can keep the headless process alive after the screenshot file is written. Both scripts run Chrome under a hard `perl` alarm timeout, ignore the timeout exit status, and verify that the output PNG is non-empty. Live refreshes write to a temporary file before replacing `system-wallpaper.png` so a failed render cannot clobber the active image.
2. **Pre-rendered midnight swap and display-change reuse (`refresh-system-wallpaper.sh`).** Headless Chrome takes 30 to 40 seconds on wake, which would leave yesterday's date visible past midnight. Each run pre-renders tomorrow's PNG into `out/live/staged-<date>.png` so the next run can swap it in immediately, then performs an authoritative live render and skips a second wallpaper flush when the bytes match. Calling the script with `--apply` reapplies the existing render on display attach or detach without starting Chrome.
3. **WallpaperAgent cache flush (`refresh-system-wallpaper.sh`).** Modern macOS ignores scripted desktop picture updates on some displays when the image path does not change day to day. Restarting `WallpaperAgent` forces macOS to re-read the updated PNG.
4. **Date-seeded layout and colour field (`wallpaper.html`).** Each day seeds a deterministic PRNG that deals the date digits, weekday, month, colour credit, and year across the six-cell hairline grid while keeping the mini calendar anchored in cell 0 at bottom-left. Monthly hex colours convert to OKLCH at runtime for gradient stops. Pale bases clamp the lightness bloom to avoid clipping to white, and ink flips automatically between light and dark unless a month entry sets an explicit `ink` override.
5. **Plash sleep-recovery signals (`wallpaper.html`).** System sleep strands JavaScript timers. Live mode listens to `visibilitychange`, `focus`, `pageshow`, `online`, and a periodic 30-second heartbeat in addition to the midnight timeout so the calendar rolls over promptly after wake.
