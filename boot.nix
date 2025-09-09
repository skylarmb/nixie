{ config, pkgs, ... }:

{
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
      # # theme = "motion";
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
    kernelPackages = pkgs.linuxPackages_latest;
    # extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  };
}
