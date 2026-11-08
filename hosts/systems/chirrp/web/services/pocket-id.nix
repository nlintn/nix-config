{
  config,
  lib,
  ...
}:

let
  cfg = config.services.pocket-id;
in
{
  web.uds.pocket-id = { };
  web.ports = {
    metrics_pocket-id = null;
  };
  services.pocket-id = {
    enable = true;
    settings = {
      UI_CONFIG_DISABLED = true;

      SESSION_DURATION = 60 * 24 |> toString;
      ANALYTICS_DISABLED = true;
      APP_URL = config.web.sites.auth.url;
      # TRUST_PROXY = "127.0.0.1";
      TRUST_PROXY = true;
      VERSION_CHECK_DISABLED = true;

      UNIX_SOCKET = config.web.uds.pocket-id.path;
      UNIX_SOCKET_MODE = "0770";

      METRICS_ENABLED = true;
      OTEL_METRICS_EXPORTER = "prometheus";
      OTEL_EXPORTER_PROMETHEUS_HOST = "127.0.0.1";
      OTEL_EXPORTER_PROMETHEUS_PORT = config.web.ports.metrics_pocket-id;

      # Overriding the UI configuration
      EMAILS_VERIFIED = true;
      ALLOW_OWN_ACCOUNT_EDIT = false;
      ALLOW_USER_SIGNUPS = "withToken";
      DISABLE_ANIMATIONS = true;
    };
    environmentFile = config.age.secrets."pocketid-env".path;
  };

  web.sites.auth = {
    reverseProxy = config.web.uds.pocket-id.path;
    locations = {
      "~ ^.*/setup$".localhostOnly = true;
    };
    nginxConfig.extraConfig = ''
      proxy_busy_buffers_size 512k;
      proxy_buffers 4 512k;
      proxy_buffer_size 256k;
    '';
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "pocket-id";
      static_configs = [
        {
          targets = [
            "127.0.0.1:${toString cfg.settings.OTEL_EXPORTER_PROMETHEUS_PORT}"
          ];
          labels.instance = config.networking.hostName;
        }
      ];
    }
  ];

  services.restic.backups.pocket-id = {
    initialize = true;
    command = [
      (lib.getExe' config.systemd.package "systemd-run")
      "-P"
      "--uid"
      cfg.user
      "--gid"
      cfg.group
      "--working-directory"
      cfg.dataDir
      "-p"
      "EnvironmentFile=${cfg.environmentFile}"
      "--"
      (lib.getExe cfg.package)
      "export"
      "--path"
      "-"
    ];
    extraBackupArgs = [
      "--stdin-filename"
      "pocket-id_export"
    ];
    repository = "rclone:proton:/backup/${config.networking.hostName}/pocket-id";
    rcloneOptions.protondrive-replace-existing-draft = true;
    passwordFile = config.age.secrets."restic-pocketid".path;
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 75"
    ];
    timerConfig = {
      OnCalendar = "02:30";
      Persistent = true;
    };
  };
}
