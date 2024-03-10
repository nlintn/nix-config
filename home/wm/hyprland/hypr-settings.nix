{ pkgs, lib, config, inputs, thunar_pkg, ... }:

let
  evalBind = mainMod: modifiers: bind: (
    mainMod + (
      if (lib.foldl (acc: mod: acc || (lib.hasPrefix mod bind)) false modifiers) then " " else ", "
    ) + bind
  );
  grimblast = inputs.hyprland-contrib.packages.${pkgs.system}.grimblast;
in
{
  source = [
    "$HOME/.config/hypr/monitors.conf"
    "$HOME/.config/hypr/workspaces.conf"
  ];

  "$terminal" = "${config.programs.alacritty.package}/bin/alacritty";
  "$fileManager" = "${thunar_pkg}/bin/thunar";
  "$menu" = "${config.programs.rofi.package}/bin/rofi -show drun";
  "$windows" = "${import ./scripts/rofi-windows.nix { inherit pkgs; }}";

  env = [
    "XDG_SESSION_DESKTOP, Hyprland"
    "XCURSOR_SIZE, 16"
  ];

  exec-once = [
    "${pkgs.swaynotificationcenter}/bin/swaync"
    "${config.programs.waybar.package}/bin/waybar"
    "${pkgs.networkmanagerapplet}/bin/nm-applet"
    "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    "${pkgs.swaybg}/bin/swaybg -i ${./wallpaper.jpg}"
    "sleep 5; ${pkgs.copyq}/bin/copyq --start-server"
  ];

  # "debug:disable_scale_checks" = true;

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
    builtins.map (evalBind "SUPER" [ "CTRL" "SHIFT" ]) [
      "A, exec, ${grimblast}/bin/grimblast --freeze save area - | ${pkgs.swappy}/bin/swappy -f -"
      "SHIFT, A, exec, ${grimblast}/bin/grimblast --freeze save output - | ${pkgs.swappy}/bin/swappy -f -"
      "Q, exec, $terminal"
      "C, killactive,"
      "V, exec, ${pkgs.copyq}/bin/copyq show"
      "SHIFT, M, exit,"
      "E, exec, $fileManager"
      "SPACE, togglefloating,"
      "R, exec, $menu"
      "P, pseudo,"
      "G, togglesplit,"
      "tab, exec, $windows"
      "SHIFT, R, exec, ${import ./scripts/hyreload.nix { inherit pkgs; }}"
      "BACKSPACE, exec, ${config.programs.swaylock.package}/bin/swaylock"

      "left,  movefocus, l"
      "right, movefocus, r"
      "up,    movefocus, u"
      "down,  movefocus, d"
      "SHIFT, left,   movewindow, l"
      "SHIFT, right,  movewindow, r"
      "SHIFT, up,     movewindow, u"
      "SHIFT, down,   movewindow, d"

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

      "D, exec, scratchpad"
      "SHIFT, D, exec, scratchpad -g"

      "CTRL, RIGHT, split-workspace, r+1"
      "CTRL, LEFT,  split-workspace, r-1"
      "CTRL SHIFT, RIGHT, split-movetoworkspace, r+1"
      "CTRL SHIFT, LEFT,  split-movetoworkspace, r-1"

      "F, fullscreen, 0"
      "SHIFT, F, fullscreen, 1"
    ]
    ++
    # hycov binds
    builtins.map (evalBind "ALT" [ ]) [
      "tab, hycov:toggleoverview"
      "left, hycov:movefocus,l"
      "right, hycov:movefocus,r"
      "up, hycov:movefocus,u"
      "down, hycov:movefocus,d"
    ]
    ++
    builtins.map (evalBind "CTRL" [ "SHIFT" ]) [
      "SHIFT, M, pass, ^vesktop$"
    ]
    ++
    builtins.map (evalBind "" []) [
      "XF86AudioNext,   exec, playerctl next"
      "XF86AudioPrev,   exec, playerctl previous"
      "XF86AudioPlay,   exec, playerctl play-pause"
      "XF86AudioPause,  exec, playerctl play-pause"
      
    ];

  bindm = builtins.map (evalBind "SUPER" [ ]) [
    "mouse:272, movewindow"
    "mouse:273, resizewindow"
  ];

  binde = builtins.map (evalBind "" [ ]) [
    "XF86AudioRaiseVolume,  exec, ${config.services.avizo.package}/bin/volumectl -d -u -p up"
    "XF86AudioLowerVolume,  exec, ${config.services.avizo.package}/bin/volumectl -d -u -p down"
    "XF86MonBrightnessUp,   exec, ${config.services.avizo.package}/bin/lightctl -d up"
    "XF86MonBrightnessDown, exec, ${config.services.avizo.package}/bin/lightctl -d down"
  ];

  bindle = builtins.map (evalBind "" [ ]) [
    "XF86AudioMute, exec,     ${config.services.avizo.package}/bin/volumectl -d -p toggle-mute"
    "XF86AudioMicMute, exec,  ${config.services.avizo.package}/bin/volumectl -d -m -p toogle-mute"
  ];

  binds = {
    workspace_back_and_forth = true;
  };

  input = {
    kb_layout = "de";
    follow_mouse = 1;

    touchpad = {
      natural_scroll = true;
      tap-to-click = true;
    };

    sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
  };

  gestures = {
    workspace_swipe = true;
    workspace_swipe_fingers = 3;
    workspace_swipe_numbered = true;
  };

  plugin.hycov = {
    overview_gappo = 60; #gaps width from screen
    overview_gappi = 24; #gaps width from clients

    enable_hotarea = 0;

    enable_gesture = 1;
    swipe_fingers = 4;

    disable_workspace_change = 1;
    disable_spawn = 1;

    enable_alt_release_exit = 1;
    alt_toggle_auto_next = 1;
  };

  plugin.split-monitor-workspaces = {
    count = 5;
  };

  misc = {
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

    "fullscreen, class:swayimg"
    "noborder, class:swayimg"
    "noblur, class:swayimg"
    "noshadow, class:swayimg"

    "float, class:(copyq)"
    "move onscreen cursor, class:(copyq)"
    "pin, class:(copyq)"

    "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
    "noanim,class:^(xwaylandvideobridge)$"
    "noinitialfocus,class:^(xwaylandvideobridge)$"
    "maxsize 1 1,class:^(xwaylandvideobridge)$"
    "noblur,class:^(xwaylandvideobridge)$"
  ];

  layerrule = [
    "noanim, selection"
  ];

  general = {
    gaps_in = 3;
    gaps_out = 5;
    border_size = 1;
    # "col.active_border" = "rgba(c6a0f6ee) rgba(8bd5caee) 45deg";
    # "col.active_border" = "rgba(f5bde6ee) rgba(ee99a0ee) 45deg";
    "col.active_border" = "rgba(f5bde6ee)";
    # "col.inactive_border" = "rgba(595959aa)";
    "col.inactive_border" = "rgba(5b6078aa)";

    layout = "dwindle";

    # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
    allow_tearing = false;
  };

  decoration = {
    rounding = 5;

    blur = {
      enabled = true;
      size = 3;
      passes = 1;

      vibrancy = 0.1696;
    };

    drop_shadow = true;
    shadow_range = 4;
    shadow_render_power = 3;
    "col.shadow" = "rgba(1a1a1aee)";
  };

  animations = {
    enabled = true;
    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
    animation = [
      "windows, 1, 7, myBezier"
      "windowsOut, 1, 7, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 6, default"
    ];
  };

  dwindle = {
    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = true; # you probably want this
  };

  master = {
    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    new_is_master = true;
    # new_on_top = true;
  };

  xwayland.force_zero_scaling = true;
}
