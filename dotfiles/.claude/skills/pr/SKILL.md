---
name: pr
description: Create a draft pull request for the current branch. Use when the user asks to "create a PR", "open a PR", "make a pull request", or similar. Inspects the diff, ensures changes are committed, and opens a draft PR via the gh CLI with a concise summary/details body.
---

# Create a PR

## Steps

1. Inspect current `git status` and `git diff` (and `git log <base>..HEAD`) for files changed. Ensure no unintended changes are included.
2. If there are uncommitted changes that should be part of the PR, create a commit with a conventional commit message, e.g. `feat(swizzle-service): implement foobar`. Sign off the commit message with `✨ Created with Claude Code` to indicate it was created by an agent.
3. Consider files changed, context, and the conversation history to craft a well-written pull request body.
4. Write a concise and informative PR description using the template below, saving it to a temporary file (e.g. `$(mktemp -d)/pr-body.md`).
5. Create a **draft** PR with the `gh` CLI:
   ```sh
   gh pr create --draft --title "feat: implement foobar in swizzle service" --body-file /<tmpdir>/pr-body.md
   ```
6. Open the PR in the browser after creation:
   ```sh
   gh repo view --web --branch <branch-name>
   ```

## PR Template

```
# Summary

1-3 sentences of concise but informative PR description for this branch. Provide relevant context or motivation for the changes, but avoid implementation details (save those for the details section).

# Details

- 3 (min) to 5 (max) bullet points here
- keep bullet points high level, concrete, and readable at a glance
- max of ~25 words per bullet point


Resolves <Linear / Jira ticket link here, if applicable>
```

## Style

Err on the side of brevity and clarity in the PR description. Avoid dumping a wall of text. If there are important contextual details that reviewers need to understand specific pieces of the PR, they can be added later in a self-review cycle instead of overloading the PR description.
