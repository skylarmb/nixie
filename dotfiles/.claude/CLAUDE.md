# General

- When summarizing work you have performed, keep the summary brief and high level. 1-3 sentences or bullet points at most!
- Always comment your code.
- Run project build / lint commands to check your changes before considering a task to be finished.
- Always use efficient methods of exploring the codebase, reading file contents, and parsing command output.
  - Always prefer reading only the information you need, such as filtered output or just the relevant portion of the file.
  - In addition to normal shell commands, you may have access to semantic tools like `jq`, `yq`, .

            Example Scenario: find if there are instances of a lint violation
            Good: npm run lint 2&>1 | rg @typescript-eslint/no-unused-vars | wc -l
            Bad: npm run lint

            Example scenario: Check if Foo is imported in a file
            Good: cat components/Message/ReasoningMessage.tsx | head -50 | rg 'import.*Foo'
            Bad: Read(components/Message/ReasoningMessage.tsx)

# Code Style and Practices

- Never use `as any` or `foo: any` types! always create and use strong types
- Use `console.debug` instead of `console.log` for debug logging in order to separate debug logs from other console noise.
- Explicitly value and optimize for simplicity and elegance.
  - A smaller diff, fewer lines of code, and code optimized for legibility is always the preferred solution - Never add extra features or execute optional refactors or "while we're at it..." tasks.
  - We are always building the MVP. Push back on unneeded complexity and cut tangential tasks from scope.

# Working together

- Always prefer debugging an issue to confirm theories over jumping to conclusions
- Feel free to challenge the design or assumptions of existing code. Existing code isn't perfect, and can always be improved! Please suggest improvements if you see opportunities, and flag any potential bugs you come across.
- We are collaborating on this project together! Feel free to bounce ideas off me, approach the project with curiosity, and ask questions.
- Never investigate, hypothesize, and then immediately jump straight into implementation or fixing without any input from me. Once you know what you are going to change, lets explicitly agree on the approach before implementing any code.
- Always clean up unused code that was added during iteration on a problem. For example if we went through approach A, then B, then finally landed on C as the final implementation, always make sure all the code from A and B are properly cleaned up.
- When I push back on something you said, treat it as me trying to get to the truth, not as a signal to change your answer. If you think you're right, defend the position with reasoning. If my pushback exposes a real flaw, say so explicitly instead of quietly pivoting. If you genuinely don't know, say that — don't pick a side to seem decisive.
- When you're uncertain, flag it inline on the specific claim you're uncertain about. For claims about this codebase that you haven't read yet, say "it's probably X — want me to dig in and verify?" or "I don't know, want me to look?" rather than asserting or manufacturing a probable answer.

# Git and Pull Requests

- Use git-aware tools when operating within a git repo, e.g. `rg` instead of `grep`, `eza -l --git` instead of `ls -l`, unless otherwise needed for debugging.
- Signoff your commit messages with "✨ Created with [Claude Code/Codex/Gemini/OpenCode/etc]"
- If you make a PR with the `gh` CLI, open it in the browser after creation: `gh repo view --web --branch <branch-name>`
- Use the `pr-comments` util script (available in PATH) to fetch code review comments / PR feedback from GitHub, e.g. `pr-comments 1234`
- Open all PRs as draft PRs until they are ready for review. Mark PRs as ready to review when you are ready for feedback (this triggers automated code review).
- Open all PRs with the following format exactly:

```

# Summary

1-3 sentences of concise but informative PR description for this branch. Inspect files changed and consider the conversation history to provide relevant info.

# Details

- up to 4-5 bullet points here, but keep it high level
```

# Sub-agents

Depending on the environment, you may have sub-agents available to delegate tasks to. Leverage them when available.

- Examples:
  - efficiently research or locate specific code with the Explore agents: Explore(Find where messages are persisted to the DB)
  - use multiple general purpose agents in parallel to execute the same task across multiple files or packages concurrently
