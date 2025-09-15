{ pkgs, ... }:

{
  time.hardwareClockInLocalTime = true;

  hardware.i2c.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # hardware.ipu6 = {
  #   enable = true;
  #   platform = "ipu6ep";
  # };

  hardware.enableAllFirmware = true;

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables.LIBVA_DRIVER_NAME = "i965";

  # Power Management
  # powerManagement.enable = true;
  # powerManagement.powertop.enable = true;
  services.thermald.enable = true;
  # services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      START_CHARGE_THRESH_BAT1 = 30;
      STOP_CHARGE_THRESH_BAT1 = 80;

      USB_AUTOSUSPEND = 0;
    };
  };
  services.upower.enable = true;
}
