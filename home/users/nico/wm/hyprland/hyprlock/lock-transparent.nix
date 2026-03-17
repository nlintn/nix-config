{
  config,
  lib,
  systemd,
  writeShellScriptBin,
  writeText,
  ...
}:

let
  hyprctl = lib.getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl";
  hyprlock = lib.getExe config.programs.hyprlock.package;
  systemd-inhibit = lib.getExe' systemd "systemd-inhibit";
in
writeShellScriptBin "lock-transparent" /* sh */ ''
  ${hyprctl} keyword misc:session_lock_xray true
  ${systemd-inhibit} --what=idle -- ${hyprlock} -c ${writeText "hyprlock-transparent.conf" ''
    general {
      disable_loading_bar=true
      no_fade_in=true
      no_fade_out=true
      ignore_empty_input=true
      hide_cursor=false
      pam_module="su"
    }
  ''}
  ${hyprctl} keyword misc:session_lock_xray false
''
