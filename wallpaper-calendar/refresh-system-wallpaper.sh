#!/bin/bash
# Renders today's wallpaper and sets it as the macOS system wallpaper on every
# desktop, so the menu-bar strip and any non-Plash display stay in step with
# the live Plash page. Run by the wallpaper-calendar LaunchAgent
# just after midnight and at login.
#
# Wake latency: headless Chrome takes ~30-40s, which used to leave yesterday's
# date on the lock screen and desktop for the first minute after a wake past
# midnight. Each run now also pre-renders tomorrow's PNG, so the next run swaps
# it in within seconds and lets the fresh render catch up behind it.
# The companion display watcher calls this script with --apply when a screen is
# connected or disconnected, reusing the current render without starting Chrome.
set -euo pipefail

D="$(cd "$(dirname "$0")" && pwd)"
LIVE="$D/out/live"
OUT="$LIVE/system-wallpaper.png"
mkdir -p "$LIVE"

set_wallpaper(){
  osascript -e "tell application \"System Events\" to set picture of every desktop to POSIX file \"$OUT\""
  # The newer wallpaper system ignores scripted sets on some displays until
  # WallpaperAgent restarts; the path is also unchanged day to day, so this
  # flush is what forces the re-read.
  killall WallpaperAgent 2>/dev/null || true
}

if [[ "${1:-}" == "--apply" ]]; then
  [[ -s "$OUT" ]] || { echo "$(date) no rendered wallpaper to apply"; exit 1; }
  set_wallpaper
  echo "$(date) reapplied after display change"
  exit 0
fi

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
PROFILE=$(mktemp -d); trap 'rm -rf "$PROFILE"' EXIT

render(){ # $1 = output file, $2 = query string ("" = live mode, today)
  # Chrome's updater keeps the process alive after the shot lands; hard
  # timeout, then verify the file. Temp name so a failed render can't clobber.
  perl -e 'alarm shift; exec @ARGV' 40 \
    "$CHROME" --headless --disable-gpu --hide-scrollbars \
    --no-first-run --disable-component-update --disable-background-networking \
    --user-data-dir="$PROFILE" \
    --force-device-scale-factor=1 --window-size=5120,2880 \
    --virtual-time-budget=1500 \
    --screenshot="$1.tmp.png" \
    "file://$D/wallpaper.html$2" >/dev/null 2>&1 || true
  if [[ -s "$1.tmp.png" ]]; then mv "$1.tmp.png" "$1"; fi
}

TODAY=$(date +%Y-%m-%d)
STAGED="$LIVE/staged-$TODAY.png"

# 1. Instant swap: last night's pre-render goes up first (~2s), so a wake or
#    login past midnight shows today's date before Chrome even starts.
if [[ -s "$STAGED" ]]; then
  cp "$STAGED" "$OUT"
  set_wallpaper
  echo "$(date) staged swap"
fi

# 2. Authoritative render of today (live mode picks up template edits).
render "$OUT" ""
[[ -s "$OUT" ]] || { echo "$(date) render failed"; exit 1; }
if [[ -s "$STAGED" ]] && cmp -s "$STAGED" "$OUT"; then
  : # staged copy already on screen and byte-identical — no second flush
else
  set_wallpaper
fi
cp "$OUT" "$STAGED"   # same-day reruns swap the current bytes, skipping the flush

# 3. Pre-render tomorrow for the next instant swap; drop older staged files.
TM=$(date -v+1d +%Y-%m-%d)
render "$LIVE/staged-$TM.png" "?year=$(date -v+1d +%Y)&month=$(date -v+1d +%m)&day=$(date -v+1d +%d)"
find "$LIVE" -name 'staged-*.png' ! -name "staged-$TM.png" ! -name "staged-$TODAY.png" -delete
echo "$(date) refreshed"
