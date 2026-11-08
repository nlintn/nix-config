{
  config,
  lib,
  pkgs,
  ...
}:

let
  nextcloudVersion = "35";

  dir = "/media/nextcloud";
in
{
  fileSystems.${dir} = {
    device = "zp1-chirrp/media/nextcloud";
    fsType = "zfs";
  };

  services.nextcloud = {
    enable = true;
    package = pkgs."nextcloud${nextcloudVersion}";
    home = "/var/lib/nextcloud";
    datadir = dir;
    https = true;
    imaginary.enable = true;
    hostName = config.web.sites.nextcloud.domain;
    maxUploadSize = "16G";
    phpOptions = {
      "opcache.enable" = 1;
      "opcache.interned_strings_buffer" = "32";
      "opcache.jit" = 1255;
      "opcache.jit_buffer_size" = "100M";
      memory_limit = lib.mkForce "8G";
    };
    settings = {
      overwriteprotocol = "https";
      trusted_domains = config.web.sites.nextcloud.allDomains;

      hide_login_form = true;
      "auth.webauthn.enabled" = false;

      log_type = "systemd";
      syslog_tag = "nextcloud";

      default_phone_region = "DE";
      "profile.enabled" = true;
      serverid = 0;
      preview_format = "webp";
    };
    config = {
      adminuser = null;
      dbtype = "pgsql";
    };
    database.createLocally = true;
    configureRedis = true;

    appstoreEnable = false;
    extraAppsEnable = true;
    extraApps = {
      inherit (pkgs."nextcloud${nextcloudVersion}Packages".apps)
        calendar
        contacts
        cospend
        tasks
        user_oidc
        ;
    };
  };

  web.sites.nextcloud = {
    name = "cloud";
    aliases = [
      "wolke"
    ];
  };

  services.restic.backups.nextcloud = {
    initialize = true;
    paths = [ dir ];
    repository = "rclone:proton:/backup/${config.networking.hostName}/nextcloud";
    rcloneOptions.protondrive-replace-existing-draft = true;
    passwordFile = config.age.secrets."restic-nextcloud".path;
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 75"
    ];
    timerConfig = {
      OnCalendar = "05:00";
      Persistent = true;
    };
  };
}
