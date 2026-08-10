{
  config,
  lib,
  systemd,
  writeShellScriptBin,
  emptyFile,
  ...
}:

let
  hyprctl = lib.getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl";
  swaylock = lib.getExe config.programs.swaylock.package;
  systemd-inhibit = lib.getExe' systemd "systemd-inhibit";
in
writeShellScriptBin "lock-transparent" /* sh */ ''
  ${hyprctl} keyword misc:session_lock_xray true
  ${systemd-inhibit} --what=idle -- ${swaylock} -C ${emptyFile} -c 00000000 -u
  ${hyprctl} keyword misc:session_lock_xray false
''
