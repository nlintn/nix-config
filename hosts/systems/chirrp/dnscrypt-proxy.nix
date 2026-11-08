{
  config,
  pkgs,
  ...
}:

{
  networking.firewall.allowedUDPPorts = [ 53 ];
  services.dnscrypt-proxy = {
    enable = true;
    upstreamDefaults = false;
    settings = {
      listen_addresses = [ ":53" ];
      max_clients = 250;

      ipv4_servers = true;
      ipv6_servers = false; # No IPv6 for me 💀
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

      use_syslog = true;

      bootstrap_resolvers = [
        "9.9.9.11:53"
        "149.112.112.11:53"
        "[2620:fe::11]:53"
        "[2620:fe::fe:11]:53"
      ];
      ignore_system_dns = false;
      netprobe_timeout = 0;
      netprobe_address = "9.9.9.9:53";

      block_ipv6 = true; # No IPv6 for me 💀
      block_unqualified = true;
      block_undelegated = true;
      reject_ttl = 10;

      cloaking_rules = pkgs.writeText "dnscrypt-cloaking-rules" ''
        fritz.box     192.168.188.1
      '';
      cloak_ptr = true;

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
    };
  };

  web.ports.metrics_dnscrypt-proxy = null;
  services.dnscrypt-proxy.settings.monitoring_ui = {
    enabled = true;
    listen_address = "127.0.0.1:${toString config.web.ports.metrics_dnscrypt-proxy}";
    username = "";
    password = "";
    enable_query_log = true;
    privacy_level = 0;
    prometheus_enabled = true;
    prometheus_path = "/metrics";
  };

  web.sites.dns-monitoring = {
    reverseProxy = config.web.ports.metrics_dnscrypt-proxy;
    locations = {
      "= /metrics" = {
        localhostOnly = true;
        authExclude = true;
      };
    };
    restrictAccess = {
      auth = {
        enable = true;
        config.allowed_groups = [ "admin" ];
      };
      origin.enable = true;
      satisfy = "all";
    };
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "dnscrypt-proxy";
      static_configs = [
        {
          targets = [ config.services.dnscrypt-proxy.settings.monitoring_ui.listen_address ];
          labels.instance = config.networking.hostName;
        }
      ];
    }
  ];
}
