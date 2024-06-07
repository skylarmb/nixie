# Edit this configuration file to define what should be installed on your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./apple-silicon-support
      <home-manager/nixos>
    ];

  # Boot
  hardware.asahi.peripheralFirmwareDirectory = ./firmware;

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
    consoleLogLevel = 0;
    kernelParams = [ "apple_dcp.show_notch=1" ];
  };

  # Network
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set time zone.
  time.timeZone = "America/Los_Angeles";

  # Enable graphical desktop environment
  services.xserver.enable = true;
  services.xserver.xkb.options = "ctrl:nocaps";
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true;
  services.flatpak.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = lib.mkForce false;
  };

  hardware.asahi = {
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    setupAsahiSound = true;
    withRust = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  programs.nix-ld.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable local fonts

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "UbuntuMono" ]; })
   ];

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Define user account.
  users.users.skylar = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };
  security.sudo.extraRules= [
    {
      users = [ "skylar" ];
      commands = [
        {
          command = "ALL" ;
          options= [ "NOPASSWD" "SETENV" ];
        }
      ];
    }
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs._1password-gui.enable = true;
  programs.zsh.enable = true;
  programs.virt-manager.enable = true;

  nixpkgs.config.allowUnfree = true;
  home-manager.useUserPackages = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    bat
    bc
    brightnessctl
    bun
    chromium
    cliphist
    clipman
    delta
    electron
    eza
    firefox
    flatpak
    fzf
    gcc
    gh
    git
    gnome.gnome-software
    home-manager
    hyprpaper
    hyprshot
    libnotify
    libsForQt5.polonium
    menulibre
    neovim
    nodejs
    ripgrep
    spot
    swaynotificationcenter
    tmux
    unzip
    wget
    wl-clipboard
    wofi
    wtype
    # vm stuff
    cloud-utils
    spice
    virtiofsd
  ];


  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # Do NOT change this value
  system.stateVersion = "24.05"; # Did you read the comment?
}

