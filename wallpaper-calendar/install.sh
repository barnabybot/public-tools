#!/bin/bash
# Installs the two LaunchAgents that keep the system wallpaper in step with
# the live Plash page. Safe to rerun.
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
AGENTS="$HOME/Library/LaunchAgents"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

[[ -x "$CHROME" ]] || { echo "Google Chrome not found in /Applications. Install it first."; exit 1; }
mkdir -p "$AGENTS" "$DIR/out/live"

for name in wallpaper-calendar wallpaper-calendar-display-watch; do
  dest="$AGENTS/$name.plist"
  launchctl bootout "gui/$(id -u)" "$dest" 2>/dev/null || true
  sed "s|__DIR__|$DIR|g" "$DIR/$name.plist" > "$dest"
  launchctl bootstrap "gui/$(id -u)" "$dest"
  echo "Loaded $name"
done
