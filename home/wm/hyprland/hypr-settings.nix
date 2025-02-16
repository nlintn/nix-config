{ pkgs, lib, config, inputs, userSettings, thunar_pkg }:

let
  evalBinds = mainMod: modifiers: binds: (
    builtins.map (bind: (
      mainMod + (
        if (lib.foldl (acc: mod: acc || (lib.hasPrefix mod bind)) false modifiers) then " " else ", "
      ) + bind)
    ) binds
  );
  grimblast = inputs.hyprland-contrib.packages.${pkgs.system}.grimblast;
in
{
  source = [
    "$HOME/.config/hypr/monitors.conf"
  ];

  env = [
    "QT_QPA_PLATFORM, wayland"
    "XDG_SESSION_DESKTOP, Hyprland"
    "HYPRCURSOR_THEME, ${config.home.pointerCursor.name}"
    "HYPRCURSOR_SIZE, ${toString config.home.pointerCursor.size}"
    "XCURSOR_SIZE, ${toString config.home.pointerCursor.size}"
  ];

  exec-once = [
    "${pkgs.swaybg}/bin/swaybg -i ${userSettings.wallpaper}"
    "${thunar_pkg}/bin/thunar --daemon"

    "[workspace special:pwm silent] ${pkgs.keepassxc}/bin/keepassxc"
  ];

  # "debug:disable_scale_checks" = true;
  # "debug:disable_logs" = false;

  bind =
    # SUPER binds
    evalBinds "SUPER" [ "ALT" "CTRL" "SHIFT" ] [
      # exec keybinds
      "A, exec, ${grimblast}/bin/grimblast --freeze save area - | ${pkgs.swappy}/bin/swappy -f -"
      "SHIFT, A, exec, ${grimblast}/bin/grimblast --freeze save output - | ${pkgs.swappy}/bin/swappy -f -"
      "E, exec, ${thunar_pkg}/bin/thunar"
      "W, exec, ${config.programs.librewolf.package}/bin/librewolf"
      "Q, exec, ${config.programs.kitty.package}/bin/kitty"
      "R, exec, ${config.programs.rofi.package}/bin/rofi -click-to-exit -show drun"
      "SHIFT, R, exec, ${import ./scripts/hyreload.nix { inherit pkgs config userSettings; }}"
      "T, exec, ${config.programs.rofi.package}/bin/rofi -click-to-exit -show ssh"
      "V, exec, ${config.services.copyq.package}/bin/copyq show"
      "BACKSPACE, exec, loginctl lock-session"
      "SHIFT, BACKSPACE, exec, ${import ./scripts/lock-transparent.nix { inherit pkgs config; }}"
      "RETURN, exec, ${config.programs.rofi.package}/bin/rofi -click-to-exit -show power-menu -modi 'power-menu:${import ./scripts/rofi-power-menu.nix { inherit pkgs; }}'"
      # "DEAD_ACUTE, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-panel"
      # "SHIFT, DEAD_ACUTE, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client -C"
      # "CTRL, DEAD_ACUTE, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-dnd"
      "PLUS, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-panel"
      "SHIFT, PLUS, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client -C"
      "CTRL, PLUS, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-dnd"

      "C, killactive"
      "F, fullscreen, 1"
      "SHIFT, F, fullscreen, 0"
      "SHIFT, Z, exec, loginctl terminate-session self"
      "CTRL SHIFT, Z, exit"
      # "P, pseudo,"
      "SPACE, togglefloating,"

      "G, togglegroup,"

      "dead_circumflex, workspace, previous_per_monitor"
      "1, workspace, r~1"
      "2, workspace, r~2"
      "3, workspace, r~3"
      "4, workspace, r~4"
      "5, workspace, r~5"
      "6, workspace, r~6"
      "7, workspace, r~7"
      "8, workspace, r~8"
      "9, workspace, r~9"
      "0, workspace, r~10"

      "SHIFT, 1, movetoworkspacesilent, r~1"
      "SHIFT, 2, movetoworkspacesilent, r~2"
      "SHIFT, 3, movetoworkspacesilent, r~3"
      "SHIFT, 4, movetoworkspacesilent, r~4"
      "SHIFT, 5, movetoworkspacesilent, r~5"
      "SHIFT, 6, movetoworkspacesilent, r~6"
      "SHIFT, 7, movetoworkspacesilent, r~7"
      "SHIFT, 8, movetoworkspacesilent, r~8"
      "SHIFT, 9, movetoworkspacesilent, r~9"
      "SHIFT, 0, movetoworkspacesilent, r~10"

      "S, togglespecialworkspace, magic"
      "SHIFT, S, movetoworkspacesilent, special:magic"

      "P, togglespecialworkspace, pwm"
      "SHIFT, P, movetoworkspacesilent, special:pwm"

      "D,        exec, ${inputs.hyprland-contrib.packages.${pkgs.system}.scratchpad}/bin/scratchpad -n scratchpad"
      "SHIFT, D, exec, ${inputs.hyprland-contrib.packages.${pkgs.system}.scratchpad}/bin/scratchpad -g -l -n scratchpad"
      "CTRL, D,  togglespecialworkspace, scratchpad"

      "K, exec, ${pkgs.callPackage ./scripts/swap-workspace-windows.nix { inherit config; }}/bin/swap-workspace-windows 1 11 10"
    ] ++
    evalBinds "ALT" [] [
      "TAB, exec, ${config.programs.rofi.package}/bin/rofi -click-to-exit -show window"
    ] ++
    evalBinds "CTRL" [ "SHIFT" ] [
      "SHIFT, M, pass, ^vesktop$"
    ];

  bindm =
    evalBinds "SUPER" [ ] [
      "mouse:272, movewindow"
      "mouse:273, resizewindow"
    ];

  binde =
    evalBinds "SUPER" [ "ALT" "CTRL" "SHIFT" ] [
      "left,  movefocus, l"
      "right, movefocus, r"
      "up,    movefocus, u"
      "down,  movefocus, d"
      "SHIFT, left,  movewindow, l"
      "SHIFT, right, movewindow, r"
      "SHIFT, up,    movewindow, u"
      "SHIFT, down,  movewindow, d"
      "h, movefocus, l"
      "l, movefocus, r"
      "k, movefocus, u"
      "j, movefocus, d"
      "SHIFT, h, movewindow, l"
      "SHIFT, l, movewindow, r"
      "SHIFT, k, movewindow, u"
      "SHIFT, j, movewindow, d"

      "ALT, left,  resizeactive, -20 0"
      "ALT, right, resizeactive,  20 0"
      "ALT, up,    resizeactive, 0 -20"
      "ALT, down,  resizeactive, 0  20"
        
      "ALT, h, resizeactive, -20 0"
      "ALT, l, resizeactive,  20 0"
      "ALT, k, resizeactive, 0 -20"
      "ALT, j, resizeactive, 0  20"

      "CTRL, RIGHT, workspace, r+1"
      "CTRL, LEFT,  workspace, r-1"
      "CTRL SHIFT, RIGHT, movetoworkspace, r+1"
      "CTRL SHIFT, LEFT,  movetoworkspace, r-1"

      "CTRL, L, workspace, r+1"
      "CTRL, H, workspace, r-1"
      "CTRL SHIFT, L, movetoworkspace, r+1"
      "CTRL SHIFT, H, movetoworkspace, r-1"

      "TAB, changegroupactive, f"
      "SHIFT, TAB, changegroupactive, b"

      "M, focusmonitor, +1"
      "N, focusmonitor, -1"
      "SHIFT, M, movewindow, mon:+1"
      "SHIFT, N, movewindow, mon:-1"
    ];

  bindl = 
    evalBinds "" [ ] [
      "XF86AudioMute, exec,     ${config.services.avizo.package}/bin/volumectl ${if config.colorScheme.variant == "dark" then "-d" else ""} -p toggle-mute"
      "XF86AudioMicMute, exec,  ${config.services.avizo.package}/bin/volumectl ${if config.colorScheme.variant == "dark" then "-d" else ""} -m -p toogle-mute"
      "XF86AudioNext,   exec, ${config.services.playerctld.package}/bin/playerctl next"
      "XF86AudioPrev,   exec, ${config.services.playerctld.package}/bin/playerctl previous"
      "XF86AudioPlay,   exec, ${config.services.playerctld.package}/bin/playerctl play-pause"
      "XF86AudioPause,  exec, ${config.services.playerctld.package}/bin/playerctl play-pause"
    ];

  bindle =
    evalBinds "" [ ] [
      "XF86AudioRaiseVolume,  exec, ${config.services.avizo.package}/bin/volumectl ${if config.colorScheme.variant == "dark" then "-d" else ""} -p up"
      "XF86AudioLowerVolume,  exec, ${config.services.avizo.package}/bin/volumectl ${if config.colorScheme.variant == "dark" then "-d" else ""} -p down"
      "XF86MonBrightnessUp,   exec, ${config.services.avizo.package}/bin/lightctl ${if config.colorScheme.variant == "dark" then "-d" else ""} up"
      "XF86MonBrightnessDown, exec, ${config.services.avizo.package}/bin/lightctl ${if config.colorScheme.variant == "dark" then "-d" else ""} down"
    ];

  binds = {
    window_direction_monitor_fallback = false;
    workspace_back_and_forth = true;
  };

  input = {
    kb_layout = "de,de";
    kb_variant = ",neo_qwertz";
    kb_options = "grp:alt_space_toggle";
    follow_mouse = 2;

    touchpad = {
      natural_scroll = true;
      tap-to-click = true;
    };

    sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
    # accel_profile = "flat";
    repeat_rate = 30;
    repeat_delay = 400;
  };

  gestures = {
    workspace_swipe = true;
    workspace_swipe_fingers = 3;
    workspace_swipe_forever = true;
    workspace_swipe_use_r = true;
  };

  group = {
    "col.border_active" = "rgba(${config.colorScheme.palette.base0F}66)";
    "col.border_inactive" = "rgba(${config.colorScheme.palette.base04}66)";
    groupbar = {
      text_color = "0xff${config.colorScheme.palette.base05}";
      "col.active" = "0x99${config.colorScheme.palette.base0E}";
      "col.inactive" = "0x55${config.colorScheme.palette.base0E}";
    };
  };

  misc = {
    allow_session_lock_restore = true;
    close_special_on_empty = false;
    disable_hyprland_logo = true;
    disable_splash_rendering = true;
    focus_on_activate = true;
    font_family = userSettings.default-font.name;
    key_press_enables_dpms = true;
    mouse_move_enables_dpms = false;
    new_window_takes_over_fullscreen = 2;

    enable_swallow = true;
    swallow_regex = "^(kitty)$";
    swallow_exception_regex = "^(wev)$";
  };

  windowrulev2 = [
    "suppressevent maximize, class:.*"

    "group new, class:thunderbird, initialTitle:Mozilla Thunderbird"

    "float, class:org.pulseaudio.pavucontrol"
    "float, class:nm-connection-editor"
    "float, class:.blueman-manager-wrapped"

    "float, class:xdg-desktop-portal-gtk"

    "float, class:swayimg"
    "noborder, class:swayimg"
    "noblur, class:swayimg"
    "noshadow, class:swayimg"
    "size 100%, 100%, class:swayimg"
    "center, class:swayimg"

    "float, class:com.github.hluk.copyq"
    "move onscreen cursor, class:com.github.hluk.copyq"
    "pin, class:com.github.hluk.copyq"
    "size 40%, 40%, class:com.github.hluk.copyq"

    "float, class:org.keepassxc.KeePassXC, title:Generate Password"

    "float, class:org.keepassxc.KeePassXC, title:KeePassXC -  Access Request"
    "move onscreen cursor, class:org.keepassxc.KeePassXC, title:KeePassXC -  Access Request"
    "pin, class:org.keepassxc.KeePassXC, title:KeePassXC -  Access Request"

    "float, class:org.keepassxc.KeePassXC, title:KeePassXC - Unlock Database"
    "move onscreen cursor, class:org.keepassxc.KeePassXC, title:KeePassXC - Unlock Database"
    "pin, class:org.keepassxc.KeePassXC, title:KeePassXC - Unlock Database"

    "float, class:steam, title:Steam Settings"
    "float, class:steam, title:Friends List"

    "pin, class:xdragon"

    "bordersize 0, floating:0, onworkspace:w[tv1]"
    "rounding 0, floating:0, onworkspace:w[tv1]"
    "bordersize 0, floating:0, onworkspace:f[1]"
    "rounding 0, floating:0, onworkspace:f[1]"
  ];

  workspace = [
     "1, monitor:eDP-1, persistent:true, default:true"
     "2, monitor:eDP-1, persistent:true"
     "3, monitor:eDP-1, persistent:true"
     "4, monitor:eDP-1, persistent:true"
     "5, monitor:eDP-1, persistent:true"
     "6, monitor:eDP-1, persistent:true"
     "7, monitor:eDP-1, persistent:true"
     "8, monitor:eDP-1, persistent:true"
     "9, monitor:eDP-1, persistent:true"
    "10, monitor:eDP-1, persistent:true"
    # "11, monitor:HDMI-A-1, persistent:true, default:true"
    # "12, monitor:HDMI-A-1, persistent:true"
    # "13, monitor:HDMI-A-1, persistent:true"
    # "14, monitor:HDMI-A-1, persistent:true"
    # "15, monitor:HDMI-A-1, persistent:true"
    # "16, monitor:HDMI-A-1, persistent:true"
    # "17, monitor:HDMI-A-1, persistent:true"
    # "18, monitor:HDMI-A-1, persistent:true"
    # "19, monitor:HDMI-A-1, persistent:true"
    # "20, monitor:HDMI-A-1, persistent:true"

    "w[tv1], gapsout:0, gapsin:0"
    "f[1], gapsout:0, gapsin:0"
  ];

  layerrule = [
    "noanim, selection"
  ];

  general = {
    gaps_in = 0;
    gaps_out = 0;
    border_size = 1;
    "col.active_border" = "rgba(${config.colorScheme.palette.base0F}66)";
    "col.inactive_border" = "rgba(${config.colorScheme.palette.base04}66)";

    layout = "master";
    allow_tearing = false;

    snap.enabled = true;
  };

  decoration = {
    rounding = 0;

    blur = {
      enabled = true;
      size = 4;
      passes = 2;

      vibrancy = 0.1696;
    };
  };

  animations.enabled = false;

  master = {
    new_status = "slave";
    new_on_top = true;
    mfact = 0.65;
  };

  xwayland.force_zero_scaling = true;

  ecosystem = {
    no_update_news = true;
    no_donation_nag = true;
  };
}
