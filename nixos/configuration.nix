{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    # Enable "Silent boot"
    # consoleLogLevel = 0;
    initrd = {
      systemd.enable = true;
      verbose = false;
      kernelModules = [
        "i915"
        # "nvidia"
      ];
    };
    plymouth = {
      enable = true;
      theme = "motion";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "motion" ];
        })
      ];
    };
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
    # Bootloader
    loader = {
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "max";
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [
      "boot.shell_on_fail"
      "i915.enable_dpcd_backlight=1"
      "i915.force_probe=7d55"
      "modprobe.blacklist=nouveau"
      "nvidia-drm.modeset=1"
      "nvidia.NVreg_EnableBacklightHandler=0"
      "nvidia.NVreg_RegistryDwords=EnableBrightnessControl=0"
      "quiet"
      "rd.driver.blacklist=nouveau"
      "rd.systemd.show_status=auto"
      "splash"
      "udev.log_priority=3"
    ];
    kernelPackages = pkgs.linuxPackages_6_12;
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  };
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Enable networking
  networking.networkmanager.enable = true;
  # Set your time zone.
  time.timeZone = "America/Los_Angeles";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  services.supergfxd.enable = true;
  services.switcherooControl.enable = true;
  services.power-profiles-daemon.enable = true;
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
      options = "ctrl:nocaps";
    };
    desktopManager.gnome.enable = true;
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
  };
  # Enable the Cinnamon Desktop Environment.
  # displayManager.lightdm.enable = true;
  # desktopManager.cinnamon.enable = true;
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "x";
  };
  environment.gnome.excludePackages = (with pkgs; [
    atomix # puzzle game
    cheese # webcam tool
    epiphany # web browser
    evince # document viewer
    geary # email reader
    gedit # text editor
    gnome-characters
    gnome-music
    gnome-photos
    gnome-terminal
    gnome-tour
    hitori # sudoku game
    iagno # go game
    tali # poker game
    totem # video player
  ]);
  # enable flatpak
  services.flatpak.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;
  # asusctl module
  services.asusd = {
    enable = true;
    enableUserService = true;
  };
  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      intel-media-driver
      # your Open GL, Vulkan and VAAPI drivers
      vpl-gpu-rt # for newer GPUs on NixOS >24.05 or unstable
      # onevpl-intel-gpu  # for newer GPUs on NixOS <= 24.05
      # intel-media-sdk   # for older GPUs
    ];
  };
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;
    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = true;
    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  # Define a user account. Don't forget to set a password with passwd
  users.users.x = {
    isNormalUser = true;
    description = "x";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      #  thunderbird
    ];
  };
  security.sudo.extraRules = [
    {
      users = [ "x" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" "SETENV" ];
        }
      ];
    }
  ];
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs._1password-gui.enable = true;
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "sudo" ];
    theme = "robbyrussell";
  };
  programs.virt-manager.enable = true;
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    # LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };
  # Install firefox.
  programs.firefox.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    # packageOverrides = pkgs: {
    #   unstable = import <nixos-unstable> {
    #     config = config.nixpkgs.config;
    #   };
    # };
  };

  # allow AppImage files to be executable
  programs.appimage.binfmt = true;
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
    ];
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # graphical apps
    _1password
    firefox
    flatpak
    orca-slicer
    ungoogled-chromium
    # shell utils
    bat
    bc
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
    # nix-software-center
    gearlever
    appimage-run
    # unstable.mullvad-vpn

    # dev tools
    bun
    chromium
    neovim
    nodejs_22
    python312Full
    python312Packages.pip
    # gcc
    # libgcc
    # gnumake
    # cmake
    # extra-cmake-modules
    nix-index
    # system
    switcheroo-control
    # nerd-fonts.fira-code
    gnome-tweaks
    yaru-theme
    # pciutils
    # usbutils
    # vm stuff
    # cloud-utils
    # spice
    # virtiofsd
    # qemu_full
    # edk2
    # edk2-uefi-shell
    # virt-viewer
    distrobox
    kicad
    discord
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];


  # systemd.sleep.extraConfig = ''
  #   AllowSuspend=yes
  #   AllowHibernation=no
  #   AllowHybridSleep=no
  #   AllowSuspendThenHibernate=no
  # '';
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = true;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It
  # perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
