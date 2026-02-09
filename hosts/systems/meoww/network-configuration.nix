{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking = {
    usePredictableInterfaceNames = false;

    networkmanager = {
      enable = true;
      wifi.powersave = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
      dhcp = "dhcpcd";
    };

    firewall.enable = true;
    nftables.enable = true;

    nameservers = [
      "127.0.0.1"
      "::1"
    ];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";
  };
  services.resolved.enable = lib.mkForce false;

  services.dnscrypt-proxy = {
    enable = true;
    upstreamDefaults = false;
    settings = {
      listen_addresses = [
        "127.0.0.1:53"
        "[::1]:53"
      ];
      max_clients = 250;

      ipv4_servers = true;
      ipv6_servers = true;
      dnscrypt_servers = true;
      doh_servers = true;
      odoh_servers = false;
      require_dnssec = true;
      require_nolog = true;
      require_nofilter = true;
      disabled_server_names = [ ];

      force_tcp = false;
      http3 = true;
      http3_probe = false;

      timeout = 5000;
      keepalive = 30;

      # log_level = 0;
      use_syslog = true;

      bootstrap_resolvers = [
        "9.9.9.11:53"
        "149.112.112.11:53"
        "[2620:fe::11]:53"
        "[2620:fe::fe:11]:53"
      ];
      ignore_system_dns = false;
      netprobe_timeout = 60;
      netprobe_address = "9.9.9.9:53";

      block_ipv6 = false;
      block_unqualified = true;
      block_undelegated = true;
      reject_ttl = 10;

      forwarding_rules = pkgs.writeText "dnscrypt-forwarding-rules" ''
        fritz.box                 $DHCP

        detectportal.firefox.com  $DHCP
        iceportal.de              $DHCP
        login.wifionice.de        $DHCP
        ${lib.optionalString (lib.elem "--accept-dns=false" config.services.tailscale.extraSetFlags) ''
          ts.net                    100.100.100.100
          100.in-addr.arpa          100.100.100.100
        ''}
      '';

      cloaking_rules = "/etc/dnscrypt-cloaking-rules";
      cloak_ptr = false;

      cache = true;
      cache_size = 4096;
      cache_min_ttl = 2400;
      cache_max_ttl = 86400;
      cache_neg_min_ttl = 60;
      cache_neg_max_ttl = 600;

      sources = {
        public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          refresh_delay = 73;
          prefix = "";
        };
        quad9-resolvers = {
          urls = [
            "https://quad9.net/dnscrypt/quad9-resolvers.md"
            "https://raw.githubusercontent.com/Quad9DNS/dnscrypt-settings/main/dnscrypt/quad9-resolvers.md"
          ];
          cache_file = "/var/cache/dnscrypt-proxy/quad9-resolvers.md";
          minisign_key = "RWQBphd2+f6eiAqBsvDZEBXBGHQBJfeG6G+wJPPKxCZMoEQYpmoysKUN";
          refresh_delay = 73;
          prefix = "quad9-";
        };
      };

      broken_implementations.fragments_blocked = [
        "cisco"
        "cisco-ipv6"
        "cisco-familyshield"
        "cisco-familyshield-ipv6"
        "cisco-sandbox"
        "cleanbrowsing-adult"
        "cleanbrowsing-adult-ipv6"
        "cleanbrowsing-family"
        "cleanbrowsing-family-ipv6"
        "cleanbrowsing-security"
        "cleanbrowsing-security-ipv6"
      ];

      anonymized_dns.skip_incompatible = false;

      ip_encryption.algorithm = "none";

      monitoring_ui = {
        enabled = true;
        listen_address = "127.0.0.1:5335";
        username = "";
        password = "";
        enable_query_log = true;
        privacy_level = 0;
      };
    };
  };
  systemd.tmpfiles.rules = [
    ''f  "${config.services.dnscrypt-proxy.settings.cloaking_rules}"  0644  root  root  -  -''
  ];
  environment.shellAliases."dns-restart" =
    "${lib.getExe' config.systemd.package "systemctl"} restart dnscrypt-proxy2.service";
  environment.shellAliases."dns-stop" =
    "${lib.getExe' config.systemd.package "systemctl"} stop dnscrypt-proxy2.service";

  systemd.services.NetworkManager-wait-online.enable = false;
}
