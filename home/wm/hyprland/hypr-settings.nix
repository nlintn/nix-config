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

  "$terminal" = "${config.programs.alacritty.package}/bin/alacritty";
  "$fileManager" = "${thunar_pkg}/bin/thunar";

  env = [
    "XDG_SESSION_DESKTOP, Hyprland"
    "XCURSOR_SIZE, 20"
  ];

  exec-once = [
    "${pkgs.swaynotificationcenter}/bin/swaync"
    "${config.programs.waybar.package}/bin/waybar"
    "${pkgs.networkmanagerapplet}/bin/nm-applet"
    "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    "${pkgs.swaybg}/bin/swaybg -i ${builtins.path { name = "swaybg-img"; path = userSettings.wallpaper; }}"
    "sleep 5; ${pkgs.copyq}/bin/copyq --start-server"
  ];

  # "debug:disable_scale_checks" = true;
  # "debug:disable_logs" = false;

  /* workspace = [
    "1, persistent:true" 
    "2, persistent:true" 
    "3, persistent:true" 
    "4, persistent:true" 
    "5, persistent:true" 
    "6, persistent:true" 
    "7, persistent:true" 
    "8, persistent:true" 
    "9, persistent:true" 
    "10, persistent:true" 
  ]; */

  bind =
    # SUPER binds
    evalBinds "SUPER" [ "CTRL" "SHIFT" "ALT" ] [
      # exec keybinds
      "A, exec, ${grimblast}/bin/grimblast --freeze save area - | ${pkgs.swappy}/bin/swappy -f -"
      "SHIFT, A, exec, ${grimblast}/bin/grimblast --freeze save output - | ${pkgs.swappy}/bin/swappy -f -"
      "E, exec, $fileManager"
      "Q, exec, $terminal"
      "R, exec, ${config.programs.rofi.package}/bin/rofi -click-to-exit -hover-select -show drun"
      "SHIFT, R, exec, ${import ./scripts/hyreload.nix { inherit pkgs config userSettings; }}"
      "T, exec, ${config.programs.rofi.package}/bin/rofi -click-to-exit -hover-select -show ssh"
      "V, exec, ${pkgs.copyq}/bin/copyq show"
      "BACKSPACE, exec, loginctl lock-session"
      "TAB, exec, ${config.programs.rofi.package}/bin/rofi -click-to-exit -hover-select -show window"

      "C, killactive"
      "F, fullscreen, 1"
      "SHIFT, F, fullscreen, 0"
      "G, togglesplit,"
      "SHIFT, M, exit,"
      "P, pseudo,"
      "SPACE, togglefloating,"

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

      "1, split-workspace, 1"
      "2, split-workspace, 2"
      "3, split-workspace, 3"
      "4, split-workspace, 4"
      "5, split-workspace, 5"

      "SHIFT, 1, split-movetoworkspace, 1"
      "SHIFT, 2, split-movetoworkspace, 2"
      "SHIFT, 3, split-movetoworkspace, 3"
      "SHIFT, 4, split-movetoworkspace, 4"
      "SHIFT, 5, split-movetoworkspace, 5"

      "S, togglespecialworkspace, magic"
      "SHIFT, S, movetoworkspace, special:magic"

      "D,        exec, ${inputs.hyprland-contrib.packages.${pkgs.system}.scratchpad}/bin/scratchpad"
      "SHIFT, D, exec, ${inputs.hyprland-contrib.packages.${pkgs.system}.scratchpad}/bin/scratchpad -g -l"
      "CTRL, D, exec, ${inputs.hyprland-contrib.packages.${pkgs.system}.scratchpad}/bin/scratchpad -t"

      "CTRL, RIGHT, split-workspace, w+1"
      "CTRL, LEFT,  split-workspace, w-1"
      "CTRL SHIFT, RIGHT, split-movetoworkspace, w+1"
      "CTRL SHIFT, LEFT,  split-movetoworkspace, w-1"
    ]
    ++
    # hycov binds
    /* evalBinds "ALT" [ ] [
      "tab, hycov:toggleoverview"
      "left,  hycov:movefocus,l"
      "right, hycov:movefocus,r"
      "up,    hycov:movefocus,u"
      "down,  hycov:movefocus,d"
      "h, hycov:movefocus,l"
      "l, hycov:movefocus,r"
      "j, hycov:movefocus,u"
      "k, hycov:movefocus,d"
    ]
    ++ */
    evalBinds "CTRL" [ "SHIFT" ] [
      "SHIFT, M, pass, ^vesktop$"
    ];

  bindm =
    evalBinds "SUPER" [ ] [
      "mouse:272, movewindow"
      "mouse:273, resizewindow"
    ];

  binde =
    evalBinds "SUPER" [ "ALT" ] [
      "ALT, left,  resizeactive, -20 0"
      "ALT, right, resizeactive,  20 0"
      "ALT, up,    resizeactive, 0 -20"
      "ALT, down,  resizeactive,  0 20"
        
      "ALT, h, resizeactive, -20 0"
      "ALT, l, resizeactive,  20 0"
      "ALT, k, resizeactive, 0 -20"
      "ALT, j, resizeactive,  0 20"
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
    kb_layout = "de";
    follow_mouse = 2;

    touchpad = {
      natural_scroll = true;
      tap-to-click = true;
      drag_lock = true;
    };

    sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
  };

  gestures = {
    workspace_swipe = true;
    workspace_swipe_fingers = 3;
    workspace_swipe_forever = true;
    workspace_swipe_use_r = true;
  };

  plugin.hycov = {
    overview_gappo = 60; #gaps width from screen
    overview_gappi = 24; #gaps width from clients

    enable_hotarea = false;

    enable_gesture = true;
    swipe_fingers = 4;

    disable_workspace_change = true;
    disable_spawn = true;

    enable_alt_release_exit = true;
    alt_toggle_auto_next = true;
  };

  plugin.split-monitor-workspaces = {
    count = 5;
  };

  misc = {
    close_special_on_empty = false;
    focus_on_activate = true;
    mouse_move_enables_dpms = true;
    key_press_enables_dpms = true;
    disable_hyprland_logo = true;
    disable_splash_rendering = true;
  };

  windowrulev2 = [
    "suppressevent maximize, class:.*"

    "float, class:pavucontrol"
    "float, class:nm-connection-editor"
    "float, class:.blueman-manager-wrapped"

    "float, class:xdg-desktop-portal-gtk"

    "float, class:firefox, title:(Password Required - Mozilla Firefox)"
    "stayfocused , class:firefox, title:(Password Required - Mozilla Firefox)"

    "float, class:swayimg"
    "noborder, class:swayimg"
    "noblur, class:swayimg"
    "noshadow, class:swayimg"
    "size 100%, 100%, class:swayimg"
    "center, class:swayimg"

    "float, class:copyq"
    "move onscreen cursor, class:copyq"
    "pin, class:copyq"
  ];

  layerrule = [
    "noanim, selection"
  ];

  general = {
    gaps_in = 1;
    gaps_out = 1;
    border_size = 1;
    # "col.active_border" = "rgba(f5bde6ee)";    
    "col.active_border" = "rgba(${config.colorScheme.palette.base0F}88) rgba(${config.colorScheme.palette.base06}88) 45deg";
    "col.inactive_border" = "rgba(${config.colorScheme.palette.base04}66)";

    layout = "master";

    allow_tearing = false;
  };

  decoration = {
    rounding = 2;

    blur = {
      enabled = true;
      size = 6;
      passes = 2;

      vibrancy = 0.1696;
    };

    /* drop_shadow = true;
    shadow_range = 4;
    shadow_render_power = 3;
    "col.shadow" = "rgba(1a1a1aee)"; */
  };

  animations = {
    enabled = true;
    bezier = "myBezier, 0.05, 0.9, 0.1, 1.0";
    animation = [
      "windows, 1, 5, myBezier"
      "windowsOut, 1, 5, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 5, default"
    ];
  };

  dwindle = {
    pseudotile = true;
    preserve_split = true;
  };

  master = {
    new_is_master = false;
    new_on_top = true;
    mfact = 0.65;
    no_gaps_when_only = 1;
  };

  xwayland.force_zero_scaling = true;
}
