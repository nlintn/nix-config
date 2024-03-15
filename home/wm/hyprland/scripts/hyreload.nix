{ pkgs }:

pkgs.writeShellScript "hyreload" ''
  kill $(pidof waybar);
  ${pkgs.waybar}/bin/waybar & disown;
  hyprctl reload;
''
