{ config, pkgs, ... }:

{
  time.hardwareClockInLocalTime = false;

  # boot.extraModulePackages = with config.boot.kernelPackages; [
  #   ipu6-drivers
  # ];
  # hardware.firmware = with pkgs; [
  #   ipu6-camera-bins
  #   ivsc-firmware
  # ];
  # services.udev.extraRules = ''
  #   ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="8086", ATTR{idProduct}=="0b63", ATTR{power/control}="on"
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0x465d", ATTR{power/control}="on"
  #   ACTION=="add", SUBSYSTEM=="i2c", DRIVERS=="ov01a10", ATTR{power/control}="on"
  #   ACTION=="add", SUBSYSTEM=="i2c", DRIVERS=="ov2740", ATTR{power/control}="on"
  #   SUBSYSTEM=="intel-ipu6-psys", MODE="0660", GROUP="video"
  # '';

  hardware.i2c.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.enableAllFirmware = true;

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  # Power Management
  powerManagement.enable = true;
  services.thermald.enable = true;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
  services.upower.enable = true;
}
