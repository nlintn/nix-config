{ ... }:

{
  services = {
    blueman.enable = true; # bluetooth manager
    earlyoom = {
      enable = true;
      enableNotifications = true;
    };
    gvfs.enable = true; # for hot plugging usb storage etc
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      touchpad.accelProfile = "adaptive";
    };
    logind.settings.Login = {
      HandlePowerKey = "suspend";
      HandleLidSwitch = "suspend";
    };
    pcscd.enable = true; # smart cards
    tailscale = {
      enable = true;
      disableUpstreamLogging = true;
      extraSetFlags = [
        "--operator=nico"
      ];
      useRoutingFeatures = "client";
    };
    tumbler.enable = true; # thumbnails

    # printing
    printing = {
      enable = true;
      browsing = true;
      defaultShared = true;
      # drivers = [ pkgs.cupsDrivers.generic ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
  };
}
