{
  config,
  pkgs-unstable,
  ...
}:

let
  cfg = config.services.immich;

  dir = "/media/immich";
in
{
  fileSystems.${dir} = {
    device = "zp1-chirrp/media/immich";
    fsType = "zfs";
  };

  web.ports = {
    immich = null;

    metrics_immich-api = null;
    metrics_immich-microservices = null;
  };

  services.immich = {
    enable = true;
    package = pkgs-unstable.immich; # TODO: switch back to pkgs-stable
    host = "127.0.0.1";
    port = config.web.ports.immich;
    mediaLocation = dir;
    environment = {
      IMMICH_TRUSTED_PROXIES = "127.0.0.1";
      IMMICH_ALLOW_SETUP = "false";
      IMMICH_TELEMETRY_INCLUDE = "all";
      IMMICH_API_METRICS_PORT = toString config.web.ports.metrics_immich-api;
      IMMICH_MICROSERVICES_METRICS_PORT = toString config.web.ports.metrics_immich-microservices;
    };
    settings = {
      oauth = {
        enabled = true;
        autoLaunch = true;
        buttonText = "Login with PocketID";
        clientId = "immich";
        clientSecret._secret = config.age.secrets."immich-client_secret".path;
        issuerUrl = "${config.web.sites.auth.url}/.well-known/openid-configuration";
        profileSigningAlgorithm = "RS256";
        roleClaim = "immich_role";
        signingAlgorithm = "RS256";
        defaultStorageQuota = null;
        storageQuotaClaim = "immich_quota";
      };
      newVersionCheck.enabled = false;
      passwordLogin.enabled = false;
      server.externalDomain = config.web.sites.immich.url;
    };
    database = {
      enable = true;
      createDB = true;
    };
    redis.enable = true;
    machine-learning = {
      enable = true;
      environment = {
        ORT_DISABLE_TELEMETRY = "1";
      };
    };
  };

  services.immich.accelerationDevices = [ "/dev/dri/renderD128" ];
  systemd.services."immich-server".environment.LIBVA_DRIVER_NAME =
    config.environment.sessionVariables.LIBVA_DRIVER_NAME;
  users.users.${cfg.user}.extraGroups = [
    "video"
    "render"
  ];

  web.sites.immich = {
    name = "photos";
    aliases = [ "immich" ];
    reverseProxy = config.web.ports.immich;
    locations = {
      "/".nginxConfig.proxyWebsockets = true;
      "/.well-known/immich" = { };
    };
    robotsTxt.enable = false;
    nginxConfig.extraConfig = ''
      # allow large file uploads
      client_max_body_size 50000M;

      # disable buffering uploads to prevent OOM on reverse proxy server and make uploads twice as fast (no pause)
      proxy_request_buffering off;

      # increase body buffer to avoid limiting upload speed
      client_body_buffer_size 1024k;

      proxy_read_timeout 600s;
      proxy_send_timeout 600s;
      send_timeout       600s;
    '';
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "immich";
      static_configs = [
        {
          targets = [
            "127.0.0.1:${cfg.environment.IMMICH_API_METRICS_PORT}"
            "127.0.0.1:${cfg.environment.IMMICH_MICROSERVICES_METRICS_PORT}"
          ];
          labels.instance = config.networking.hostName;
        }
      ];
    }
  ];

  services.restic.backups.immich = {
    initialize = true;
    paths = [ dir ];
    repository = "rclone:proton:/backup/${config.networking.hostName}/immich";
    rcloneOptions.protondrive-replace-existing-draft = true;
    passwordFile = config.age.secrets."restic-immich".path;
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 75"
    ];
    timerConfig = {
      OnCalendar = "04:30";
      Persistent = true;
    };
  };
}
