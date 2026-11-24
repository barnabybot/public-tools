---
name: verify-public-tools
description: >
  Verify barnabybot/public-tools with a single wallpaper screenshot, interactive
  preview checks, a sandboxed installer preflight and read-only contributor
  hygiene checks. Use after local changes or when maintaining the feature map.
---

# verify-public-tools

Read [the feature map](features/README.md) and every sibling feature file. Run
each mapped recipe. Keep proof under `scratchpad/verify-public-tools/<RUN_ID>/`
or an explicitly supplied scratch directory. Do not commit proof.

## Launch

Run from the repository root. Each drive is a fresh, short-lived CLI process.
Browser drives start an isolated Chrome profile and remove it on exit. There is
no preview server. The screenshot recipe uses Python 3.9 or later and Chrome.
Preview controls also require Python Playwright. The installer recipe requires
macOS `sandbox-exec`. Use existing dependencies. Report a missing prerequisite
with its attempted command rather than installing it automatically.

## Doctor

```bash
.agents/skills/verify-public-tools/scripts/verify doctor
```

Expect `doctor: ok (all features)`. Run before the first drive and after any
failed drive. Each drive also runs its feature's prerequisite checks.

## Drive

```bash
RUN_ID=$(date -u +%Y%m%dT%H%M%SZ)
export RUN_ID
.agents/skills/verify-public-tools/scripts/wallpaper-shot 2026 1 gradient 1280 720
.agents/skills/verify-public-tools/scripts/verify install-scripts
.agents/skills/verify-public-tools/scripts/verify wallpaper-previews
.agents/skills/verify-public-tools/scripts/verify repo-hygiene
```

Set `SHOT_OUT` to an absolute scratch directory to put durable receipts outside
the worktree. `CHROME` can override Chrome for browser drives. `install.sh` and
`generate.sh` use their fixed `/Applications` Chrome path.

The installer drive first proves that its sandbox denies writes. It then
attempts the real installer with file writes and `launchctl` execution denied.
It never runs the installer without that sandbox. Successful activation remains
`verified-unreachable` when LaunchAgent writes are outside the approved scope.

Prefer the single wallpaper shot. The 48-image export is optional and requires
an explicit full-export task. It is outside these default recipes.

## Evidence / Cleanup

The drives write JSON receipts, Chrome diagnostics, preview DOM snapshots and
one PNG. Inspect the PNG for rendered date digits, month, mini calendar and
colour credit. JSON records PNG dimensions and SHA-256, preview control results,
installer denial and actual scanner/hook output.

An existing image cannot satisfy a new screenshot attempt. Only a fresh valid
PNG of the requested size is promoted. A Chrome timeout can count as a shot
only when that attempt produced the PNG; the receipt records the timeout.

Chrome process groups started by the screenshot drive are bounded and torn
down by PID. The preview context closes in `finally`. Browser profiles and
temporary hook caches are removed. Keep the evidence files. Check for any
remaining process using the run's profile path and clean up only processes
started by this run. Do not kill processes by name.

Never install or enable LaunchAgents, change the desktop wallpaper, write
credentials, file issues or rewrite baselines during these recipes. A preflight
does not prove native wallpaper application, Plash, wake recovery or display
events. Record those limits in the report.

## Helpers

- `scripts/wallpaper-shot [year] [month] [style] [width] [height]`
- `scripts/verify doctor|wallpaper-calendar|install-scripts|wallpaper-previews|repo-hygiene`

Both helpers are executable. Use paths relative to this skill directory or the
full repository-root commands above. No agent login is required.
