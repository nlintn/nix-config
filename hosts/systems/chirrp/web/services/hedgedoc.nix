{
  config,
  ...
}:

let
  dir = "/var/lib/hedgedoc";
in
{
  fileSystems.${dir} = {
    device = "zp1-chirrp/data/hedgedoc";
    fsType = "zfs";
  };

  web.uds.hedgedoc = { };

  services.hedgedoc = {
    enable = true;
    environmentFile = config.age.secrets."hedgedoc-env".path;
    settings = {
      domain = config.web.sites.hedgedoc.domain;
      path = config.web.uds.hedgedoc.path;
      protocolUseSSL = true;
      useSSL = false;

      allowAnonymous = false;
      allowAnonymousEdits = true;

      email = false;
      oauth2 =
        let
          inherit (config.web.sites.auth) url;
        in
        {
          baseURL = url;
          userProfileURL = "${url}/api/oidc/userinfo";
          userProfileUsernameAttr = "preferred_username";
          userProfileDisplayNameAttr = "name";
          userProfileEmailAttr = "email";
          tokenURL = "${url}/api/oidc/token";
          authorizationURL = "${url}/authorize";
          clientID = "hedgedoc";
          providerName = "PocketID";
          scope = "openid profile email";
          pkce = true;
        };
    };
  };

  web.sites.hedgedoc = {
    reverseProxy = config.web.uds.hedgedoc.path;
    locations = {
      "/socket.io/".nginxConfig.proxyWebsockets = true;
      "= /metrics".localhostOnly = true;
      "= /status".localhostOnly = true;
    };
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "hedgedoc";
      scheme = "https";
      static_configs = [
        {
          targets = [ config.web.sites.hedgedoc.domain ];
          labels.instance = config.networking.hostName;
        }
      ];
    }
  ];

  services.restic.backups.hedgedoc = {
    initialize = true;
    paths = [ dir ];
    repository = "rclone:proton:/backup/${config.networking.hostName}/hedgedoc";
    rcloneOptions.protondrive-replace-existing-draft = true;
    passwordFile = config.age.secrets."restic-hedgedoc".path;
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 75"
    ];
    timerConfig = {
      OnCalendar = "02:00";
      Persistent = true;
    };
  };
}
