---
name: monitor-pr
description: Wait for CI on a PR to finish, auto-fix and re-push on failure, then hand off to PR review feedback once green — using the `wait-for-ci` util script. Use when the user asks to "wait for CI", "watch CI", "check CI status", "see what's failing", "why is CI red", or similar. Loops fix-push-recheck until CI passes or a failure looks persistent/unrelated to the branch (e.g. main is broken), then stops and flags the user.
---

# Monitor PR CI

## Steps

1. Determine the PR to inspect:
   - If the user names a PR number or URL, use that.
   - Otherwise, get the current branch's PR: `gh pr view --json number -q .number`. If there's no PR yet, tell the user — `wait-for-ci` requires one.
2. Run the `wait-for-ci` shell helper (already on `$PATH`) in the background, since it blocks until CI finishes:
   ```sh
   wait-for-ci <PR_NUMBER_OR_URL>
   ```
   Output includes:
   - Header line with PR title and URL.
   - Then it blocks, streaming live check status until every check finishes.
   - On success: `✓ All checks passed.`
   - On failure: one block per failing check (skips passing/pending/skipped/cancelled), with workflow/job name, link, and the tail of failed-step logs (truncated to 50 lines per job).
3. If checks failed:
   - Read the failure logs and diagnose the root cause. If a failure is unclear from the truncated log, fetch the full log with `gh run view --repo <owner/repo> --job <jobId> --log-failed` (the `link` and `jobId` are visible in the `wait-for-ci` output).
   - For all relevant CI failures, fix the issue, commit, and push to the branch.
   - For CI fixes that would bloat PR scope or require extensive refactors, STOP. The user has already reviewed the code before the PR was created, so no significant changes should be made without approval.
   - If failures look unrelated to the current branch, especially for flaky integration / e2e tests, retry the relevant jobs either via pushing relevant fixes to the branch or via `gh run rerun --failed`.
   - Go back to step 2 and re-run `wait-for-ci` to recheck.
   - If unrelated failures persist on after a retry / new push, STOP. There may be a broken trunk, infra outage, or other issue. Explain what's broken, confer with the user.
4. When CI is green, mark the draft PR as ready for review (unless it is not a draft). Draft -> Open triggers an automated code review that runs as a CI job, so go back to step 2 and re-run `wait-for-ci` to wait for the review job to complete.
5. Once the code review job is complete, use the `address-feedback` skill to fetch PR review comments and propose a plan. **Confer with the user** on how to proceed before implementing ANY feedback changes.

## Notes

- `wait-for-ci` blocks until CI resolves — run it in the background and check back rather than waiting synchronously.
- Non-Actions checks (e.g. third-party CI) will appear in the failure list but with no log body — follow the link to investigate.
- The fix→push→recheck loop is autonomous (no per-iteration confirmation) — the only gates are step 3's persistent-failure check or fixes that expand scope or require meaningful refactors. Don't loop indefinitely on the same error, the user is available for input and advice.
- External code review / feedback collection may not be started until the PR is green. Do not skip to the feedback stage if any STOP condition is reached or if CI is still red.
