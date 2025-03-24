{ pkgs, config, userSettings }:

pkgs.writeShellScript "hyreload" ''
  if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    echo "no hyprland instance running";
    exit 0;
  fi
  ${pkgs.systemd}/bin/systemctl --user reset-failed &&
  ${pkgs.systemd}/bin/systemctl --user daemon-reload &&
  ${pkgs.systemd}/bin/systemctl --user restart waybar.service &&
  ${pkgs.systemd}/bin/systemctl --user restart swaync.service &&

  ${config.wayland.windowManager.hyprland.package}/bin/hyprctl reload &&
  ${pkgs.psmisc}/bin/killall swaybg;
  ${pkgs.swaybg}/bin/swaybg -i ${userSettings.wallpaper} & disown &&
  ${pkgs.libnotify}/bin/notify-send -u low -e "Reloaded successfully"
''
