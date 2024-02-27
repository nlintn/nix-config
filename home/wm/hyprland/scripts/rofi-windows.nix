{ pkgs, ... }:

pkgs.writeShellScript "rofi-windows" ''
  hyprctl clients \
  | awk '/title: ./ { gsub("\t*title: *", ""); print}' \
  | ${pkgs.rofi-wayland}/bin/rofi -dmenu \
  | xargs -I{} hyprctl dispatch focuswindow "title:{}"
''
