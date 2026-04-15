# .zshenv — sourced by ALL zsh invocations (login, interactive, scripts, non-interactive).
# This is the only zsh config file that runs when GUI apps (e.g. Claude Desktop) spawn
# a non-interactive shell like `zsh -c "command"`.
#
# Keep this file lightweight — no heavy evals, no interactive-only setup.

# Source the Nix daemon environment (adds nix bins to PATH, sets NIX_* vars).
# This is normally sourced by /etc/zshrc, but that only runs for interactive shells.
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# Source home-manager session variables (sets HM-managed env vars).
if [[ "$OSTYPE" == "darwin"* ]]; then
  if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
  fi
else
  if [ -e "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh" ]; then
    . "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
  fi
fi

# Essential PATH additions — ensures GUI-spawned shells can find user tools.
# Duplicates are fine here; typeset -gU dedupes.
typeset -gU path
path=(
  $HOME/bin
  $HOME/.bun/bin
  $HOME/.local/share/npm/bin
  $HOME/go/bin
  $HOME/.nix-profile/bin
  /nix/var/nix/profiles/default/bin
  /usr/local/{bin,sbin}
  $path
)
