{ config, ... }:

{
  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${config.programs.swaylock.package}/bin/swaylock -f"; }
      # { event = "after-resume"; command = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on"; }
    ];
    timeouts = [
      { timeout = 150; command = "${config.programs.swaylock.package}/bin/swaylock -f --grace 3"; }
      { timeout = 300; command = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms off"; }
      { timeout = 600; command = "systemctl suspend"; }
    ];
  };
}
