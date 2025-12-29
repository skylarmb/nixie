{ config, pkgs, ... }:

{
    home.username = "x";
    home.homeDirectory = "/home/x";
    home.stateVersion = "25.05"; # Please read the comment before changing.
    home.packages = [
      # dependencies
      # pkgs.gccgo
      # pkgs.gnumake
      pkgs.nodejs_22

      # programs
      pkgs.tmux
      pkgs.wezterm
      pkgs.neovim
      pkgs.stylua
      pkgs.prettierd
      pkgs.eslint_d
      pkgs.calibre
      pkgs.calibre-web
      pkgs.orca-slicer
      pkgs.plasticity

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
      pkgs.unzip
      pkgs.gh
      pkgs.delta
      pkgs.tig
      pkgs.tree
      pkgs.sd
      pkgs.wl-clipboard

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

    # applications
    ".config/git".source = dotfiles/.config/git;
    ".config/nvim/init.lua".source = dotfiles/.config/nvim/init.lua;
    ".config/nvim/lua".source = dotfiles/.config/nvim/lua;
    ".config/nvim/snippets".source = dotfiles/.config/nvim/snippets;
    ".config/nvim/syntax".source = dotfiles/.config/nvim/syntax;
    ".config/tmux".source = dotfiles/.config/tmux;
    ".config/containers/registries.conf".source = dotfiles/.config/containers/registries.conf;
    ".config/containers/policy.json".source = dotfiles/.config/containers/policy.json;

    ".config/nix/nix.conf".text = ''
    experimental-features = nix-command flakes
    '';

    ".config/npm/npmrc".text = ''
      cache=~/.cache/npm
      prefix=~/.local/share/npm
    '';

    "bin".source = dotfiles/bin;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc";
    PATH="$PATH:$HOME/.local/share/npm/bin";
    # DOCKER_HOST = "unix:///run/user/1000/podman/podman-machine-default-api.sock";
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
