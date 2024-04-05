{ pkgs, config }:

pkgs.writeShellScript "hyreload" ''
  ${config.wayland.windowManager.hyprland.package}/bin/hyprctl reload;
  ${pkgs.procps}/bin/pkill -SIGUSR2 waybar;
  ${pkgs.swaynotificationcenter}/bin/swaync-client -R;
  ${pkgs.swaynotificationcenter}/bin/swaync-client -rs
''
