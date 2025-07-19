{ writeShellScript, psmisc, swaybg, libnotify, config, userSettings }:

writeShellScript "hyreload" ''
  if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    echo "no hyprland instance running";
    exit 0;
  fi
  # ${config.systemd.user.systemctlPath} --user reset-failed &&
  # ${config.systemd.user.systemctlPath} --user daemon-reload &&
  ${config.systemd.user.systemctlPath} --user restart waybar.service &&
  ${config.systemd.user.systemctlPath} --user restart swaync.service &&

  ${config.wayland.windowManager.hyprland.package}/bin/hyprctl reload &&
  ${psmisc}/bin/killall swaybg;
  ${swaybg}/bin/swaybg -i ${userSettings.wallpaper} & disown &&
  ${libnotify}/bin/notify-send -u low -e "Reloaded successfully"
''
