{
  config,
  lib,
  ...
}:

let
  cfg = config.services.jellyfin;
in
{
  web.ports.jellyfin = 8096;

  services.jellyfin = {
    enable = true;
  };
  systemd.services.jellyfin.serviceConfig = {
    SupplementaryGroups = [ config.vars.shareGroup ];
    UMask = lib.mkForce "0007";
  };

  services.jellyfin.hardwareAcceleration = {
    enable = true;
    type = "qsv";
    device = "/dev/dri/renderD128";
  };
  systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME =
    config.environment.sessionVariables.LIBVA_DRIVER_NAME;
  users.users.${cfg.user}.extraGroups = [
    "video"
    "render"
  ];

  web.sites.jellyfin = {
    reverseProxy = config.web.ports.jellyfin;
    locations = {
      "/".nginxConfig.extraConfig = ''
        client_max_body_size 20M;
        proxy_buffering off;
      '';
      "= /metrics".localhostOnly = true;
      "= /socket".nginxConfig.proxyWebsockets = true;
    };
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "jellyfin";
      static_configs = [
        {
          targets = [ "127.0.0.1:${toString config.web.ports.jellyfin}" ];
          labels.instance = config.networking.hostName;
        }
      ];
    }
  ];
}
