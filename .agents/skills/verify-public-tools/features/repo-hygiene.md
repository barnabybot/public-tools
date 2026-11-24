# Repository hygiene tools

## How to get to it (user POV)

Contributors can run the comment scanner in audit or ratchet mode and the
binary ratchet before committing. `.githooks/pre-commit` checks staged files.
`.githooks/pre-push` checks the full tree, compiles Python and parses shell
scripts. Hook installation is separate from running these scripts directly.

The `/delete-comment` skill is discoverable through `.cursor/skills` and
`.claude/skills`. It classifies comments, extracts decision records into ADRs,
files issues for implementation defects and tightens the baseline after a
comment removal pass. The verification recipe exercises discovery and the
read-only audit. Mutation and issue creation require their own task scope.

## Source evidence

- Scanner CLI and read-only audit: `scripts/check_code_comments.py:1168-1238`.
- Tracked-file ratchet and baseline handling: `scripts/check_code_comments.py:1093-1196`.
- Binary scanner CLI: `scripts/check_binary_ratchet.py:80-105`.
- Actual local hooks: `.githooks/pre-commit:3-5`, `.githooks/pre-push:3-9`.
- Repeatable comment workflow: `.agents/skills/delete-comment/SKILL.md:18-51`.
- Skill aliases: `.cursor/skills/delete-comment`, `.claude/skills/delete-comment`.

The canonical scanner and delete-comment skill changed in `bf7effbc` (#7).
The pre-push hook was added in `cc6f514` (#6). These concrete contributor
surfaces belong in the verification map alongside the wallpaper utility.

## Live recipe

From the repository root, after doctor:

```bash
.agents/skills/verify-public-tools/scripts/verify repo-hygiene
```

The drive runs both CLIs' help, comment `--audit` and `--ratchet`, and the binary
ratchet. It resolves both delete-comment aliases and the ADR index. It executes
both hooks directly without installing them or pushing. Temporary Python
bytecode is confined to the evidence directory and removed on exit.

Expect `repo-hygiene.json` with command, exit status and output for each check.
Review the audit findings even when its exit status is zero. Audit reports
candidate removals; it does not classify or delete them. This recipe never
calls `--write`, `--write-baseline`, `gh issue create` or a push command. Preserve
any existing baseline failure as a product finding.
