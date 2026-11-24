{ config, pkgs, ... }:

{
  boot = {
    # Enable "Silent boot"
    # consoleLogLevel = 0;
    initrd = {
      kernelModules = [
        "i915"
        # "nvidia"
      ];
    };
    plymouth = {
      enable = true;
      theme = "stylix";
      # themePackages = with pkgs; [
      #   # By default we would install all themes
      #   (adi1090x-plymouth-themes.override {
      #     selected_themes = [ "motion" ];
      #   })
      # ];
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
      #"i915.force_probe=7d55"
      #"modprobe.blacklist=nouveau"
      #"nvidia-drm.modeset=1"
      "nvidia.NVreg_EnableBacklightHandler=0"
      "nvidia.NVreg_RegistryDwords=EnableBrightnessControl=0"
      "quiet"
      #"rd.driver.blacklist=nouveau"
      #"rd.systemd.show_status=auto"
      "splash"
      "udev.log_priority=3"
    ];
    binfmt = {
      emulatedSystems = [ "aarch64-linux" ];
      preferStaticEmulators = true; # Make it work with Docker
    };
    # Retrying latest (7.3.x). Early 7.x regressed CPU scheduling/performance on
    # this machine; fall back to `pkgs.linuxPackages_6_18` if it recurs.
    kernelPackages = pkgs.linuxPackages_latest;
    # Allow unprivileged `perf` (e.g. `perf sched`) for diagnosing scheduler issues
    kernel.sysctl."kernel.perf_event_paranoid" = 1;
    # extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  };
}
