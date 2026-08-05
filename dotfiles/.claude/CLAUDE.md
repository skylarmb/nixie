# General

- When summarizing work you have performed, keep the summary brief and high level. 1-3 sentences or bullet points at most!
- Always comment your code.
- Run project build / lint commands to check your changes before considering a task to be finished.
- Always use efficient methods of exploring the codebase, reading file contents, and parsing command output. Prefer the CLI tools already on `$PATH` (via home-manager) over naive `cat`/`grep`/`find` pipelines, and always read only the slice of output you need — bound with `head`/`tail`, line ranges, `rg` filters, `wc -l`. Never dump an entire large file or unbounded command output into context.

  **Semantic search — use when you don't know the exact symbol:**
  - `semble search "<natural language or code query>" [path]` — embedding search over the repo. Locate behavior by meaning ("where are websocket reconnects handled") before grepping for guessed identifiers. Useful flags: `-k/--top-k N`, `--max-snippet-lines N`, `--content code|docs|config|all`.
  - `semble find-related <file> <line> [path]` — find code similar to a known location.

  **Search, find, transform:**
  - `rg` (ripgrep) — default for exact string/regex search. Prefer over `grep`.
  - `fd` — fast file/directory finder. Prefer over `find`.
  - `sd` — simple find-and-replace in files or pipes. Prefer over `sed` for straightforward substitutions.
  - `jq` — query/rewrite JSON. Never scrape JSON with regex when `jq` will do.
  - `htmlq` — CSS selectors over HTML (docs pages, CI HTML, fixtures).
  - `tree-sitter` — parse/query source structure when regex isn't enough.

  **Examples:**

            Example: find code by meaning when you don't know the symbol name
            Good: semble search "retry logic for failed HTTP requests" -k 10
            Bad: rg -i retry && rg -i http && rg -i fetch  # guessing identifiers blindly

            Example: count occurrences of a lint violation without drowning in output
            Good: npm run lint 2>&1 | rg @typescript-eslint/no-unused-vars | wc -l
            Bad: npm run lint

            Example: check whether Foo is imported in a file
            Good: rg -n 'import.*Foo' components/Message/ReasoningMessage.tsx
            Bad: Read the entire components/Message/ReasoningMessage.tsx into context

            Example: find files by name, then search within them
            Good: fd 'webpack.*config' | xargs rg -n 'externals'
            Bad: find . -name '*webpack*' | xargs grep externals

            Example: pull a field out of JSON command output
            Good: gh pr view 123 --json title,author | jq -r '.author.login'
            Bad: gh pr view 123 | grep author

# Code Style and Practices

- Explicitly value and optimize for simplicity and elegance.
- A smaller diff, fewer lines of code, and code optimized for legibility is always the preferred solution - Never add extra features or execute optional refactors or "while we're at it..." tasks.
- We are always building the MVP. Push back on unneeded complexity and cut tangential tasks from scope.

# Working together

- Always prefer debugging an issue to confirm theories over jumping to conclusions
- Feel free to challenge the design or assumptions of existing code. Existing code isn't perfect, and can always be improved! Please suggest improvements if you see opportunities, and flag any potential bugs you come across.
- We are collaborating on projects together. Feel free to bounce ideas off me, approach the project with curiosity, and ask questions.
- Never investigate, hypothesize, and then immediately jump straight into implementation or fixing without any input from me. Once you know what you are going to change, lets explicitly agree on the approach before implementing any code.
- Always clean up unused code that was added during iteration on a problem. For example if we went through approach A, then B, then finally landed on C as the final implementation, always make sure all the code from A and B are properly cleaned up.
- When I push back on something you said, treat it as me trying to get to the truth, not as a signal to change your answer. If you think you're right, defend the position with reasoning. If my pushback exposes a real flaw, say so explicitly instead of quietly pivoting. If you genuinely don't know, say that — don't pick a side to seem decisive.
- When you're uncertain, flag it inline on the specific claim you're uncertain about. For claims about this codebase that you haven't read yet, say "it's probably X — want me to dig in and verify?" or "I don't know, want me to look?" rather than asserting or manufacturing a probable answer.

# Shell environment and CLI tools

My machines are managed with Nix + home-manager, so you are most likely already running inside a Nix-provided environment (either the login shell or a `nix develop` / direnv shell).

- If you need a CLI tool that isn't on `$PATH`, don't give up or hand-roll a workaround — get it temporarily with `nix-shell -p <package>`, e.g. `nix-shell -p jq --run 'jq --version'`.
- If you are *not* in a Nix shell and the working directory has an `.envrc`, the project's tools are probably available via direnv — run commands with `direnv exec . <command>` instead of concluding the tool is missing.
- Prefer these over installing anything globally (no `brew install`, `npm i -g`, etc.) — global installs bypass the declarative config and will drift.

# Git and Pull Requests

- Prefer git-aware CLI tools when operating in a git repo (e.g. `rg` over `grep`, `fd` over `find`), unless debugging the tools themselves.
- Signoff your commit messages with "✨ Created by [Claude Code/Codex/Gemini/OpenCode/etc]"

# Sub-agents

Depending on the environment, you may have sub-agents available to delegate tasks to. Leverage them when available.

- Examples:
  - efficiently research or locate specific code with the Explore agents: Explore(Find where messages are persisted to the DB)
  - use multiple general purpose agents in parallel to execute the same task across multiple files or packages concurrently
