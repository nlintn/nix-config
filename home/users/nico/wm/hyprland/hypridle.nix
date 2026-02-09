{
  config,
  lib,
  pkgs,
  ...
}:

{
  vars = {
    sessionLockCmd = "${config.systemd.user.loginctlPath} lock-session || ${config.vars.lockCmd}";
    sessionUnlockCmd = "${config.systemd.user.loginctlPath} unlock-session || ${config.vars.unlockCmd}";
  };
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = config.vars.lockCmd;
        unlock_cmd = config.vars.unlockCmd;
        before_sleep_cmd = config.vars.sessionLockCmd;
        ignore_dbus_inhibit = false;
        ignore_systemd_inhibit = false;
        inhibit_sleep = 3;
      };
      listener = [
        {
          timeout = 180;
          on-timeout = "${lib.getExe pkgs.brightnessctl} -s set 75%-";
          on-resume = "${lib.getExe pkgs.brightnessctl} -r";
        }
        {
          timeout = 190;
          on-timeout = config.vars.sessionLockCmd;
        }
        {
          timeout = 250;
          on-timeout = "${lib.getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl"} dispatch dpms off";
          on-resume = "${lib.getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl"} dispatch dpms on";
        }
        {
          timeout = 600;
          on-timeout = "${config.systemd.user.systemctlPath} suspend";
        }
      ];
    };
  };
}
