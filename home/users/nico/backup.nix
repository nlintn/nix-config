{ config, lib, ... }:

{
  systemd.user.services."backup-rclone-sync" = {
    Service.ExecStart = ''
      ${lib.getExe config.programs.rclone.package} sync "${config.xdg.userDirs.documents}" protondrive:backup/sync
    '';
  };

  systemd.user.timers."backup-rclone-sync" = {
    Timer = {
      Unit = "backup-rclone-sync.service";
      OnCalendar = "daily";
    };
  };
}
