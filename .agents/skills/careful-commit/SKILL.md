---
name: careful-commit
description: Creates a commit on a github repository that may contain secrets or sensitive values. Use when operating on any public repo, especially when changing files that may leak machine details, prioprietary information, or secrets.
---

After staging changes but before commit:

1. **Scan for secrets**: Ensure staged changes contain no API keys, any unique
   identifiers, shell history, etc.
2. **No machine info**: Ensure changes have no references to file paths with a
   user, repository names, etc.
3. **No user info**: Ensure changes have no references to any user's real name, email, account names, etc.

Some exceptions apply to the above. If ANY of the above checks flag any
possibly sensitive value, STOP. Do NOT commit. Flag the changes to the user and
as for clarification. Do NOT make any assumptions about what is an acceptable
exception to the above rules, always proceed based only on the users'
instructions.
