{
  config,
  lib,
  osConfig ? null,
  ...
}:

{
  services.restic = {
    enable = true;
    backups.home = {
      initialize = true;
      dynamicFilesFrom = ''
        find ${lib.escapeShellArg config.home.homeDirectory} -mindepth 1 -maxdepth 1 ! -name '.*'
      '';
      extraBackupArgs = [ "--one-file-system" ];
      repository = "rclone:wolke:/.backup/${
        osConfig.networking.hostName or "hm"
      }-${config.home.username}/home";
      passwordFile = config.age.secrets."restic-home".path;
      pruneOpts = [
        "--keep-hourly 24"
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
        "--keep-yearly 75"
      ];
      timerConfig = {
        OnCalendar = "*-*-* 00/6:00:00";
        Persistent = true;
      };
    };
  };
}
