{
  config,
  lib,
  pkgs-unstable,
  ...
}:

let
  cfg = config.services.headscale;

  clientSecretFile = "headscale-client_secret";
in
{
  disabledModules = [ "services/networking/headscale.nix" ]; # TODO: remove after 26.11

  imports = [
    "${pkgs-unstable.path}/nixos/modules/services/networking/headscale.nix"

    ./dns.nix
    ./headplane.nix
  ];

  age.secrets.${clientSecretFile}.owner = cfg.user;

  web.ports = {
    headscale = null;
    headscale_grpc = 50443;
    metrics_headscale = null;
  };

  services.headscale = {
    enable = true;
    package = pkgs-unstable.headscale;
    address = "127.0.0.1";
    port = config.web.ports.headscale;
    settings = {
      server_url = config.web.sites.headscale.url;

      metrics_listen_addr = "127.0.0.1:${toString config.web.ports.metrics_headscale}";

      grpc_listen_addr = "127.0.0.1:${toString config.web.ports.headscale_grpc}";
      grpc_allow_insecure = false;

      prefixes = {
        v4 = "100.64.0.0/10";
        v6 = "fd7a:115c:a1e0::/48";
        allocation = "random";
      };

      derp = {
        server.enabled = false;
        urls = [
          "https://controlplane.tailscale.com/derpmap/default"
        ];
      };

      database = {
        type = "sqlite";
        sqlite = {
          path = "/var/lib/headscale/db.sqlite";
          write_ahead_log = true;
        };
      };

      policy.mode = "database";

      dns = {
        magic_dns = true;
        base_domain = "ts.${config.web.primaryDomain}";
        override_local_dns = false;
        search_domains = [ "tn.${config.web.primaryDomain}" ];
        extra_records_path = "/var/lib/headscale/extra-records.json";
      };

      unix_socket_permission = "0770";

      oidc = {
        only_start_if_oidc_is_available = false;
        issuer = config.web.sites.auth.url;
        client_id = "headscale";
        client_secret_path = config.age.secrets.${clientSecretFile}.path;
        scope = [
          "openid"
          "profile"
          "email"
          "groups"
        ];
        allowed_groups = [
          "admin"
          "users"
        ];
        pkce = {
          enabled = true;
          method = "S256";
        };
      };

      taildrop.enabled = true;
    };
  };
  systemd.tmpfiles.rules = lib.mkIf (cfg.settings.dns.extra_records_path != null) [
    "f ${lib.escapeShellArg cfg.settings.dns.extra_records_path} 0620 ${cfg.user} ${cfg.group} - -"
  ];

  web.sites.headscale = {
    aliases = [ "tailscale" ];
    genMagicDnsEntry = false;
    reverseProxy = config.web.ports.headscale;
    locations."/".nginxConfig = {
      proxyWebsockets = true;
      extraConfig = ''
        proxy_buffering off;
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
      '';
    };
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "headscale";
      static_configs = [
        {
          targets = [
            cfg.settings.metrics_listen_addr
          ];
          labels.instance = config.networking.hostName;
        }
      ];
    }
  ];
}
