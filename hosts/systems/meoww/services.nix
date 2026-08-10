{
  config,
  lib,
  pkgs,
  ...
}:

{
  services = {
    accounts-daemon.enable = true;
    blueman.enable = true; # bluetooth manager
    earlyoom = {
      enable = true;
      enableNotifications = true;
    };
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      touchpad.accelProfile = "adaptive";
    };
    pcscd.enable = true; # smart cards
    tailscale = {
      enable = true;
      disableUpstreamLogging = true;
      extraSetFlags = [
        "--operator=nico"
      ]
      ++ lib.optional config.services.dnscrypt-proxy.enable "--accept-dns=false";
      useRoutingFeatures = "client";
    };

    # fs stuff
    gvfs.enable = true; # for trash etc
    udisks2.enable = true; # for hot plugging usb storage etc

    # printing
    printing = {
      enable = true;
      browsing = true;
      defaultShared = true;
      drivers = [ pkgs.canon-cups-ufr2 ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
