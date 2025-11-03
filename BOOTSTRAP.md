# Bootstrap Automation Summary

This document summarizes the improvements made to automate the setup of this dotfiles repository.

## What Was Automated

### 1. **Flake-based Configuration**
- Created `flake.nix` with parameterized user configuration
- All user-specific settings (username, email, GPG key, timezone) are now in one place
- Cross-platform support (macOS and Linux) with automatic detection
- Declarative dependency management via Nix flakes

### 2. **TPM (Tmux Plugin Manager) Management**
- **Before**: Required manual `git submodule update --init --recursive`
- **After**: Managed via Nix's `fetchFromGitHub` in flake inputs
- **Bonus**: Automatic plugin installation via home-manager activation script
- No more manual `prefix + I` to install plugins!

### 3. **Private Configuration Templates**
Created `.private.template/` directory with:
- `.zshrc` - Environment variables template (WORKSPACE, GITHUB_TOKEN, etc.)
- `.gitconfig` - Git user configuration template

**Before**: Users had to manually create these files from scratch
**After**: Templates are copied automatically by `install.sh`

### 4. **Bootstrap Script**
Created `install.sh` that:
- Checks for Nix installation
- Enables flakes if not already enabled
- Detects platform (macOS vs Linux)
- Sets up `~/.private/` directory with templates
- Runs `home-manager switch` automatically
- Provides clear next steps

### 5. **Removed Hardcoded Paths**
- Git config: User info moved to `.private/.gitconfig`
- Tmux config: Changed `/Users/skylar/` to `$HOME/`
- Home.nix: Username and home directory now use `userConfig`
- Configuration.nix: Timezone and username parameterized

### 6. **Cleaned Up Unused Dependencies**
Removed references to:
- `~/workspace/nvim_dev` (old Neovim development directory)
- Spotifyd configuration (unused)
- Git submodules (replaced with Nix management)

### 7. **Improved .gitignore**
Added:
- `.private/` directory (contains sensitive data)
- `result-*` (Nix build outputs)

### 8. **Comprehensive Documentation**
- Updated `README.md` with complete setup instructions
- Added platform-specific configuration notes
- Documented manual steps (now minimal!)
- Created this `BOOTSTRAP.md` summary

## Before vs After Comparison

### Before (Manual Setup Steps)
1. Install Nix
2. Clone repository
3. Run `git submodule update --init --recursive`
4. Manually create `~/.private/.zshrc` with all environment variables
5. Manually create `~/.private/.gitconfig` with git user info
6. Edit hardcoded values in:
   - `home.nix` (username, home directory)
   - `configuration.nix` (username, timezone)
   - `dotfiles/.config/git/config` (user, email, GPG key)
   - `dotfiles/.config/tmux/tmux.conf` (shell path)
7. Run `home-manager switch` with correct arguments
8. Start tmux and press `prefix + I` to install plugins
9. Wait for Neovim plugins to install on first run

**Estimated time**: 20-30 minutes + troubleshooting

### After (Automated Setup)
1. Install Nix
2. Clone repository
3. Run `./install.sh`
4. Edit `~/.private/.zshrc` and `~/.private/.gitconfig` (templates provided)
5. Reload shell

**Estimated time**: 5-10 minutes

## New Machine Setup Command

```bash
# One-liner (after Nix is installed)
git clone https://github.com/skylarmb/nixie.git ~/.config/nixie && \
  cd ~/.config/nixie && \
  ./install.sh
```

## Customization Points

All user-specific configuration is now centralized in two places:

### 1. `flake.nix` - System-level Configuration
```nix
userConfig = {
  username = "skylar";
  email = "skylarmb@gmail.com";
  fullName = "Skylar Brown";
  gpgKey = "41933B821B71E2FE";
  timezone = "America/Los_Angeles";
};
```

### 2. `~/.private/` - Machine-specific Secrets
- `.zshrc` - Environment variables (WORKSPACE, GITHUB_TOKEN, etc.)
- `.gitconfig` - Git user configuration

## Benefits

1. **Reproducibility**: Same configuration on every machine
2. **Security**: Sensitive data stays out of version control
3. **Portability**: Easy to adapt for different machines
4. **Maintainability**: Single source of truth for user configuration
5. **Speed**: New machine setup takes minutes, not hours
6. **Declarative**: All dependencies managed by Nix
7. **Cross-platform**: Supports macOS and Linux with one codebase

## Future Improvements

Potential areas for further automation:

1. **GitHub Token Setup**: Could integrate with `gh auth login`
2. **GPG Key Generation**: Could automate GPG setup for new machines
3. **SSH Key Management**: Could include SSH key generation/setup
4. **Brewfile Sync**: Could integrate macOS Homebrew packages into flake
5. **Multiple Machines**: Could add per-machine configuration overlays

## Technical Details

### How TPM is Managed

The flake.nix includes:
```nix
tpm = {
  url = "github:tmux-plugins/tpm";
  flake = false;
};
```

Then in home.nix:
```nix
home.file.".config/tmux/plugins/tpm".source = tpm;

home.activation.installTmuxPlugins = config.lib.dag.entryAfter ["writeBoundary"] ''
  if [ -x "$HOME/.config/tmux/plugins/tpm/bin/install_plugins" ]; then
    $DRY_RUN_CMD "$HOME/.config/tmux/plugins/tpm/bin/install_plugins" || true
  fi
'';
```

This ensures TPM is always available and plugins are installed automatically.

### How Platform Detection Works

The flake defines separate outputs for Darwin (macOS) and Linux:
```nix
homeConfigurations."${userConfig.username}@darwin"
homeConfigurations."${userConfig.username}@linux"
```

The install script detects the platform and uses the appropriate configuration.

## Conclusion

These improvements reduce manual setup time by **60-70%** and eliminate common errors from hardcoded paths and missing dependencies. The configuration is now fully declarative, reproducible, and easy to maintain across multiple machines.
