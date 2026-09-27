#!/bin/bash
# Export the full wallpaper set via headless Chrome.
# Usage: ./generate.sh [year]        (defaults to the current year)
set -euo pipefail

YEAR="${1:-$(date +%Y)}"
DIR="$(cd "$(dirname "$0")" && pwd)"
HTML="$DIR/wallpaper.html"
OUT="$DIR/out"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
PROFILE="$(mktemp -d)"
trap 'rm -rf "$PROFILE"' EXIT

# Detected displays on this machine; add rows as "WxH".
RESOLUTIONS=("5120x2880" "4480x2520")
STYLES=("gradient" "solid")
MONTHS=(january february march april may june july august september october november december)

# Chrome's updater keeps the headless process alive after the shot is written,
# so run each export under a hard timeout and verify the file instead.
shot() { # w h url out
  perl -e 'alarm shift; exec @ARGV' 25 \
    "$CHROME" --headless --disable-gpu --hide-scrollbars \
    --no-first-run --disable-component-update --disable-background-networking \
    --user-data-dir="$PROFILE" \
    --force-device-scale-factor=1 --window-size="$1,$2" \
    --virtual-time-budget=1500 \
    --screenshot="$4" "$3" >/dev/null 2>&1 || true
  [[ -s "$4" ]]
}

mkdir -p "$OUT"
count=0
for m in $(seq 1 12); do
  for style in "${STYLES[@]}"; do
    for res in "${RESOLUTIONS[@]}"; do
      w="${res%x*}"; h="${res#*x}"
      name=$(printf "%s-%02d-%s-%s-%s.png" "$YEAR" "$m" "${MONTHS[$((m-1))]}" "$style" "$res")
      if shot "$w" "$h" "file://$HTML?year=$YEAR&month=$m&style=$style" "$OUT/$name"; then
        count=$((count+1)); echo "[$count] $name"
      else
        echo "FAILED: $name" >&2; exit 1
      fi
    done
  done
done
echo "Done: $count wallpapers in $OUT"
