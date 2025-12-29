# nixie

My personal dotfiles and system configuration managed with Nix and home-manager.

## Features

- **Declarative configuration** using Nix flakes
- **Cross-platform support** for macOS (Darwin) and Linux
- **Parameterized setup** - easily customize for different machines
- **Automated bootstrap** - one-command setup for new machines
- **Nix-managed dependencies** - no manual git submodule initialization
- **Private configuration** - keep sensitive data out of version control

## Quick Start

### New Machine Setup

1. **Install Nix** (if not already installed):
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. **Clone this repository**:
   ```bash
   git clone https://github.com/skylarmb/nixie.git ~/.config/nixie
   cd ~/.config/nixie
   ```

3. **Run the bootstrap script**:
   ```bash
   ./install.sh
   ```

4. **Customize your private configuration**:
   - Edit `~/.private/.zshrc` - set WORKSPACE, GITHUB_TOKEN, etc.
   - Edit `~/.private/.gitconfig` - set your git user info

5. **Reload your shell**:
   ```bash
   exec zsh
   ```

That's it! Your development environment is ready.

## What's Included

### Home Manager Configuration
- **Shell**: zsh with oh-my-zsh, antigen, fzf integration
- **Editor**: Neovim with Lazy.nvim plugin manager, LSP, Copilot
- **Terminal**: tmux with TPM (auto-installed), wezterm
- **Git**: Delta diff viewer, extensive aliases, GPG signing support
- **CLI Tools**: ripgrep, bat, eza, fd, gh (GitHub CLI), tig
- **Development**: direnv with nix-direnv, Node.js 22, linters/formatters

### NixOS Configuration
NixOS system configuration for bare-metal Apple Silicon (Asahi kernel):
- GNOME desktop environment
- Nvidia GPU support (open-source drivers)
- Mullvad VPN integration
- LVM/LUKS encryption support

## Configuration Structure

```
nixie/
├── flake.nix                    # Main flake configuration with inputs
├── home.nix                     # Home-manager configuration
├── configuration.nix            # NixOS system config
├── boot.nix                     # Boot settings
├── hardware-configuration.nix   # Auto-generated hardware config
├── install.sh                   # Bootstrap script
├── .private.template/           # Templates for private config
│   ├── .zshrc                  # Environment variables template
│   └── .gitconfig              # Git user config template
└── dotfiles/                    # All dotfiles (auto-linked by home-manager)
    ├── .config/
    │   ├── nvim/               # Neovim configuration
    │   ├── tmux/               # Tmux configuration
    │   ├── git/                # Git configuration
    │   └── ...
    ├── .zshrc                  # Main zsh config
    └── bin/                    # Custom scripts
```

## Customization

### Changing User Information

Edit `flake.nix` and update the `userConfig` section:

```nix
userConfig = {
  username = "your-username";
  email = "your-email@example.com";
  fullName = "Your Name";
  gpgKey = "YOUR_GPG_KEY";  # or null
  timezone = "America/Los_Angeles";
};
```

### Adding Packages

Edit `home.nix` and add packages to `home.packages`:

```nix
home.packages = [
  pkgs.your-package-here
  # ...
];
```

### Platform-Specific Configuration

The flake automatically detects your platform and applies the appropriate configuration:
- **macOS**: Uses `username@darwin` configuration
- **Linux**: Uses `username@linux` configuration

## Updating

### Update Dependencies
```bash
nix flake update
```

### Apply Configuration Changes
```bash
home-manager switch --flake '.#your-username@darwin'
# or for Linux:
home-manager switch --flake '.#your-username@linux'
```

### Rebuild NixOS System
```bash
sudo nixos-rebuild switch --flake '.#nixos'
```

## Private Configuration

Private configuration is stored in `~/.private/` and is NOT tracked in git. This directory contains:

- `~/.private/.zshrc` - Environment variables (WORKSPACE, GITHUB_TOKEN, etc.)
- `~/.private/.gitconfig` - Git user configuration

Templates are provided in `.private.template/` for easy setup on new machines.

## Manual Steps (Minimized!)

The bootstrap script handles most setup automatically. The only manual steps are:

1. **Edit private config files** in `~/.private/` with your personal information
2. **(Optional) Customize** `flake.nix` if you want to change default settings

Everything else (Nix installation, submodules, TPM plugins, etc.) is automated!

## What Was Automated

Previously manual steps that are now automated:
- ✅ Git submodule initialization (TPM managed by Nix)
- ✅ TPM plugin installation (runs on home-manager activation)
- ✅ Private config template setup
- ✅ Platform detection (macOS vs Linux)
- ✅ Home-manager installation and configuration

## Platform Support

- **macOS** (Apple Silicon & Intel)
- **NixOS** (with Asahi kernel for Apple Silicon)
- **Linux** (other distributions with Nix/home-manager)

## License

MIT License - see LICENSE file for details
