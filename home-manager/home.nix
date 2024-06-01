{ config, pkgs, ... }:

{
  home.username = "skylar";
  home.homeDirectory = "/home/skylar";
  home.enableNixpkgsReleaseCheck = false;

  home.file = {
    # shell stuff
    ".zprofile".source = dotfiles/.zprofile;
    ".zshrc".source = dotfiles/.zshrc;
    ".antigenrc".source = dotfiles/.antigenrc;
    "antigen.zsh".source = dotfiles/antigen.zsh;
    ".p10k.zsh".source = dotfiles/.p10k.zsh;
    ".fzf.zsh".source = dotfiles/.fzf.zsh;
    ".lessfilter".source = dotfiles/.lessfilter;

    # applications
    ".config/alacritty".source = dotfiles/.config/alacritty;
    ".config/git".source = dotfiles/.config/git;
    ".config/hypr".source = dotfiles/.config/hypr;
    ".config/nvim".source = dotfiles/.config/nvim;
    ".config/tmux".source = dotfiles/.config/tmux;
    ".config/waybar".source = dotfiles/.config/waybar;

    "bin".source = dotfiles/bin;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # DO NOT CHANGE THIS.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
