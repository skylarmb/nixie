---
name: checks
description: Inspect failing CI checks for a PR using the `pr-checks` util script. Use when the user asks to "check CI status", "see what's failing", "look at PR checks", "why is CI red", or similar. Surfaces failing GitHub Actions jobs with their failed-step log tails so you can diagnose without leaving the terminal.
---

# Check CI Status

## Steps

1. Determine the PR to inspect:
   - If the user names a PR number or URL, use that.
   - Otherwise, get the current branch's PR: `gh pr view --json number -q .number`. If there's no PR yet, tell the user — `pr-checks` requires one.
2. Run the `pr-checks` shell helper (already on `$PATH`):
   ```sh
   pr-checks <PR_NUMBER_OR_URL>
   ```
   Output includes:
   - Header line with PR title and URL.
   - One block per failing check (skips passing/pending/skipped/cancelled), with workflow/job name, link, and the tail of failed-step logs (truncated to 50 lines per job).
   - Or `No failing checks.` if everything passed.
3. Read the failure logs and propose a concrete fix plan. If a failure is unclear from the truncated log, fetch the full log with `gh run view --repo <owner/repo> --job <jobId> --log-failed` (the `link` and `jobId` are visible in the `pr-checks` output).
4. **Wait for user confirmation** of the fix plan before making changes.

## Notes

- `pr-checks` only surfaces failures — silence means green. Don't infer "no checks ran" from empty output; use `gh pr checks <PR>` directly if you need the full state.
- Non-Actions checks (e.g. third-party CI) will appear in the list but with no log body — follow the link to investigate.
