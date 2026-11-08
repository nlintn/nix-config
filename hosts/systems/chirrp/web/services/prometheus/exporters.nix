{
  config,
  lib,
  ...
}:

let
  listenAddress = "127.0.0.1";

  exporters = {
    nginx = {
      enable = true;
      port = config.web.ports.metrics_nginx;
      inherit listenAddress;
    };

    node = {
      enable = true;
      port = config.web.ports.metrics_node;
      enabledCollectors = [
        "systemd"
      ];
      inherit listenAddress;
    };

    systemd = {
      enable = true;
      port = config.web.ports.metrics_systemd;
      inherit listenAddress;
    };

    zfs = {
      enable = true;
      port = config.web.ports.metrics_zfs;
      inherit listenAddress;
    };
  };
in
{
  web.ports = {
    metrics_nginx = null;
    metrics_node = null;
    metrics_systemd = null;
    metrics_zfs = null;
  };

  services.prometheus = {
    inherit exporters;
  };

  services.prometheus.scrapeConfigs =
    exporters
    |> lib.mapAttrsToList (
      n: v: {
        job_name = n;
        static_configs = [
          {
            targets =
              let
                inherit (v) listenAddress port;
              in
              [
                "${listenAddress}:${toString port}"
              ];
            labels.instance = config.networking.hostName;
          }
        ];
      }
    );
}
