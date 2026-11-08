{
  config,
  lib,
  ...
}:

{
  networking = {
    usePredictableInterfaceNames = true;

    networkmanager = {
      enable = true;
      unmanaged = [ "interface-name:ve-*" ];
    };

    firewall = {
      enable = true;
      logRefusedPackets = false;
    };
    nftables = {
      enable = true;
      flushRuleset = true;
    };

    nameservers = [
      "127.0.0.1"
      "::1"
    ];
    resolvconf.extraOptions = [ "no-aaaa" ]; # No IPv6 for me 💀
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";

    hosts = {
      "127.0.0.1" = config.web.allDomains;
      "::1" = config.web.allDomains;
    };
  };
  services.resolved.enable = lib.mkForce false;
}
