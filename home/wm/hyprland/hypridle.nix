{ config, inputs, ... }:

{
  imports = [
    inputs.hypridle.homeManagerModules.hypridle
  ];

  services.hypridle = {
    enable = true;

    lockCmd = "${config.programs.hyprlock.package}/bin/hyprlock";
    unlockCmd = "pkill -SIGUSR1 hyprlock";
    beforeSleepCmd = "${config.programs.hyprlock.package}/bin/hyprlock";

    listeners = [
      {
        timeout = 300;
        onTimeout = "loginctl lock-session";
      }
      {
        timeout = 600;
        onTimeout = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms off";
        onResume = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on";
      }
      {
        timeout = 900;
        onTimeout = "systemctl suspend";
      }
    ];
  };
}

