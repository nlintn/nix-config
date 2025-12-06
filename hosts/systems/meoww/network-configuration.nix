{ config, lib, pkgs, ... }:

{
  networking = {
    usePredictableInterfaceNames = false;

    networkmanager = {
      enable = true;
      wifi.powersave = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
      # dhcp = "dhcpcd";
    };

    firewall.enable = true;
    nftables.enable = true;

    nameservers = [ "127.0.0.1" "::1" ];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";
  };
  services.resolved.enable = lib.mkForce false;

  services.dnscrypt-proxy = {
    enable = true;
    settings = {
      # query_log.file = "/var/log/dnscrypt-proxy/query.log";
      ipv4_servers = true;
      ipv6_servers = false;
      dnscrypt_servers = true;
      doh_servers = true;
      odoh_servers = false;
      require_dnssec = true;
      require_nolog = true;
      require_nofilter = true;
      # skip_incompatible = false;

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };
    };
  };
  environment.shellAliases."dns-restart" = "${lib.getExe' config.systemd.package "systemctl"} restart dnscrypt-proxy2.service";
  environment.shellAliases."dns-stop" = "${lib.getExe' config.systemd.package "systemctl"} stop dnscrypt-proxy2.service";

  systemd.services.NetworkManager-wait-online.enable = false;
}
