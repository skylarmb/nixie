# nixie

Cross-platform dotfiles and system configuration managed with Nix flakes and home-manager. Supports macOS (aarch64-darwin) and Linux (x86_64-linux / NixOS).

## Two sets of agent instructions — don't mix them up

This repo has **two separate CLAUDE.md/AGENTS.md files** with different scopes:

- **This file** (`AGENTS.md` at repo root, symlinked from `CLAUDE.md`) — project-specific instructions for working on *this* nixie repo itself.
- `dotfiles/.claude/CLAUDE.md` — the user's **global** agent instructions, symlinked to `~/.claude/CLAUDE.md` by home-manager. It applies to *every* project the user works on, not just this one.

If asked to update "CLAUDE.md" or "AGENTS.md" without qualification, check which one is actually meant — global preferences/workflow rules belong in `dotfiles/.claude/CLAUDE.md`, while nixie-repo-specific conventions belong here.

## Repo structure

```
flake.nix              # Nix flake entrypoint: defines inputs (nixpkgs, home-manager, tpm, stylix) and outputs
flake.lock             # Pinned flake dependency versions
home.nix               # Home-manager config: packages, dotfile symlinks, env vars, activation scripts
configuration.nix      # NixOS system configuration (Linux only)
hardware-configuration.nix  # NixOS hardware config (Linux only)
boot.nix               # NixOS boot config (Linux only)

machines/              # Machine-specific configs (username, email, timezone)
  hh.nix               # macOS machine config
  rog.nix              # Linux machine config

dotfiles/              # User dotfiles, symlinked into $HOME by home-manager
  .wezterm.lua         # WezTerm terminal config (leader key, splits, smart-splits integration)
  .zshrc               # Zsh config
  .zprofile            # Zsh profile
  .fzf.zsh             # FZF config
  .p10k.zsh            # Powerlevel10k prompt theme
  .claude/             # Claude Code settings
  bin/                 # User scripts on $PATH
  .config/
    nvim/              # LazyVim-based neovim config (active)
      lua/config/      # Neovim options, keymaps, autocmds
      lua/plugins/     # Plugin specs (LSP, copilot, smart-splits, glance, etc.)
    nvim-old/          # Legacy neovim config (not in use)
    tmux/              # Tmux config
    git/               # Git config and global ignore
    cargo/             # Rust/Cargo config
    kitty/             # Kitty terminal config
    hypr/              # Hyprland WM config (Linux)
    waybar/            # Waybar config (Linux)
    gh/                # GitHub CLI config
    direnv/            # direnv config

wallpapers/            # Desktop wallpapers
install.sh             # Bootstrap script for first-time setup
trim-generations.sh    # Nix garbage collection helper
```

## Key concepts

- **`flake.nix`** defines one home-manager configuration per machine, keyed `<user>@<machine>` (e.g. `skylar@workstation`, `skylar@rog`, `skylar@hh`). New machines are added by creating `machines/<name>.nix` and adding an entry to the `machines` attrset in `flake.nix`. Two flags drive platform-specific behavior: `isDarwin` (passed from the flake based on the machine spec) and `userConfig.isNixOS` (set in the machine config; controls whether home-manager is system-level on NixOS or standalone).
- **`home.nix`** is the main config: installs packages, symlinks dotfiles, sets env vars, and runs activation scripts (e.g. TPM install, wezterm CLI symlink on macOS).
- **`machines/*.nix`** contain per-machine values (username, git email, timezone, `isNixOS`). The `hs` shell function picks the right config via `$NIX_MACHINE_NAME` (set in `~/.private/.zshrc`).
- **Dotfiles** are stored in `dotfiles/` and symlinked to `$HOME` by home-manager. The directory structure mirrors `$HOME` — e.g. `dotfiles/.config/ripgrep/config` → `~/.config/ripgrep/config`. Don't break this convention. Edit them in-place; changes take effect after `home-manager switch`.
- **Neovim** uses LazyVim (`dotfiles/.config/nvim/`). Plugin specs are in `lua/plugins/`, keymaps in `lua/config/keymaps.lua`. `dotfiles/.config/nvim-old/` is a legacy config, not in use.

## Working in this environment

Everything on this machine's `$PATH` comes from Nix/home-manager, so you're almost certainly already inside a Nix-provided environment. Don't assume a tool is unavailable just because your first invocation failed.

- **Need a tool that isn't installed?** Pull it in temporarily with `nix-shell -p <package>` (e.g. `nix-shell -p nixfmt --run 'nixfmt --check home.nix'`) rather than adding it to `home.nix` just to run it once. Only add packages to `home.nix` when the user actually wants them permanently installed.
- **Not in a Nix shell, but an `.envrc` exists in the working directory?** The tools are likely provided by direnv — run commands as `direnv exec . <command>` instead of treating them as missing.
- Never install tools globally (`brew install`, `npm i -g`, …) — this repo is the declarative source of truth for installed software.

## Applying changes

```sh
# Standalone home-manager (Darwin or non-NixOS Linux): selector is per-machine.
# The `hs` shell alias wraps this and reads $NIX_MACHINE_NAME from ~/.private/.zshrc.
home-manager switch --flake .#<user>@<machine>   # e.g. skylar@workstation, skylar@hh

# NixOS (full system rebuild) — uses machines/rog.nix
sudo nixos-rebuild switch --flake .
```
