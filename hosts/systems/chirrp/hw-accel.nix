{
  pkgs,
  ...
}:

{
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
  # environment.sessionVariables.LIBVA_DRIVER_NAME = "i965";

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      # intel-media-sdk
      # intel-ocl
      intel-vaapi-driver
      libva-vdpau-driver
    ];
  };
}
