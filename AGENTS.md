# nixie

Cross-platform dotfiles and system configuration managed with Nix flakes and home-manager. Supports macOS (aarch64-darwin) and Linux (x86_64-linux / NixOS).

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
  .antigenrc           # Zsh plugin manager config
  .fzf.zsh             # FZF config
  .p10k.zsh            # Powerlevel10k prompt theme
  .claude/             # Claude Code settings
  bin/                 # User scripts on $PATH
  .config/
    nvim/              # Standalone neovim config (legacy)
    nvim-lazyvim/      # LazyVim-based neovim config (active)
      lua/config/      # Neovim options, keymaps, autocmds
      lua/plugins/     # Plugin specs (LSP, copilot, smart-splits, glance, etc.)
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

- **`flake.nix`** defines two home-manager configurations: `<user>@darwin` and `<user>@linux`. Both use `home.nix` with an `isDarwin` flag for platform-specific behavior.
- **`home.nix`** is the main config: installs packages, symlinks dotfiles, sets env vars, and runs activation scripts (e.g. TPM install, wezterm CLI symlink on macOS).
- **`machines/*.nix`** contain per-machine values (username, git email, timezone). To switch machines, update the import in `flake.nix`.
- **Dotfiles** are stored in `dotfiles/` and symlinked to `$HOME` by home-manager. Edit them in-place; changes take effect after `home-manager switch`.
- **Neovim** uses LazyVim (`dotfiles/.config/nvim-lazyvim/`). Plugin specs are in `lua/plugins/`, keymaps in `lua/config/keymaps.lua`.

## Applying changes

```sh
# macOS
home-manager switch --flake .#<user>@darwin

# Linux
home-manager switch --flake .#<user>@linux

# NixOS (full system rebuild)
sudo nixos-rebuild switch --flake .
```
