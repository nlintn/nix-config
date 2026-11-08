{
  config,
  lib,
  pkgs-unstable,
  ...
}:

let
  cfg = config.services.paperless;

  mediaDir = "/media/paperless";
  backupDir = "/var/backup/paperless";
in
{
  disabledModules = [ "services/misc/paperless.nix" ]; # TODO: remove after 26.11
  imports = [
    "${pkgs-unstable.path}/nixos/modules/services/misc/paperless.nix"
  ];

  fileSystems.${mediaDir} = {
    device = "zp1-chirrp/media/paperless";
    fsType = "zfs";
  };

  web.uds.paperless = {
    serviceName = "paperless-web";
  };

  services.paperless = {
    enable = true;
    package = pkgs-unstable.paperless-ngx;
    configureTika = true;
    database.createLocally = true;
    passwordFile = config.age.secrets.paperless-admin_pass.path;
    settings =
      let
        urls = lib.concatStringsSep "," config.web.sites.paperless.allUrls;
      in
      {
        PAPERLESS_URL = config.web.sites.paperless.url;
        PAPERLESS_CSRF_TRUSTED_ORIGINS = urls;
        PAPERLESS_ALLOWED_HOSTS = urls;
        PAPERLESS_CORS_ALLOWED_HOSTS = urls;
        PAPERLESS_TRUSTED_PROXIES = "127.0.0.1";

        GRANIAN_UDS = config.web.uds.paperless.path;
        GRANIAN_UDS_PERMISSIONS = "0770";

        PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect";
        PAPERLESS_ACCOUNT_ALLOW_SIGNUPS = false;
        PAPERLESS_SOCIAL_AUTO_SIGNUP = true;
        PAPERLESS_SOCIAL_ACCOUNT_SYNC_GROUPS = true;
        PAPERLESS_SOCIAL_ACCOUNT_SYNC_GROUPS_CLAIM = "groups";
        PAPERLESS_SOCIAL_ACCOUNT_SYNC_SUPERUSER_GROUP = "admin";
        PAPERLESS_DISABLE_REGULAR_LOGIN = true;
        PAPERLESS_REDIRECT_LOGIN_TO_SSO = true;

        PAPERLESS_OCR_LANGUAGE = "deu+eng";
        PAPERLESS_OCR_DESKEW = true;
        PAPERLESS_OCR_ROTATE_PAGES = true;
        PAPERLESS_OCR_USER_ARGS = {
          optimize = 1;
        };

        PAPERLESS_DATE_PARSER_LANGUAGES = "de+en";
        PAPERLESS_CONSUMER_DISABLE = true;
      };
    environmentFile = config.age.secrets."paperless-env".path;
  };
  systemd.services.paperless-web.environment = {
    GRANIAN_HOST = lib.mkForce null;
    GRANIAN_PORT = lib.mkForce null;
  };

  web.sites.paperless = {
    aliases = [ "paperless-ngx" ];
    reverseProxy = config.web.uds.paperless.path;
    locations = {
      "/static/" = {
        reverseProxy = null;
        nginxConfig = {
          root = cfg.package;
          extraConfig = ''
            rewrite ^/(.*)$ /lib/paperless-ngx/$1 break;
          '';
        };
      };
      "/ws/status".nginxConfig.proxyWebsockets = true;
    };
  };

  fileSystems.${backupDir} = {
    device = "zp1-chirrp/backup/paperless";
    fsType = "zfs";
  };

  services.paperless.exporter = {
    enable = true;
    directory = backupDir;
    onCalendar = "04:00";
  };

  services.restic.backups.paperless = {
    initialize = true;
    paths = [ backupDir ];
    repository = "rclone:proton:/backup/${config.networking.hostName}/paperless";
    rcloneOptions.protondrive-replace-existing-draft = true;
    passwordFile = config.age.secrets."restic-paperless".path;
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 75"
    ];
    timerConfig = null;
  };
  systemd.services.paperless-exporter.onSuccess = [ "restic-backups-paperless.service" ];
}
