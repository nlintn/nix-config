{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.privatebin;

  dir = "/var/lib/privatebin";
in
{
  fileSystems.${dir} = {
    device = "zp1-chirrp/data/privatebin";
    fsType = "zfs";
  };

  services.privatebin = {
    enable = true;
    dataDir = dir;

    enableNginx = false;
  };

  systemd.services.nginx.serviceConfig.SupplementaryGroups = [ cfg.group ];
  web.sites.privatebin = {
    name = "paste";
    aliases = [ "privatebin" ];
    restrictAccess = {
      auth.enable = true;
      origin.enable = true;
    };
    nginxConfig.root = cfg.package;
    locations =
      let
        fastcgiConf = pkgs.writeText "fastcgi_privatebin" ''
          include ${config.services.nginx.package}/conf/fastcgi_params;
          fastcgi_param SCRIPT_FILENAME $preserved_filename;
          fastcgi_param modHeadersAvailable true; #Avoid sending the security headers twice
          fastcgi_pass unix:${config.services.phpfpm.pools.privatebin.socket};
        '';
      in
      lib.mapAttrs
        (
          _: v:
          {
            authExclude = lib.mkDefault true;
            originExclude = lib.mkDefault true;
          }
          // v
        )
        {
          "/".nginxConfig = {
            tryFiles = "$uri $uri/ /index.php?$query_string";
            index = "index.php";
            extraConfig = ''
              sendfile off;
            '';
          };
          "= /index.php".nginxConfig.extraConfig = ''
            set $preserved_filename $request_filename;
            if ($request_method !~ ^(?:GET|HEAD)$) {
              rewrite ^ /__privatebin-auth last;
            }
            if ($args = "") {
              rewrite ^ /__privatebin-auth last;
            }

            include ${fastcgiConf};
          '';
          "= /__privatebin-auth" = {
            authExclude = false;
            originExclude = false;
            nginxConfig.extraConfig = ''
              internal;
              include ${fastcgiConf};
            '';
          };
        };
    robotsTxt.content = ''
      User-agent: *
      Disallow: /
      User-agent: PrivateBinDirectoryBot
      Disallow: /
    '';
  };

  services.restic.backups.privatebin = {
    initialize = true;
    paths = [ dir ];
    repository = "rclone:proton:/backup/${config.networking.hostName}/privatebin";
    rcloneOptions.protondrive-replace-existing-draft = true;
    passwordFile = config.age.secrets."restic-privatebin".path;
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 75"
    ];
    timerConfig = {
      OnCalendar = "02:15";
      Persistent = true;
    };
  };
}
