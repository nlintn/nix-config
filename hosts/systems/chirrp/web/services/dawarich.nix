{
  config,
  lib,
  pkgs-unstable,
  ...
}:

let
  cfg = config.services.dawarich;

  dir = "/var/lib/dawarich";
in
{
  disabledModules = [ "services/web-apps/dawarich.nix" ]; # TODO: remove after 26.11
  imports = [ "${pkgs-unstable.path}/nixos/modules/services/web-apps/dawarich.nix" ]; # TODO "

  fileSystems.${dir} = {
    device = "zp1-chirrp/data/dawarich";
    fsType = "zfs";
  };

  web.ports = {
    dawarich = null;

    metrics_dawarich = null;
    metrics_dawarich_sidekiq = null;
  };

  services.dawarich = {
    enable = true;
    package = pkgs-unstable.dawarich; # TODO: switch back to pkgs-stable
    configureNginx = false;
    webPort = config.web.ports.dawarich;
    localDomain = config.web.sites.dawarich.domain;
    environment = {
      APPLICATION_HOSTS = lib.concatStringsSep "," config.web.sites.dawarich.allDomains;

      DISTANCE_UNIT = "km";

      PHOTON_API_HOST = "app.chibigeo.com/v1/photon";
      # PHOTON_API_HOST = "photon.komoot.io";
      PHOTON_API_USE_HTTPS = "true";
      STORE_GEODATA = "true";
      REVERSE_GEOCODING_RPS = "0.2";

      OIDC_CLIENT_ID = "dawarich";
      OIDC_ISSUER = config.web.sites.auth.url;
      OIDC_REDIRECT_URI = "${config.web.sites.dawarich.url}/users/auth/openid_connect/callback";
      OIDC_PROVIDER_NAME = "Pocket ID";
      OIDC_AUTO_REGISTER = "true";
      OIDC_PKCE_ENABLED = "true";
      ALLOW_EMAIL_PASSWORD_REGISTRATION = "false";
      ALLOW_EMAIL_PASSWORD_LOGIN = "false";

      PROMETHEUS_EXPORTER_ENABLED = "true";
      METRICS_USERNAME = "";
      METRICS_PASSWORD = "";
      PROMETHEUS_EXPORTER_PORT = toString config.web.ports.metrics_dawarich_sidekiq;
      SIDEKIQ_METRICS_URL = "http://127.0.0.1:${toString config.web.ports.metrics_dawarich_sidekiq}/metrics";
    };
    extraEnvFiles = [
      config.age.secrets."dawarich-oidc-env".path
      config.age.secrets."dawarich-revgeo-env".path
    ];
    database.createLocally = true;
    redis.createLocally = true;
  };

  web.sites.dawarich = {
    name = "timeline";
    aliases = [ "dawarich" ];
    nginxConfig.root = "${cfg.package}/public/";
    locations = {
      "/".nginxConfig.tryFiles = "$uri @proxy";
      "= /metrics" = {
        localhostOnly = true;
        nginxConfig.tryFiles = "$uri @proxy";
      };
      "@proxy" = {
        reverseProxy = config.web.ports.dawarich;
        nginxConfig.proxyWebsockets = true;
      };
    };
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "dawarich";
      scheme = "https";
      static_configs = [
        {
          targets = [
            config.web.sites.dawarich.domain
          ];
          labels.instance = config.networking.hostName;
        }
      ];
      basic_auth = {
        username = "";
        password = "";
      };
    }
  ];

  services.restic.backups.dawarich = {
    initialize = true;
    paths = [ dir ];
    repository = "rclone:proton:/backup/${config.networking.hostName}/dawarich";
    rcloneOptions.protondrive-replace-existing-draft = true;
    passwordFile = config.age.secrets."restic-dawarich".path;
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 75"
    ];
    timerConfig = {
      OnCalendar = "03:15";
      Persistent = true;
    };
  };
}
