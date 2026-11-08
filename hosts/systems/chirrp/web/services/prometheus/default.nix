{
  config,
  ...
}:

{
  imports = [
    ./exporters.nix
  ];

  web.ports.prometheus = 9090;

  services.prometheus = {
    enable = true;
    port = config.web.ports.prometheus;
    listenAddress = "127.0.0.1";
    webExternalUrl = config.web.sites.prometheus.url;
  };

  web.sites.prometheus = {
    reverseProxy = config.web.ports.prometheus;
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
    };
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "prometheus";
      scheme = "https";
      static_configs = [
        {
          targets = [
            config.web.sites.prometheus.domain
          ];
          labels.instance = config.networking.hostName;
        }
      ];
    }
  ];
}
