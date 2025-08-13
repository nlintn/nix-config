{ config, pkgs, ... }:

{
  home.sessionVariables = {
    SESSION_LOCK_CMD = "${config.systemd.user.loginctlPath} lock-session || ${config.home.sessionVariables.__LOCK_CMD}";
    SESSION_UNLOCK_CMD = "${config.systemd.user.loginctlPath} unlock-session || ${config.home.sessionVariables.__UNLOCK_CMD}";
  };
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = config.home.sessionVariables.__LOCK_CMD;
        unlock_cmd = config.home.sessionVariables.__UNLOCK_CMD;
        before_sleep_cmd = config.home.sessionVariables.SESSION_LOCK_CMD;
        ignore_dbus_inhibit = false;
        ignore_systemd_inhibit = false;
        inhibit_sleep = 3;
      };
      listener = [
        {
          timeout = 180;
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 75%-";
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
        }
        {
          timeout = 190;
          on-timeout = config.home.sessionVariables.SESSION_LOCK_CMD;
        }
        {
          timeout = 250;
          on-timeout = "${config.wayland.windowManager.hyprland.finalPackage}/bin/hyprctl dispatch dpms off";
          on-resume = "${config.wayland.windowManager.hyprland.finalPackage}/bin/hyprctl dispatch dpms on";
        }
        {
          timeout = 600;
          on-timeout = "${config.systemd.user.systemctlPath} suspend";
        }
      ];
    };
  };
}

