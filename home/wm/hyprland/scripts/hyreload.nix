{ pkgs, config, userSettings }:

pkgs.writeShellScript "hyreload" ''
  if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    echo "no hyprland instance running";
    exit 0;
  fi
  ${config.wayland.windowManager.hyprland.package}/bin/hyprctl reload &&
  ${pkgs.procps}/bin/pkill -SIGUSR2 waybar &&
  ${pkgs.swaynotificationcenter}/bin/swaync-client -R &&
  ${pkgs.swaynotificationcenter}/bin/swaync-client -rs &&
  ${pkgs.psmisc}/bin/killall swaybg;
  ${pkgs.swaybg}/bin/swaybg -i ${userSettings.wallpaper} & disown &&
  ${pkgs.libnotify}/bin/notify-send -u low -e "Reloaded successfully"
''
