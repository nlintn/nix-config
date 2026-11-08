{
  config,
  lib,
  ...
}:

let
  cfg = config.services.filebrowser;
in
{
  web.ports.filebrowser = null;

  services.filebrowser = {
    enable = true;
    settings = {
      address = "127.0.0.1";
      port = config.web.ports.filebrowser;
      root = config.vars.shareDir;
      "auth.method" = "proxy";
    };
  };
  systemd.services.filebrowser.serviceConfig = {
    UMask = lib.mkForce "0007";
    SupplementaryGroups = [ config.vars.shareGroup ];
  };

  users.users.${cfg.user}.uid = 991;

  web.sites.browse = {
    reverseProxy = config.web.ports.filebrowser;
    restrictAccess = {
      satisfy = "all";
      auth = {
        enable = true;
        config.allowed_groups = [ "admin" ];
      };
      origin.enable = true;
    };
  };
}
