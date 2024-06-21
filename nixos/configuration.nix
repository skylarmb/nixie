# Edit this configuration file to define what should be installed on your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let
  nix-software-center = import (pkgs.fetchFromGitHub {
    owner = "snowfallorg";
    repo = "nix-software-center";
    rev = "0.1.2";
    sha256 = "xiqF1mP8wFubdsAQ1BmfjzCgOD3YZf7EGWl9i69FTls=";
  }) {};
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <apple-silicon-support/apple-silicon-support>
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
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPortRanges = [
      { from = 1234; to = 1234; } # spotifyd
    ];
  };

  # Set time zone.
  time.timeZone = "America/Los_Angeles";

  # Enable graphical desktop environment
  services.xserver.enable = true;
  services.xserver.xkb.options = "ctrl:nocaps";
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  # services.greetd = {
  #   enable = true;
  #   settings = rec {
  #     initial_session = {
  #       command = "${pkgs.hyprland}/bin/Hyprland";
  #       user = "skylar";
  #     };
  #     default_session = initial_session;
  #   };
  # };
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
    # graphical apps
    _1password
    alacritty
    blueberry
    firefox
    flatpak
    gnome.gnome-software
    gnome.gnome-tweaks
    helvum
    spot
    spotifyd

    # shell utils
    alsa-utils
    bat
    bc
    brightnessctl
    delta
    dig
    eza
    fzf
    gcc
    gh
    gimp
    git
    htop
    jq
    ripgrep
    tig
    tmux
    unzip
    wget

    # desktop environment
    cliphist
    clipman
    home-manager
    hyprlock
    hyprpaper
    hyprshot
    kooha
    libnotify
    libsecret
    menulibre
    swayidle
    swaynotificationcenter
    wl-clipboard
    wofi
    wtype
    nix-software-center

    # dev tools
    bun
    chromium
    electron
    neovim
    nodejs

    # vm stuff
    # cloud-utils
    # spice
    # virtiofsd
    # qemu_full
    # edk2
    # edk2-uefi-shell
    # virt-viewer
  ];


  virtualisation.docker.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # Do NOT change this value
  system.stateVersion = "24.05"; # Did you read the comment?
}

