---
name: resolve-comments
description: Use when the user asks to "resolve PR comments", "resolve feedback", "close out the threads", or similar — after fixes have been pushed and review threads need to be replied to and marked resolved via the `resolve-comment` helper. Complements the `address-feedback` skill (which proposes the plan and makes changes).
---

# Resolve PR Comments

Reply to and resolve GitHub PR review-comment threads in batch using the `resolve-comment` shell helper (already on `$PATH`).

## Usage

```sh
resolve-comment <URL-or-discussion_rID> <reply body>
```

Posts a reply on the thread and marks it resolved.

## ID format gotcha

Accepted forms for the first argument:
- Full URL: `https://github.com/<owner>/<repo>/pull/<N>#discussion_r<id>`
- Prefixed ID: `discussion_r<id>` (uses the current repo)

The `--help` text suggests a bare numeric `<id>` works — **it does not**. Passing `r3173742028` or `3173742028` errors with `expected a PR review-comment URL`. Always include the `discussion_r` prefix.

## Workflow

1. Confirm fixes are committed and pushed (so the SHA in your reply actually exists on the remote).
2. Fetch comment IDs via `pr-comments <PR#>` if you don't already have them — the `discussion_rXXXXXXX` ID is shown at the start of each thread.
3. **Run all `resolve-comment` calls in parallel** — single message with multiple Bash tool calls. The GitHub round-trip is non-trivial; sequential is ~Nx slower for no reason.

## Reply style

Match the `address-feedback` skill's brevity. Lead with the commit SHA:

- `fixed in <sha> — <one-line summary>.`
- `addressed by changing A to B in <sha>.`
- `acknowledged — <reason>. will track separately.` (for out-of-scope items you're closing without a code change)

No wall-of-text replies. The diff and PR description carry the detail.

## Example

```sh
resolve-comment discussion_r3173743644 "Fixed in a70b93d — derive recCtx from record.TraceSpanContext at the top of the worker loop; per-record logs use it, batch-level logs stay on flushCtx."
resolve-comment discussion_r3173744949 "Fixed in a70b93d — extracted const grpcPort = 8081, both info logs use logging.Int(\"port\", grpcPort), net.Listen uses fmt.Sprintf."
```

(Issued as parallel Bash calls in one message.)
