{
  pkgs,
  ...
}:

{
  hardware.enableAllFirmware = true;

  time.hardwareClockInLocalTime = false;

  boot.kernelModules = [
    "ddcci"
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  hardware.i2c.enable = true;
  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

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
