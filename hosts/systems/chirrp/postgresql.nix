{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.postgresql;
in
{
  services.postgresql = {
    enable = true;
    settings = {
      shared_buffers = "512MB";
    };
  };

  services.restic.backups.postgresql = {
    initialize = true;
    command = [
      (lib.getExe' pkgs.util-linux "runuser")
      "-u"
      cfg.superUser
      (lib.getExe' cfg.package "pg_dumpall")
    ];
    extraBackupArgs = [
      "--stdin-filename"
      "pg_dumpall"
    ];
    repository = "rclone:proton:/backup/${config.networking.hostName}/postgresql";
    rcloneOptions.protondrive-replace-existing-draft = true;
    passwordFile = config.age.secrets."restic-postgresql".path;
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 75"
    ];
    timerConfig = {
      OnCalendar = "03:00";
      Persistent = true;
    };
  };
}
