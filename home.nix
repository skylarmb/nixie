{
  config,
  pkgs,
  lib,
  userConfig,
  tpm,
  isDarwin ? true,
  ...
}:

{
  home.username = userConfig.username;
  home.homeDirectory =
    if isDarwin then "/Users/${userConfig.username}" else "/home/${userConfig.username}";
  home.stateVersion = "25.05"; # Please read the comment before changing.
  home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";
  home.packages = [
    # dependencies
    # pkgs.gccgo
    # pkgs.gnumake
    pkgs.nodejs_22
    (pkgs.python313.withPackages (ps: [ ps.libtmux ]))
    pkgs.python313Packages.libtmux
    pkgs.uv # provides `uv` and `uvx`
    # programs
    pkgs.tmux
    # pkgs.herdr # installed via official channel as nix package is out of date
    pkgs.helix
    pkgs.neovim
    pkgs.emacs # for trying out Doom Emacs
    pkgs.expect
    pkgs.glow # terminal markdown viewer
    pkgs.act
    pkgs.devcontainer
    pkgs.htop
    pkgs.hgrep
    pkgs.wget
    # pkgs.codex
    # pkgs.orca-slicer

    # LSP / languages
    pkgs.stylua
    pkgs.prettierd
    pkgs.eslint_d
    pkgs.nil
    pkgs.nixfmt-rfc-style # nix formatter (official RFC 166 style)
    # pkgs.statix # nix linter (used by nvim-lint via LazyVim's lang.nix extra)
    pkgs.typescript-language-server
    pkgs.gopls
    pkgs.unison-ucm
    pkgs.rust-analyzer

    # shell
    pkgs.zsh
    pkgs.ripgrep
    pkgs.spr # stacked pull requests
    pkgs.actionlint
    pkgs.shellcheck

    # pkgs.direnv
    pkgs.oh-my-zsh
    pkgs.fzf
    pkgs.bat
    pkgs.eza
    pkgs.fd
    pkgs.git
    pkgs.unzip
    pkgs.gh
    pkgs.delta
    pkgs.tig
    pkgs.tree
    pkgs.sd
    pkgs.htmlq
    pkgs.awscli2
    pkgs.kubectl
    pkgs.gemini-cli
    pkgs.tree-sitter

    pkgs.cargo
    pkgs.portaudio

    # containers
    # pkgs.podman
    # pkgs.virtiofsd
    # pkgs.docker
    # pkgs.docker-buildx
    # pkgs.docker-compose
    # pkgs.nvidia-container-toolkit
  ]
  ++ lib.optionals (!isDarwin) [
    # linux only packages
    pkgs.calibre
    pkgs.calibre-web
    pkgs.orca-slicer
    # pkgs.plasticity
    # pkgs.wezterm
    pkgs.wl-clipboard
    pkgs.vanilla-dmz
    pkgs.libgcc
    pkgs.deluge
    pkgs.vscode
  ];

  home.file = {
    # shell stuff
    ".zshenv".source = dotfiles/.zshenv;
    ".zprofile".source = dotfiles/.zprofile;
    ".zshrc".source = dotfiles/.zshrc;
    ".wezterm.lua".source = dotfiles/.wezterm.lua;
    ".oh-my-zsh/custom/themes/af-magic-ansi.zsh-theme".source =
      dotfiles/.oh-my-zsh/custom/themes/af-magic-ansi.zsh-theme;

    # applications
    ".config/git".source = dotfiles/.config/git;
    ".cargo/config.toml".source = dotfiles/.config/cargo/config.toml;
    # nvim config (LazyVim)
    ".config/nvim/lua".source = dotfiles/.config/nvim/lua;
    ".config/nvim/init.lua".source = dotfiles/.config/nvim/init.lua;
    ".config/nvim/.neoconf.json".source = dotfiles/.config/nvim/.neoconf.json;

    # Tmux - symlink config files individually to allow TPM management
    ".config/tmux/tmux.conf".source = dotfiles/.config/tmux/tmux.conf;
    ".config/tmux/colorscheme.conf".source = dotfiles/.config/tmux/colorscheme.conf;

    # Linux: export Nix profile path vars into the systemd user environment so
    # GUI-launched apps (tmux, wezterm, etc.) inherit them. home.sessionVariables
    # only loads via shell init, which doesn't reach apps started outside a shell.
    ".config/environment.d/nix-profile.conf" = lib.mkIf (!isDarwin) {
      text = ''
        NIX_PROFILE_BIN=${
          if userConfig.isNixOS then
            "/etc/profiles/per-user/${userConfig.username}/bin"
          else
            "/home/${userConfig.username}/.nix-profile/bin"
        }
        NIX_PROFILE_ETC=${
          if userConfig.isNixOS then
            "/etc/profiles/per-user/${userConfig.username}/etc"
          else
            "/home/${userConfig.username}/.nix-profile/etc"
        }
        NIX_PROFILE_SHARE=${
          if userConfig.isNixOS then
            "/etc/profiles/per-user/${userConfig.username}/share"
          else
            "/home/${userConfig.username}/.nix-profile/share"
        }
      '';
    };

    # Linux: pre-create $XDG_RUNTIME_DIR/wezterm at session start so wezterm's
    # SSH_AUTH_SOCK symlink doesn't race the dir creation on launch.
    ".config/user-tmpfiles.d/wezterm.conf" = lib.mkIf (!isDarwin) {
      text = "d %t/wezterm 0700 - - -\n";
    };

    # Herdr terminal - symlink config files individually since herdr manages
    # its own plugin installs and state (session.json, logs, sockets) in the
    # same directory.
    ".config/herdr/config.toml".source = dotfiles/.config/herdr/config.toml;

    ".config/ripgrep/config".source = dotfiles/.config/ripgrep/config;
    ".config/containers/registries.conf".source = dotfiles/.config/containers/registries.conf;
    ".config/containers/policy.json".source = dotfiles/.config/containers/policy.json;

    # TPM - Tmux Plugin Manager (managed by Nix)
    ".config/tmux/plugins/tpm".source = tpm;

    # Nix config
    ".config/nix/nix.conf".source = dotfiles/.config/nix/nix.conf;

    ".config/nixpkgs/config.nix".text = ''
      { allowUnfree = true; }
    '';

    ".config/npm/npmrc".text = ''
      cache=~/.cache/npm
      prefix=~/.local/share/npm
    '';

    "bin".source = dotfiles/bin;

    # Claude Code configuration - synced across machines
    ".claude/CLAUDE.md".source = dotfiles/.claude/CLAUDE.md;
    # ".claude/settings.json".source = dotfiles/.claude/settings.json;
    ".claude/explore.md".source = dotfiles/.claude/explore.md;

    ".claude/output-styles".source = dotfiles/.claude/output-styles;

    # Symlink skill files individually so the skills directory remains
    # writable (plugins install skills into ~/.claude/skills/ as well).
    ".claude/skills/create-pr/SKILL.md".source = dotfiles/.claude/skills/create-pr/SKILL.md;
    ".claude/skills/address-feedback/SKILL.md".source =
      dotfiles/.claude/skills/address-feedback/SKILL.md;
    ".claude/skills/monitor-pr/SKILL.md".source = dotfiles/.claude/skills/monitor-pr/SKILL.md;
    ".claude/skills/resolve-comments/SKILL.md".source =
      dotfiles/.claude/skills/resolve-comments/SKILL.md;
    ".claude/skills/ste-writing/SKILL.md".source = dotfiles/.claude/skills/ste-writing/SKILL.md;

    # Generic agent instructions
    ".config/AGENTS.md".source = dotfiles/.claude/CLAUDE.md;

    # Same skills under the tool-agnostic ~/.agents convention. Symlinked as a
    # whole directory (unlike ~/.claude/skills) because nothing installs skills
    # here — switch to per-file entries if a tool ever needs to write here.
    ".agents/skills".source = dotfiles/.claude/skills;

    # Gemini configuration - same as Claude.md
    ".gemini/GEMINI.md".source = dotfiles/.claude/CLAUDE.md;

    # OpenCode configuration - same as Claude.md
    ".config/opencode/AGENTS.md".source = dotfiles/.claude/CLAUDE.md;

    # Codex configurations - also same as Claude.md for now
    ".codex/AGENTS.md".source = dotfiles/.claude/CLAUDE.md;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    RIPGREP_CONFIG_PATH = "$HOME/.config/ripgrep/config";
    NPM_CONFIG_USERCONFIG = "$HOME/.config/npm/npmrc";
    SYSTEM_NODEJS = "${pkgs.nodejs_22}/bin/node";
    SYSTEM_PYTHON = "${pkgs.python3}/bin/python3";
    # NixOS installs home-manager at the system level, exposing the user profile
    # at /etc/profiles/per-user/<user>. Standalone home-manager (Darwin or
    # non-NixOS Linux) uses $HOME/.nix-profile instead.
    NIX_PROFILE_ETC =
      if userConfig.isNixOS then
        "/etc/profiles/per-user/${userConfig.username}/etc"
      else
        "$HOME/.nix-profile/etc";
    NIX_PROFILE_BIN =
      if userConfig.isNixOS then
        "/etc/profiles/per-user/${userConfig.username}/bin"
      else
        "$HOME/.nix-profile/bin";
    NIX_PROFILE_SHARE =
      if userConfig.isNixOS then
        "/etc/profiles/per-user/${userConfig.username}/share"
      else
        "$HOME/.nix-profile/share";
    # On Linux, write to both Wayland clipboards (CLIPBOARD + PRIMARY) so Ctrl+V
    # and middle-click see the same text (Mac-like single-clipboard UX).
    COPY_CMD = if isDarwin then "pbcopy" else "$HOME/bin/clip-copy";
    # DOCKER_HOST = "unix:///run/user/1000/podman/podman-machine-default-api.sock";
  };

  # Activation scripts
  home.activation = {
    # Install TPM plugins automatically
    installTmuxPlugins = config.lib.dag.entryAfter [ "installPackages" ] ''
      if [ -x "$HOME/.config/tmux/plugins/tpm/bin/install_plugins" ]; then
        export PATH="${pkgs.tmux}/bin:${pkgs.gawk}/bin:${pkgs.gnused}/bin:${pkgs.gnugrep}/bin:${pkgs.coreutils}/bin:${pkgs.git}/bin:$PATH"
        $DRY_RUN_CMD "$HOME/.config/tmux/plugins/tpm/bin/install_plugins" || true
      fi
    '';

    # Symlink WezTerm CLI into ~/.local/bin on macOS (installed as .app, not in PATH)
    symlinkWeztermCli = lib.mkIf isDarwin (
      config.lib.dag.entryAfter [ "installPackages" ] ''
        WEZTERM_BIN="/Applications/WezTerm.app/Contents/MacOS/wezterm"
        LINK_DIR="$HOME/.local/bin"
        if [ -x "$WEZTERM_BIN" ]; then
          mkdir -p "$LINK_DIR"
          ln -sf "$WEZTERM_BIN" "$LINK_DIR/wezterm"
        fi
      ''
    );

    # Alias Emacs.app into ~/Applications so Spotlight/Finder can find it.
    # nixpkgs' emacs ships a real .app bundle, but it lives on the Nix Store
    # volume, which is mounted `nobrowse` and excluded from Spotlight's index
    # entirely -- a plain symlink into it is invisible to Spotlight even after
    # mdimport. A real macOS alias file (what `mkalias` produces, same tool
    # nix-darwin uses for this) resolves through that boundary correctly.
    aliasEmacsApp = lib.mkIf isDarwin (
      config.lib.dag.entryAfter [ "installPackages" ] ''
        LINK_DIR="$HOME/Applications"
        if [ -d "${pkgs.emacs}/Applications/Emacs.app" ]; then
          mkdir -p "$LINK_DIR"
          rm -f "$LINK_DIR/Emacs.app"
          $DRY_RUN_CMD ${pkgs.mkalias}/bin/mkalias "${pkgs.emacs}/Applications/Emacs.app" "$LINK_DIR/Emacs.app"
        fi
      ''
    );

    # Patch tmux-window-name plugin to use wrapped Python with libtmux
    patchTmuxWindowNameShebang = config.lib.dag.entryAfter [ "installTmuxPlugins" ] ''
      SCRIPT="$HOME/.local/share/tmux/plugins/tmux-window-name/scripts/rename_session_windows.py"
      if [ -f "$SCRIPT" ]; then
        ${pkgs.gnused}/bin/sed -i '1s|.*|#!${
          (pkgs.python313.withPackages (ps: [ ps.libtmux ]))
        }/bin/python3|' "$SCRIPT"
      fi
    '';
  };

  # Honeyhive daemon, kept running in the background via launchd. The API
  # key and URL live only in ~/.private/.zshrc (untracked, outside this repo)
  # and are read at runtime by sourcing that file directly, so neither ever
  # ends up in this repo or the Nix store. RunAtLoad + KeepAlive means
  # launchd starts it once on load and restarts it if it dies; launchd
  # itself guarantees only one running instance per label.
  launchd.agents.honeyhive-daemon = lib.mkIf isDarwin {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.zsh}/bin/zsh"
        "-c"
        ''source "$HOME/.private/.zshrc" >/dev/null 2>&1; exec "${pkgs.uv}/bin/uvx" honeyhive-daemon run --key "$HH_API_KEY" --url "$HH_API_URL" --ci''
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/honeyhive-daemon.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/honeyhive-daemon.log";
    };
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fzf = {
      enable = true;
    };
  };
}
