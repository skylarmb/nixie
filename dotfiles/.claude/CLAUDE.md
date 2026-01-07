# General
- When summarizing work you have performed, keep the summary brief and high level. 1-3 sentences or bullet points at most!
- Always comment your code.
- Use git-aware tools when operating within a git repo, e.g. `rg` instead of `grep`, `eza -l --git` instead of `ls -l`, unless otherwise needed for debugging.
- Run project build / lint commands to check your changes before considering a task to be finished.
- Always use efficient methods of exploring the codebase, reading file contents, and parsing command output.
    - Always prefer reading only the information you need, such as filtered output or just the relevant portion of the file.
    - In addition to normal shell commands, you may have access to semantic tools like `jq`, `yq`, `serena` MCP semantic retrieval and editing tools.

            Example Scenario: find if there are instances of a lint violation
            Good: npm run lint 2&>1 | rg @typescript-eslint/no-unused-vars | wc -l
            Bad: npm run lint

            Example scenario: Check if Foo is imported in a file
            Good: cat components/Message/ReasoningMessage.tsx | head -50 | rg 'import.*Foo'
            Bad: Read(components/Message/ReasoningMessage.tsx)


# TypeScript
- Never use `as any` or `foo: any` types! always create or use strong types
- Use `console.debug` instead of `console.log` for debug logging in order to separate debug logs from other console noise.

# Working together
- Always prefer debugging an issue to confirm theories over jumping to conclusions
- Feel free to challenge the design or assumptions of existing code. Existing code isn't perfect, and can always be improved! Please suggest improvements if you see opportunities, and flag any potential bugs you come across.
- We are collaborating on this project together! Feel free to bounce ideas off me, approach the project with curiosity, and ask questions.
- Never investigate, hypothesize, and then immediately jump straight into implementation or fixing without any input from me. Once you know what you are going to change, lets explicitly agree on the approach before implementing any code.
- Always clean up unused code that was added during iteration on a problem. For example if we went through approach A, then B, then finally landed on C as the final implementation, always make sure all the code from A and B are properly cleaned up.
- Signoff your commit messages with "✨ Created with [Claude Code/Gemini/OpenCode/etc]"

# Sub-agents
Depending on the environment, you may have sub-agents available to delegate tasks to. Leverage them when available.
- E.g. efficiently research or locate specific code with the Explore agent: Explore(Find where messages are persisted to the DB)
