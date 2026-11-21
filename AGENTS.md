# public-tools

Public repository of standalone macOS utilities.

## Packages

- `wallpaper-calendar/` renders a daily calendar desktop wallpaper for macOS using Chrome and Plash.

## Rules

- This repository is public. Keep personal file paths, private hostnames, email addresses, and credentials out of source files, commit messages, and documentation.
- Follow the `verify-public-tools` skill to check changes locally and obtain explicit approval before pushing `main` or cutting a public release.
- Enable the local pre-commit hooks with `git config core.hooksPath .githooks` to run `scripts/check_binary_ratchet.py` and `scripts/check_code_comments.py`.
- Record non-obvious design constraints in `docs/adr/` rather than inline code comments.
