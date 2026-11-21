#!/bin/bash
set -euo pipefail

D="$(cd "$(dirname "$0")" && pwd)"
LIVE="$D/out/live"
OUT="$LIVE/system-wallpaper.png"
mkdir -p "$LIVE"

set_wallpaper(){
  osascript -e "tell application \"System Events\" to set picture of every desktop to POSIX file \"$OUT\""
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

render(){
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

if [[ -s "$STAGED" ]]; then
  cp "$STAGED" "$OUT"
  set_wallpaper
  echo "$(date) staged swap"
fi

render "$OUT" ""
[[ -s "$OUT" ]] || { echo "$(date) render failed"; exit 1; }
if [[ -s "$STAGED" ]] && cmp -s "$STAGED" "$OUT"; then
  :
else
  set_wallpaper
fi
cp "$OUT" "$STAGED"

TM=$(date -v+1d +%Y-%m-%d)
render "$LIVE/staged-$TM.png" "?year=$(date -v+1d +%Y)&month=$(date -v+1d +%m)&day=$(date -v+1d +%d)"
find "$LIVE" -name 'staged-*.png' ! -name "staged-$TM.png" ! -name "staged-$TODAY.png" -delete
echo "$(date) refreshed"
