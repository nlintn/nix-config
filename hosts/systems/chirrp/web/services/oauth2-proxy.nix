{
  config,
  lib,
  ...
}:

let
  cfg = config.services.oauth2-proxy;

  clientSecretFile = "oauth2-client_secret";
  cookieSecretFile = "oauth2-cookie_secret";

  user = config.systemd.services.oauth2-proxy.serviceConfig.User;

  domains = [
    cfg.nginx.domain
  ]
  ++ (
    config.web.sites
    |> lib.filterAttrs (_: v: v.restrictAccess.auth.enable or false)
    |> lib.mapAttrsToList (_: v: v.allDomains)
    |> lib.flatten
  );
in
{
  age.secrets.${clientSecretFile}.owner = user;
  age.secrets.${cookieSecretFile}.owner = user;

  web.uds = {
    oauth2-proxy = { };
    oauth2-proxy-metrics = {
      inherit (config.web.uds.oauth2-proxy) dir serviceName group;
    };
  };

  services.oauth2-proxy = {
    enable = true;
    httpAddress = "unix://${config.web.uds.oauth2-proxy.path},mode=0770";
    clientID = "oauth2-proxy";
    redirectURL = "${config.web.sites.oauth2-proxy.url}/oauth2/callback";
    clientSecretFile = config.age.secrets.${clientSecretFile}.path;
    oidcIssuerUrl = config.web.sites.auth.url;
    provider = "oidc";
    reverseProxy = true;
    trustedProxyIP = [ "127.0.0.1" ];
    setXauthrequest = true;
    extraConfig = {
      code-challenge-method = "S256";
      cookie-domain = [
        ".${config.web.primaryDomain}"
        config.web.primaryDomain
      ];
      cookie-expire = 0;
      cookie-httponly = true;
      cookie-name = "__Secure-oauth2_proxy";
      cookie-samesite = "lax";
      cookie-secret-file = config.age.secrets.${cookieSecretFile}.path;
      cookie-secure = true;

      whitelist-domain = domains;
      skip-provider-button = true;
      show-debug-on-error = false;
      metrics-address = "unix://${config.web.uds.oauth2-proxy-metrics.path},mode=0720";
    };
    scope = "openid profile email groups";

    email.domains = [ "*" ];

    nginx = {
      domain = config.web.sites.oauth2-proxy.domain;
      proxy = "http://unix:/${config.web.uds.oauth2-proxy.path}:";
      virtualHosts =
        config.web.sites
        |> lib.filterAttrs (_: v: v.restrictAccess.auth.enable)
        |> lib.mapAttrs' (_: v: lib.nameValuePair v.domain v.restrictAccess.auth.config);
    };
  };

  web.sites.oauth2-proxy = {
    locations."/".nginxConfig.return = 418;
    locations."= /metrics" = {
      reverseProxy = config.web.uds.oauth2-proxy-metrics.path;
      localhostOnly = true;
    };
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "oauth2-proxy";
      scheme = "https";
      static_configs = [
        {
          targets = [ config.web.sites.oauth2-proxy.domain ];
          labels.instance = config.networking.hostName;
        }
      ];
    }
  ];
}
