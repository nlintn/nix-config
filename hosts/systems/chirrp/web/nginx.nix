{
  config,
  lib,
  ...
}:

let
  logFormat = "combined_host";
  mapLogIp = "log_ip";
in
{
  web.defaultOriginAllow = [
    "100.64.0.0/10"
    "fd7a:115c:a1e0::/48"
    "127.0.0.1"
    "::1"
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx = {
    enable = true;
    enableReload = true;
    statusPage = true;
    recommendedBrotliSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedUwsgiSettings = true;
    commonHttpConfig = ''
      map $remote_addr ''$${mapLogIp} {
        "::1"       0;
        "127.0.0.1" 0;
        default     1;
      }

      log_format combined_host '$remote_addr : $remote_user [$time_local] '
                               '"$http_host" "$request" $status $body_bytes_sent '
                               '"$http_referer" "$http_user_agent" $email';

      access_log /var/log/nginx/access.log ${logFormat} if=''$${mapLogIp};
    '';
  };

  systemd.services.nginx.serviceConfig.SupplementaryGroups =
    lib.attrValues config.web.uds
    |> lib.filter (v: v.nginxAddGroup)
    |> lib.map (v: v.group)
    |> lib.unique;

  services.nginx.virtualHosts = lib.mapAttrs' (
    _: v:
    lib.nameValuePair v.domain (
      lib.mkMerge [
        {
          serverName = v.domain;
          serverAliases = v.extraDomains;
          forceSSL = v.ssl;
        }
        (lib.mkIf (v.accessLog != null) {
          extraConfig = "access_log ${v.accessLog} ${logFormat} if=\$${mapLogIp};";
        })
        (lib.mkIf (v.errorLog != null) {
          extraConfig = "error_log ${v.errorLog};";
        })
        (lib.mkIf v.genCert {
          useACMEHost = v.domain;
          acmeRoot = config.security.acme.certs.${v.domain}.webroot;
        })
        (
          let
            cfg = v.restrictAccess;
          in
          lib.mkIf (cfg.auth.enable || cfg.origin.enable) {
            extraConfig = ''
              satisfy ${cfg.satisfy};
            ''
            + (lib.optionalString cfg.origin.enable (
              lib.concatLines (
                lib.map (x: "deny ${x};") cfg.origin.deny
                ++ lib.map (x: "allow ${x};") cfg.origin.allow
                ++ [ "deny all;" ]
              )
            ));
          }
        )
        {
          locations = lib.mapAttrs (
            _: v:
            lib.mkMerge [
              {
                proxyPass = lib.mkIf (lib.types.port.check v.reverseProxy) "http://127.0.0.1:${toString v.reverseProxy}";
              }
              {
                proxyPass = lib.mkIf (lib.types.path.check v.reverseProxy) "http://unix:/${v.reverseProxy}:";
              }
              {
                proxyPass = lib.mkIf (
                  lib.types.str.check v.reverseProxy && !lib.types.path.check v.reverseProxy
                ) "http://${v.reverseProxy}";
              }
              {
                extraConfig = lib.mkIf v.localhostOnly ''
                  satisfy all;
                  allow 127.0.0.1;
                  allow ::1;
                  deny all;
                '';
              }
              {
                extraConfig = lib.mkIf v.authExclude ''
                  auth_request off;
                '';
              }
              {
                extraConfig = lib.mkIf v.originExclude ''
                  allow all;
                '';
              }
              v.nginxConfig
            ]
          ) v.locations;
        }
        (lib.mkIf v.maintenance {
          locations = lib.mkForce { "/".return = 503; };
        })
        v.nginxConfig
      ]
    )
  ) config.web.sites;
}
