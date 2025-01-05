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
    "${pkgs.swaybg}/bin/swaybg -i ${builtins.path { name = "swaybg-img"; path = userSettings.wallpaper; }}"
    "${thunar_pkg}/bin/thunar --daemon"

    "[workspace special:pwm silent] ${pkgs.keepassxc}/bin/keepassxc"
    "[workspace special:pwm silent] ${config.programs.kitty.package}/bin/kitty ~/PWM"
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
      "SHIFT, M, exit,"
      # "P, pseudo,"
      "SPACE, togglefloating,"

      "G, togglegroup,"

      "dead_circumflex, workspace, previous_per_monitor"
      "1, split-workspace, 1"
      "2, split-workspace, 2"
      "3, split-workspace, 3"
      "4, split-workspace, 4"
      "5, split-workspace, 5"
      "6, split-workspace, 6"
      "7, split-workspace, 7"
      "8, split-workspace, 8"
      "9, split-workspace, 9"
      "0, split-workspace, 10"

      "SHIFT, 1, split-movetoworkspacesilent, 1"
      "SHIFT, 2, split-movetoworkspacesilent, 2"
      "SHIFT, 3, split-movetoworkspacesilent, 3"
      "SHIFT, 4, split-movetoworkspacesilent, 4"
      "SHIFT, 5, split-movetoworkspacesilent, 5"
      "SHIFT, 6, split-movetoworkspacesilent, 6"
      "SHIFT, 7, split-movetoworkspacesilent, 7"
      "SHIFT, 8, split-movetoworkspacesilent, 8"
      "SHIFT, 9, split-movetoworkspacesilent, 9"
      "SHIFT, 0, split-movetoworkspacesilent, 10"

      "S, togglespecialworkspace, magic"
      "SHIFT, S, movetoworkspacesilent, special:magic"

      "P, togglespecialworkspace, pwm"
      "SHIFT, P, movetoworkspacesilent, special:pwm"

      "D,        exec, ${inputs.hyprland-contrib.packages.${pkgs.system}.scratchpad}/bin/scratchpad -n scratchpad"
      "SHIFT, D, exec, ${inputs.hyprland-contrib.packages.${pkgs.system}.scratchpad}/bin/scratchpad -g -l -n scratchpad"
      "CTRL, D,  togglespecialworkspace, scratchpad"
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

      "CTRL, RIGHT, split-workspace, r+1"
      "CTRL, LEFT,  split-workspace, r-1"
      "CTRL SHIFT, RIGHT, split-movetoworkspace, r+1"
      "CTRL SHIFT, LEFT,  split-movetoworkspace, r-1"

      "CTRL, L, split-workspace, r+1"
      "CTRL, H, split-workspace, r-1"
      "CTRL SHIFT, L, split-movetoworkspace, r+1"
      "CTRL SHIFT, H, split-movetoworkspace, r-1"

      "TAB, changegroupactive, f"
      "SHIFT, TAB, changegroupactive, b"
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

  plugin.split-monitor-workspaces = {
    count = 10;
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
    close_special_on_empty = false;
    focus_on_activate = true;
    mouse_move_enables_dpms = false;
    key_press_enables_dpms = true;
    disable_hyprland_logo = true;
    disable_splash_rendering = true;
  };

  windowrulev2 = [
    "suppressevent maximize, class:.*"

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

    "float, class:copyq"
    "move onscreen cursor, class:copyq"
    "pin, class:copyq"
    "size 40%, 40%, class:copyq"

    "float, class:org.keepassxc.KeePassXC, title:Generate Password"

    "float, class:steam, title:Steam Settings"
    "float, class:steam, title:Friends List"

    "pin, class:xdragon"

    "bordersize 0, floating:0, onworkspace:w[tv1]"
    "rounding 0, floating:0, onworkspace:w[tv1]"
    "bordersize 0, floating:0, onworkspace:f[1]"
    "rounding 0, floating:0, onworkspace:f[1]"
  ];

  workspace = [
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
}
