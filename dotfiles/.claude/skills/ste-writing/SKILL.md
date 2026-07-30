---
name: ste-writing
description: Write durable technical prose in ASD-STE100 Simplified Technical English. Short declarative sentences, active voice, one name per thing, no hedging, no marketing adjectives. Apply this automatically, without being asked, to any text that persists as an artifact for other people to read: code review comments and feedback, code comments and docstrings, commit messages, PR titles and descriptions, READMEs, AGENTS.md files, RFCs and design docs, changelogs and release notes, error messages, log lines, CLI help text, and issue or ticket descriptions. It does not apply to chat replies to the user, to code itself, or to prose that needs a voice such as blog posts and marketing copy.
---

# ste-writing

ASD-STE100 Simplified Technical English is a controlled writing standard from the aerospace industry. It exists because a maintenance manual gets read under pressure, by a person who did not write it. A code comment, a commit message, and an incident runbook are read the same way. This skill applies that standard to software artifacts.

STE strips voice on purpose. That is what makes it correct for artifacts and wrong everywhere else.

## When to use this voice

Apply it by default, without waiting to be asked, when you write:

- code review comments, and replies to review feedback
- code comments and docstrings
- commit messages, PR titles, PR descriptions
- READMEs, docs, RFCs, design docs, ADRs, `AGENTS.md` files
- changelogs and release notes
- error messages, log lines, CLI help text
- issue and ticket descriptions

For cases not on this list, use this test: **will someone read this later, without you there to explain it?** If yes, write it in this voice. These artifacts outlive the context that produced them. A reader six months from now has the words and nothing else.

## Where it does not apply

- **Chat with the user.** Answers, explanations, status updates, and questions are not artifacts. Write those normally.
- **Code.** Identifiers, command syntax, API names, and test names follow the conventions of the codebase.
- **Prose that needs a voice.** Blog posts, essays, marketing copy, anything persuasive. STE removes the range those need.

When the user asks for a rewrite of a specific piece of text, return the rewritten text alone. No preamble, no summary, no closing remarks. When you write an artifact inside a larger task, only the artifact takes this voice. The conversation around it stays normal.

## Rules

WORDS
- Use one name for one thing. Do not call the same item by two different names.
- Use the short common word: start (not begin/commence/initiate), use (not utilize/leverage), help (not facilitate), make sure (not ensure), before (not prior to), after (not subsequent to), about (not regarding/concerning), get (not obtain/acquire), show (not demonstrate), also (not additionally/furthermore/moreover).
- Give each word one meaning. "fall" means to move down, not to decrease.
- No marketing adjectives: seamless, robust, powerful, cutting-edge, effortless, world-class, next-generation, revolutionary.
- American spelling.

VERBS
- Active voice. "the parser reads the file", not "the file is read by the parser".
- Use a verb for an action. "analyze the log", not "perform an analysis of the log".
- No stacked auxiliaries. Not "it is important to note that this may help to improve". Write "this improves X".
- No "-ing" main verb where a simple tense works.
- No phrasal verbs: start (not spin up), call (not reach out to), read (not dive into), check (not look into).

SENTENCES
- One instruction per sentence. Max 20 words (instruction), max 25 (descriptive).
- No contractions. Use articles: a, an, the, this, these.

PUNCTUATION
- No semicolons. Write two sentences.
- No em dashes in a sentence. Use a period, a comma, or parentheses.

STRUCTURE
- One topic per paragraph, max six sentences. For steps, use a numbered vertical list, one action per item, imperative form. Put a condition before its command.

## Modes

- **strict** — error messages, runbooks, procedures, safety text: apply every rule and both length caps.
- **STE-flavored** — general prose (READMEs, PR descriptions, docs, comments): apply the sentence, paragraph, active-voice, and no-phrasal-verb discipline. Relax the ~900-word dictionary lockdown so the text keeps enough range to read naturally.

## Six slop patterns

Each pattern has a mechanical fix. The self-lint below refers to them by these names.

**1. Synonym rotation** — one thing under three names.
Before: The client sends a token. The caller must refresh the token before the user retries.
After: The client sends a token. The client refreshes the token before it retries.

**2. Hedging** — a claim padded until it says nothing.
Before: This should hopefully prevent most instances of the race condition.
After: This prevents the race condition when only one writer exists.

**3. Frozen verbs** — an action buried in a noun.
Before: This function performs a validation of the payload.
After: This function validates the payload.

**4. Marketing adjectives** — praise standing in for a fact.
Before: Adds a robust, seamless retry mechanism.
After: Retries a failed request three times, then fails the job.

**5. Run-ons** — several ideas stitched into one sentence.
Before: The worker now retries transient failures instead of failing the whole job, which should reduce the failed syncs we have been seeing in production since the last release.
After: The worker now retries transient failures. It no longer fails the whole job. This removes the most common cause of failed syncs in production.

**6. Phrasal verbs** — two words where one exact word exists.
Before: Spin up a worker, reach out to the API, then dive into the logs.
After: Start a worker, call the API, then read the logs.

## Worked examples

**Code comment**

Before:
```
// This helper is responsible for performing a validation of the incoming
// webhook payload, and it will potentially throw an error if the signature
// doesn't match, which is important to ensure we don't process bad requests.
```
After:
```
// Validates the webhook signature. Throws if the signature does not match,
// so an unverified request never reaches the handler.
```

**Commit message**

Before:
```
fix: improve error handling

This commit refactors the error handling logic in the sync worker to make it
more robust, ensuring transient network failures are handled gracefully and
don't fail the entire job, which should reduce failed syncs in production.
```
After:
```
fix(sync): retry transient network failures

The sync worker failed the whole job on any network error. It now retries a
failed request three times before it fails the job. This removes the most
common cause of failed syncs in production.
```

**PR description**

Before:
> This PR introduces a comprehensive refactor of the caching layer to leverage a more performant LRU implementation, which should significantly improve response times across the board — we're also taking the opportunity to clean up some legacy code paths that were no longer being utilized.

After:
> This changes the cache eviction policy from FIFO to LRU. The old policy evicted hot keys, which sent repeat lookups to the database. Median read latency drops from 40ms to 12ms in the benchmark. This also deletes two unused code paths in `cache/legacy.go`.

Note what the rewrite forces. "Significantly improve response times across the board" survives no scrutiny. "40ms to 12ms" is either true or false. The plain form makes a vague claim visible, and that is most of the value here.

## Self-lint (run before returning text)

1. Any sentence over 20 words? Split it. (run-ons)
2. Same thing named two ways? Pick one name. (synonym rotation)
3. Any nominalization, "-ing" main verb, or phrasal verb? Use a plain verb. (frozen verbs, phrasal verbs)
4. Any hedge, such as should, may, potentially, generally, or "it is important to note"? Cut it, or state the real limit. (hedging)
5. Any adjective that praises instead of informs? Replace it with the fact. (marketing adjectives)
6. Any passive voice with a known actor? Make it active.
7. Any semicolon or em dash inside a sentence? Rewrite with a period, a comma, or parentheses.
8. Any contraction? Expand it.

These rules are mechanical, and that is why they work. Full STE also needs judgment: the right technical noun, whether a sentence makes good sense. A checklist cannot certify that, and slop is not about that. This skill fixes the FORM of slop. It cannot make a hollow paragraph true.

The rules above are enough. Do not go read the ASD-STE100 standard to apply this skill.
