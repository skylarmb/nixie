---
name: address-feedback
description: Fetch and incorporate code review feedback for the current PR. Use when the user asks to "address PR feedback", "fix review comments", "check PR comments", or similar. Pulls comments via `pr-comments`, proposes a plan, and after changes are pushed, marks resolved comments via `resolve-comment`.
---

# Address PR Feedback

## Steps

1. Determine the current PR number (from the current branch via `gh pr view --json number -q .number`, or ask the user if ambiguous).
2. Fetch review feedback using the `pr-comments` shell helper (already on `$PATH`):
   ```sh
   pr-comments <PR_NUMBER>
   ```
   This returns a list of comments in the context of the source code they were made on, plus top-level comments on the PR.
3. Read through the feedback and propose a concrete plan for what to change to incorporate the review. For feedback that is **not actionable** (out of scope, disagreement, etc.), include it in your plan with brief justification for not addressing it.
4. **Wait for user confirmation** of the feedback plan before making changes.
5. After confirmation, make the required changes and push them.
6. Mark addressed comments as resolved using the `resolve-comment` helper (already on `$PATH`):
   ```sh
   resolve-comment <full URL or discussion_rID> <reply body>
   ```
   See `resolve-comment --help` for usage details.
7. Make sure the PR description is not stale due to changes pushed from code review or CI fixes. If it is stale,update it.

## Reply style

Keep reply comments **VERY** short. Examples:
- `fixed in <commit hash>.`
- `addressed by changing A to B.`
- `not addressing, out of scope because <reason>.`
