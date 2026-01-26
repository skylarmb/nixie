{ config, pkgs, userConfig, tpm, isDarwin ? true, ... }:

{
  home.username = userConfig.username;
  home.homeDirectory = if isDarwin then "/Users/${userConfig.username}" else "/home/${userConfig.username}";
  home.stateVersion = "25.05"; # Please read the comment before changing.
  home.packages = [
      # dependencies
      # pkgs.gccgo
      # pkgs.gnumake
      pkgs.nodejs_22

      # programs
      pkgs.tmux
      # pkgs.wezterm
      pkgs.helix
      pkgs.neovim
      pkgs.stylua
      pkgs.prettierd
      pkgs.eslint_d
      pkgs.expect
      pkgs.glow # terminal markdown viewer
      pkgs.act
      # pkgs.orca-slicer

      # shell
      pkgs.zsh
      pkgs.ripgrep
      # pkgs.direnv
      pkgs.oh-my-zsh
      pkgs.fzf
      pkgs.bat
      pkgs.eza
      pkgs.fd
      pkgs.git
      pkgs.gh
      pkgs.delta
      pkgs.tig
      pkgs.tree
      pkgs.sd
      pkgs.htmlq
      pkgs.bat-extras.core
      pkgs.awscli2
      pkgs.kubectl
      pkgs.gemini-cli

      # containers
      # pkgs.podman
      # pkgs.qemu
      # pkgs.virtiofsd
      # pkgs.docker
      # pkgs.docker-buildx
      # pkgs.docker-compose
      # pkgs.nvidia-container-toolkit
    ];

  home.file = {
    # shell stuff
    ".zprofile".source = dotfiles/.zprofile;
    ".zshrc".source = dotfiles/.zshrc;
    ".antigenrc".source = dotfiles/.antigenrc;
    ".wezterm.lua".source = dotfiles/.wezterm.lua;
    "antigen.zsh".source = dotfiles/antigen.zsh;
    ".oh-my-zsh/custom/themes/af-magic-ansi.zsh-theme".source = dotfiles/.oh-my-zsh/custom/themes/af-magic-ansi.zsh-theme;

    # applications
    ".config/git".source = dotfiles/.config/git;
    ".config/nvim/init.lua".source = dotfiles/.config/nvim/init.lua;
    ".config/nvim/lua".source = dotfiles/.config/nvim/lua;
    ".config/nvim/snippets".source = dotfiles/.config/nvim/snippets;
    ".config/nvim/syntax".source = dotfiles/.config/nvim/syntax;

    # Tmux - symlink config files individually to allow TPM management
    ".config/tmux/tmux.conf".source = dotfiles/.config/tmux/tmux.conf;
    ".config/tmux/colorscheme.conf".source = dotfiles/.config/tmux/colorscheme.conf;

    ".config/containers/registries.conf".source = dotfiles/.config/containers/registries.conf;
    ".config/containers/policy.json".source = dotfiles/.config/containers/policy.json;

    # TPM - Tmux Plugin Manager (managed by Nix)
    ".config/tmux/plugins/tpm".source = tpm;

    ".config/nix/nix.conf".text = ''
      experimental-features = nix-command flakes
    '';

    ".config/npm/npmrc".text = ''
      cache=~/.cache/npm
      prefix=~/.local/share/npm
    '';

    "bin".source = dotfiles/bin;

    # Claude Code configuration - synced across machines
    ".claude/CLAUDE.md".source = dotfiles/.claude/CLAUDE.md;
    ".claude/settings.json".source = dotfiles/.claude/settings.json;
    ".claude/explore.md".source = dotfiles/.claude/explore.md;

    # Symlink agent files individually to allow directory to remain writable
    ".claude/agents/code-edit-executor.md".source = dotfiles/.claude/agents/code-edit-executor.md;
    ".claude/agents/console-log-analyzer.md".source = dotfiles/.claude/agents/console-log-analyzer.md;
    ".claude/agents/eslint-fixer.md".source = dotfiles/.claude/agents/eslint-fixer.md;

    ".claude/commands".source = dotfiles/.claude/commands;
    ".claude/output-styles".source = dotfiles/.claude/output-styles;

    # Gemini configuration - same as Claude.md
    ".gemini/GEMINI.md".source = dotfiles/.claude/CLAUDE.md;

    # OpenCode configuration - same as Claude.md
    ".config/opencode/AGENTS.md".source = dotfiles/.claude/CLAUDE.md;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc";
    # DOCKER_HOST = "unix:///run/user/1000/podman/podman-machine-default-api.sock";
  };

  # Activation scripts
  home.activation = {
    # Install TPM plugins automatically
    installTmuxPlugins = config.lib.dag.entryAfter ["installPackages"] ''
      if [ -x "$HOME/.config/tmux/plugins/tpm/bin/install_plugins" ]; then
        export PATH="${pkgs.tmux}/bin:${pkgs.gawk}/bin:${pkgs.gnused}/bin:${pkgs.gnugrep}/bin:${pkgs.coreutils}/bin:${pkgs.git}/bin:$PATH"
        $DRY_RUN_CMD "$HOME/.config/tmux/plugins/tpm/bin/install_plugins" || true
      fi
    '';
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    # direnv = {
    #   enable = true;
    #   nix-direnv.enable = true;
    # };
  };
}
