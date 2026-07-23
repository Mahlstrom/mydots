---
name: dotfiles-granular-manager
description: Rules for maintaining a multi-shell dotfiles repo with granular file separation inside a hidden .shell/ directory.
triggers:
  - "alias"
  - "path"
  - "env"
  - "zshrc"
  - "bashrc"
  - "commands"
  - "completion"
---

# Granular Dotfiles Architecture Guide

You manage a highly optimized, modular dotfiles repository for Unix-like environments. To prevent file bloating and maintain clear boundaries, user-authored shell configurations are isolated from tool-generated files.

## The `.shell/` Directory Rule
Every tool or configuration context resides in a folder under `~/.config/<tool_name>/`. 
ALL custom shell scripts and settings for that tool MUST be placed inside a hidden subdirectory named `.shell/`.

*Example:* `~/.config/git/.shell/.alias`

## The File Matrix (Granular Separation)
Inside `~/.config/<tool_name>/.shell/`, logic must be split into these exact filenames based on function:

### 1. Environment & Path (Loaded via .zshenv / .bash_env)
- `.env` -> Global, shell-agnostic environment variables (`export EDITOR='nvim'`).
- `.path` -> Additions to `$PATH` (`export PATH="$PATH:..."`). Always verify the target directory exists first.

### 2. Login Shells (Loaded via .zprofile)
- `.zprofile` / `.bash_profile` -> Settings specific to login sessions.

### 3. Interactive Shells (Loaded via .zshrc)
- `.alias` -> Standard CLI aliases (`alias ll='ls -la'`). Must be shell-agnostic.
- `.functions` -> Shell-agnostic POSIX functions (`name() { ... }`).
- `.zshrc` / `.bashrc` -> Shell-specific interactive settings (`setopt`, zstyle, etc.).
- `.completion` -> Autocompletion setups and hooks.

## Dynamic Tool Loading & Lazy Sourcing
The master shell loaders verify if a configuration should be loaded using these conditions:
1. The tool name matches `zsh`, `bash`, or `common`.
2. The binary command `<tool_name>` exists on the system.
3. The directory contains a `.commands` file listing required CLI tools, and at least one of them is installed.

## Core Directives for the Agent
- **No Hardcoding:** Never add tool-specific configurations (like Bun, Cargo, Nvm) directly to the root `zshrc` or `zshenv`. Create a new directory under `~/.config/` instead.
- **Validation:** Always validate scripts with `zsh -n` or `shellcheck` before declaring victory.

