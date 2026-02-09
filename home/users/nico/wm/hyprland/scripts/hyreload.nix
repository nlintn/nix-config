{
  config,
  lib,
  libnotify,
  writeShellScript,
  ...
}:

writeShellScript "hyreload" (
  let
    systemctl = config.systemd.user.systemctlPath;
  in
  /* sh */ ''
    set -ex

    if [ -z $HYPRLAND_INSTANCE_SIGNATURE ]; then
      echo "no active Hyprland instance"
    else
      ${lib.optionalString config.services.avizo.enable "${systemctl} --user restart avizo.service"}
      ${lib.optionalString config.services.hypridle.enable "${systemctl} --user restart hypridle.service"}
      ${lib.optionalString config.programs.swaybg.enable "${systemctl} --user restart swaybg.service"}
      ${lib.optionalString config.services.swaync.enable "${systemctl} --user restart swaync.service"}
      ${lib.optionalString config.programs.waybar.enable "${systemctl} --user restart waybar.service"}

      ${lib.getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl"} reload

      ${lib.getExe libnotify} -u low -e "reloaded successfully"
    fi
  ''
)
