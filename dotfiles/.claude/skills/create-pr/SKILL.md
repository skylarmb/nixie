---
name: create-pr
description: Create a pull request for the current branch. Use when the user asks to "create a PR", "open a PR", "make a pull request", or similar. Inspects the diff, ensures changes are committed, and opens a PR via the gh CLI with a concise summary/details body.
---

# Create a PR

## Steps

1. Inspect current `git status` and `git diff` (and `git log <base>..HEAD`) for files changed. Ensure no unintended changes are included.
2. If there are uncommitted changes that should be part of the PR, create a commit with a conventional commit message, e.g. `feat(swizzle-service): implement foobar`. Sign off the commit message with `✨ Created by [Claude Code/Codex/Gemini/OpenCode/etc]` to indicate it was created by an agent.
3. Consider files changed, context, and the conversation history to craft a well-written pull request body.
4. Write a concise and informative PR description using the template below, saving it to a temporary file `$(mktemp -d)/pr-body.md`.
5. Unless you were asked otherwise, always create a **DRAFT** PR with the `gh` CLI:
   ```sh
   gh pr create --draft --title "feat(swizzle-service): implement foobar in swizzle service backend" --body-file /<tmpdir>/pr-body.md
   ```
6. Open the PR in the browser after creation:
   ```sh
   gh repo view --web --branch <branch-name>
   ```
7. Give a brief update to the user, then immediately continue by using `monitor-pr` skill to monitor for CI status and feedback.

## Style

- Err on the side of brevity and clarity in the PR description. It should be easily scanned in <30 seconds by a human reviewer.
- Avoid dumping a wall of text. If there are important contextual details that reviewers need to understand specific pieces of the PR, they can be added later in a self-review cycle instead of overloading the PR description or details.
- Specific file/line number pointers are usually not needed anywhere in the PR description.
- The PR description should be focused on the context, motivation, and overall change introduced, not the specific code edits that were performed.
- Do not describe verification, linting, or testing steps you performed in the PR description. CI runs against all PRs and is the source of truth, not your local checks. The exception is if a particular description of how an issue was debugged is useful for context.
- Do not describe what didn't change, only what did.
- Do not describe history of the PR or commits. Focus on the current state of the code.

### Examples

BAD, multiple style violations:

```
# Summary

The OIDC/JWT auth runtime lived in @repo/iso-core-ts but can never run in a browser: it requires the confidential OIDC client secret, httpOnly cookie authority, and makes server-side trust decisions. This PR moves it to @repo/server-core-ts, which also unblocks migrating its remaining ~33 global console call sites to the structured logger — the last real runtime gap from the structured-logging rollout.

# Details

- Move auth/jwt/**, auth/oidc/**, auth/cookies.ts, and auth/utils.ts (plus their unit tests) from iso-core-ts to server-core-ts; commit 1 is a pure move with import rewiring.
- Shared auth config, types, and schemas stay isomorphic in iso-core-ts; a few config/schema internals are newly exported for the server package to consume.
- Update consumers (the web frontend, the backend api routes, and the auth middleware) to import the moved symbols from server-core-ts.
- Commit 2 migrates the moved files' global console calls to @repo/server-logger with module-bound child loggers, levels preserved 1:1.
- Verified: typecheck/lint/tests pass on both packages and consumers (67 + 41 + 301 tests); pre-commit clean except a pre-existing lint failure in an unrelated package.
```

GOOD, focuses on the context and change, does not re-describe the file diff:

```
# Summary

The OIDC/JWT auth runtime lived in @repo/iso-core-ts but can never run in a browser: it requires the confidential OIDC client secret, httpOnly cookie authority, and makes server-side trust decisions. This moves it to @repo/server-core-ts, and migrates the remaining global console call sites to the structured logger.

# Details

- Moves JWT, OIDC, and cookies modules (plus utils and unit tests) from iso-core-ts to server-core-ts.
- Exports shared isomorphic auth types and consumes them in server-core-ts.
- Updates consumers to import the moved symbols from server-core-ts.
- Migrate the moved files' ~33 global console calls to @repo/server-logger following existing patterns. ```

## PR Template

Follow this template exactly.

```
# Summary

1-3 sentences of concise but informative PR description for this branch. Follow the style guidelines from above. The overall summary section should be similar in length to this placeholder paragraph text in this template. Keep it high level, concrete, and readable at a glance by a human reviewer.

# Details

- 2 (min) to 4 (max) bullet points here.
- bullet points should provide details related of the changes from the summary section
- use maximum of ~1 line of text per bullet point, 80-100 characters.

Resolves <Linear / Jira ticket link here, if applicable>
```
