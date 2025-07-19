{ writeShellScript, writeText, config }:

writeShellScript "lock-transparent" /* bash */ ''
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
''
