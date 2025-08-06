{ config, writeShellScript, writeText, ... }:

writeShellScript "lock-transparent" /* sh */ ''
  ${config.wayland.windowManager.hyprland.finalPackage}/bin/hyprctl keyword misc:session_lock_xray true
  systemd-inhibit --what=idle ${config.programs.hyprlock.package}/bin/hyprlock -c ${
    writeText "hyprlock-transp.conf" ''
      general {
        disable_loading_bar=true
        no_fade_in=true
        no_fade_out=true
        ignore_empty_input=true
        hide_cursor=false
        pam_module="su"
      }
    ''
  }
  ${config.wayland.windowManager.hyprland.finalPackage}/bin/hyprctl keyword misc:session_lock_xray false
''
