{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "x";
  home.homeDirectory = "/home/x";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # dependencies
    pkgs.gccgo
    pkgs.gnumake
    pkgs.nodejs_22

    # programs
    pkgs.neovim
    pkgs.tmux
    pkgs.zsh

    # shell
    pkgs.ripgrep
    pkgs.direnv
    pkgs.oh-my-zsh
    pkgs.fzf
    pkgs.bat
    pkgs.eza
    pkgs.fd
    pkgs.gh
    pkgs.delta
    pkgs.tig
    pkgs.tree

    # containers
    # pkgs.podman
    # pkgs.qemu
    # pkgs.virtiofsd
    # pkgs.docker
    # pkgs.docker-buildx
    # pkgs.docker-compose
    # pkgs.nvidia-container-toolkit
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # shell stuff
    ".profile".source = dotfiles/.profile;
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

    "bin".source = dotfiles/bin;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/x/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    # DOCKER_HOST = "unix:///run/user/1000/podman/podman-machine-default-api.sock";
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
  };
}
