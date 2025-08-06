{ config, lib, ... }:

{
  networking = {
    usePredictableInterfaceNames = false;

    networkmanager = {
      enable = true;
      wifi.powersave = true;
      # dhcp = "dhcpcd";
      # logLevel = "TRACE";
    };
    firewall.enable = true;
    nftables.enable = true;

    nameservers = [ "127.0.0.1" "::1" ];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";
  };
  services.resolved.enable = lib.mkForce false;

  services.dnscrypt-proxy2 = {
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
  environment.shellAliases."dns-restart" = "${config.systemd.package}/bin/systemctl restart dnscrypt-proxy2.service";
  environment.shellAliases."dns-stop" = "${config.systemd.package}/bin/systemctl stop dnscrypt-proxy2.service";
}
