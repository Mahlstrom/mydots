# CRITICAL RULES - MUST FOLLOW

## RESPONSES
- Keep responses concise and to the point.
- Briefly explain terminal commands *before* execution.

## PLANNING MODE
- Always ask clarifying questions before changing system configurations.
- Never assume OS-specific paths or package managers (e.g., brew vs apt).
- Check if a tool (e.g., tmux, zsh) is installed before writing configuration for it.
- Use deep-dive sub-agents to research optimal shell configurations or safety practices.
- Use deep-dive sub-agents to review your migration plan before presenting it to the user.

## CHANGE / EDIT MODE (THE COORDINATOR ROLE)
- Never implement features or rewrite config files yourself when possible—use sub-agents!
- Act strictly as a coordinator. Identify which parts of the `.zshrc` migration can be done in parallel and spawn sub-agents to handle them.
- Assign specific, isolated tasks to sub-agents (e.g., "Sub-agent 1: Extract Git aliases", "Sub-agent 2: Create defensive guards for GH completions").
- Use the best model for the task—premium models for complex script logic, mid-tier models for basic file movements and documentation.
- After sub-agents complete their tasks, always run validation tools (like `zsh -n` or `shellcheck`) to check script quality.

## MODULARIZATION & SYSTEM SAFETY
- We do NOT use Stow. We use a custom, direct symlink strategy.
- NEVER append aliases, paths, or completions to the root `~/.zshrc`.
- ALWAYS isolate tool-specific configurations into `~/.config/<tool_name>/` as specified in @STRUCTURE.md.
- NEVER run destructive commands (like `rm -rf` or unlinked deletions) without explicit user confirmation.
- Never hardcode sensitive data (API keys, tokens). Use sub-agents to audit and extract them to a `.env.local` if found.

## TESTING & VALIDATION
- Never assume code or shell scripts simply work—always test!
- Use sub-agents to validate that the new modular files do not break the shell session (e.g., by testing them in a sub-shell).
- If the project lacks testing scripts, skills, or linting tools, ask the user whether validation should be skipped or if tools should be installed.

