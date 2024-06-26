{ config, pkgs, ... }:

{
  home.username = "skylar";
  home.homeDirectory = "/home/skylar";
  home.enableNixpkgsReleaseCheck = false;

  home.file = {
    # shell stuff
    ".profile".source = dotfiles/.profile;
    ".zprofile".source = dotfiles/.zprofile;
    ".zshrc".source = dotfiles/.zshrc;
    ".antigenrc".source = dotfiles/.antigenrc;
    "antigen.zsh".source = dotfiles/antigen.zsh;
    ".p10k.zsh".source = dotfiles/.p10k.zsh;
    # ".fzf.zsh".source = dotfiles/.fzf.zsh;
    ".lessfilter".source = dotfiles/.lessfilter;

    # applications
    ".config/alacritty".source = dotfiles/.config/alacritty;
    ".config/git".source = dotfiles/.config/git;
    ".config/hypr".source = dotfiles/.config/hypr;
    ".config/nvim".source = dotfiles/.config/nvim;
    ".config/tmux".source = dotfiles/.config/tmux;
    ".config/waybar".source = dotfiles/.config/waybar;
    ".config/systemd".source = dotfiles/.config/systemd;
    ".config/spotifyd".source = dotfiles/.config/spotifyd;

    "bin".source = dotfiles/bin;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  xdg.desktopEntries = {
    slack = {
      name = "Slack";
      exec = "/home/skylar/bin/electron-wrappper https://app.slack.com/client/T016VMW1064/C015Z55806S";
      terminal = false;
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # DO NOT CHANGE THIS.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
