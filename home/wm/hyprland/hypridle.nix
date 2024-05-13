{ config, ... }:

{
  services.hypridle = {
    enable = true;

    settings = {
      lock-cmd = "${config.programs.hyprlock.package}/bin/hyprlock";
      unlock-cmd = "pkill -SIGUSR1 hyprlock";
      before-sleep-cmd = "${config.programs.hyprlock.package}/bin/hyprlock";

      listeners = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 600;
          on-timeout = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms off";
          on-resume = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on";
        }
        {
          timeout = 900;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}

