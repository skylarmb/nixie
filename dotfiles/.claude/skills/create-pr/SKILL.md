---
name: create-pr
description: Create a pull request for the current branch. Use when the user asks to "create a PR", "open a PR", "make a pull request", or similar. Inspects the diff, ensures changes are committed, and opens a PR via the gh CLI with a clear description for teammates.
---

# Create a PR

## Steps

1. Inspect current `git status` and `git diff` (and `git log <base>..HEAD`) for
   files changed. Ensure no unintended changes are included.
2. If there are uncommitted changes that should be part of the PR, create a
   commit with a conventional commit message, e.g. `feat(swizzle-service):
   implement foobar`. Sign off the commit message with `✨ Created by [Claude
   Code/Codex/Gemini/OpenCode/etc]` to indicate it was created by an agent.
3. Consider files changed, context, and the conversation history to craft a
   well-written pull request body.
4. Write the PR description using the guidance below. Save it to a temporary
   file `$(mktemp -d)/pr-body.md`.
5. Unless you were asked otherwise, always create a **DRAFT** PR with the `gh`
   CLI:

   ```sh
   gh pr create --draft \
     --title "feat(swizzle-service): implement foobar" \
     --body-file /<tmpdir>/pr-body.md
   ```

6. Open the PR in the browser after creation:

   ```sh
   gh repo view --web --branch <branch-name>
   ```

7. Give a brief update to the user, then immediately continue by using
   `monitor-pr` skill to monitor for CI status and feedback.

## PR description guidance

### Audience and tone

Write for teammates the author works with every day. Explain the change as you
would in a normal conversation with a colleague.

- Assume familiarity with the product, but explain this change without requiring
  the ticket, earlier conversations, or knowledge of the affected code.
- Use familiar words and direct sentences. Prefer "saves your choice in the
  browser" to "persists client-side preference state."
- Name the visible behavior before its implementation. Explain what a technical
  term means here when it is needed.
- Use technical names when they help the reader locate or understand the change.
  Avoid dense strings of acronyms and code identifiers.
- Natural contractions, parentheses, and phrases such as "This also adds" are
  fine. Do not force slang, jokes, or a formal documentation voice.
- State real uncertainty directly, such as "The settings screen is still a
  draft." Do not make the description sound more settled than the work is.

For PR descriptions, this audience and tone guidance takes precedence over
conflicting wording rules in `ste-writing`.

### Content and shape

- Start with what the PR changes. Add the previous limitation or motivation when
  it helps explain the change.
- Match the length to the explanation. A small fix may need one or two
  sentences. A broader change may need several distinct points.
- Choose paragraphs, bullets, or examples to suit the content. There is no
  required template, sentence count, or bullet count.
- Keep details that explain behavior, rationale, dependencies, or meaningful
  constraints. Include a scope boundary when readers could reasonably expect a
  broader change.
- Omit routine inventories of files, imports, manifests, compiler settings, and
  other edits that are clear from the diff. File and line pointers are rarely
  needed.
- Use a small example or available screenshots when they explain the result more
  clearly than prose. Before/after headings and tables are useful for
  comparisons.
- Do not include local test counts or verification, lint, and build reports. CI
  is the source of truth. Include debugging details only when they explain the
  problem or solution.
- Describe the current change. Omit the sequence of commits, earlier approaches,
  and repeated details. Link related PRs when the dependency helps explain this
  one.
- End with `Resolves` or `Part of` and the actual ticket link when applicable.
  Omit this line when there is no ticket.

### Examples

These examples are fictional. They illustrate different shapes, not required
sections or wording. Use generic examples when maintaining this public skill; do
not copy internal PR text, identifiers, or links.

Small fix:

```text
Hides the download button when a report has no files. The empty state now
explains that there's nothing to download.
```

Several related UI changes:

```text
Adds a compact layout to the reading list so more books fit on screen. You can
switch layouts from the toolbar, and the browser saves your choice.

- Show the title and author on one line in the compact layout.
- Keep the toolbar visible while scrolling.
- Show an unread marker beside each book you haven't opened.
- Keep keyboard navigation consistent across both layouts.
- Show a helpful empty state when a filter has no matches.
```

A change that benefits from an example and rationale:

````markdown
The image converter previously accepted files only at the top level of
`images/`. It now reads nested folders and keeps their structure in the output:

```text
images/                    converted/
├── cover.png              ├── cover.webp
└── icons/                 └── icons/
    └── search.png             └── search.webp
```

This lets us organize images into folders without having to flatten them before
conversion. It also keeps files with the same name in separate folders.
````

### Final read

Read the description as a teammate who knows the product but has not followed
this work. Can they understand what changed and why? Replace jargon that makes
them reconstruct the meaning. Remove sentences that repeat a point or add no
useful context.
