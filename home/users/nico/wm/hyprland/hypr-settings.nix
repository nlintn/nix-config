{
  config,
  lib,
  lib-custom,
  pkgs,
  userSettings,
  ...
}@args:

let
  evalBinds = lib-custom.hyprland.evalBinds;

  inherit (config.vars) launchPrefix;

  brightnessctl = "${launchPrefix} ${lib.getExe' config.services.avizo.package "lightctl"} -e 2";
  browser = "${launchPrefix} ${lib.getExe config.programs.firefox.finalPackage}";
  filemanager = "${launchPrefix} ${lib.getExe' config.programs.thunar.finalPackage "thunar"}";
  hyprpicker = "${launchPrefix} ${lib.getExe pkgs.hyprpicker}";
  hyprtabs = "${launchPrefix} ${lib.getExe (pkgs.callPackage ./scripts/hyprtabs.nix args)}";
  hyreload = "${launchPrefix} ${pkgs.callPackage ./scripts/hyreload.nix args}";
  lock-transparent = "${launchPrefix} ${lib.getExe (pkgs.callPackage ./hyprlock/lock-transparent.nix args)}";
  playerctl = "${launchPrefix} ${lib.getExe config.services.playerctld.package}";
  pwm = "${launchPrefix} ${lib.getExe config.programs.keepassxc.package}";
  screenshot = "${launchPrefix} ${pkgs.callPackage ./scripts/screenshot.nix args}";
  swaync-client = "${launchPrefix} ${lib.getExe' config.services.swaync.package "swaync-client"}";
  term_tmux_scratchpad = "${launchPrefix} ${xdg-terminal-exec} -- ${lib.getExe config.programs.sesh.package} connect \"scratchpad 󱞂 \"";
  term_tmux_sesh = "${launchPrefix} ${xdg-terminal-exec} -- ${config.vars.seshFzf}";
  vicinae = "${launchPrefix} ${lib.getExe config.programs.vicinae.package}";
  volumectl = "${launchPrefix} ${lib.getExe' config.services.avizo.package "volumectl"}";
  xdg-terminal-exec = "${launchPrefix} ${lib.getExe config.xdg.terminal-exec.package}";

in
with config.colorScheme.palette;
{
  monitor = [
    ", preferred, 0x0, 1"
    "eDP-1, preferred, auto-center-down, 1.6"
  ];

  env = [
    "HYPRCURSOR_THEME, ${config.home.pointerCursor.name}"
    "HYPRCURSOR_SIZE, ${toString config.home.pointerCursor.size}"
  ];

  # "debug:disable_logs" = false;

  bind =
    # SUPER binds
    evalBinds "SUPER"
      [ "ALT" "CTRL" "SHIFT" ]
      [
        # exec keybinds
        "A, exec, ${screenshot} area"
        "SHIFT, A, exec, ${screenshot} output"
        "CTRL, A, exec, ${hyprpicker} -ar"
        "E, exec, ${filemanager}"
        "W, exec, ${browser}"
        "Q, exec, ${xdg-terminal-exec}"
        "SHIFT, Q, exec, ${term_tmux_sesh}"
        "SPACE, exec, ${vicinae} vicinae://toggle"
        "SHIFT, R, exec, ${hyreload}"
        "PERIOD, exec, ${vicinae} vicinae://launch/core/search-emojis"
        "V, exec, ${vicinae} vicinae://launch/clipboard/history"
        "BACKSPACE, exec, ${config.vars.sessionLockCmd}"
        "SHIFT, BACKSPACE, exec, ${lock-transparent}"
        "RETURN, exec, ${vicinae} vicinae://launch/power"
        "PLUS, exec, ${swaync-client} --toggle-panel"
        "SHIFT, PLUS, exec, ${swaync-client} -C"
        "CTRL, PLUS, exec, ${swaync-client} --toggle-dnd"

        "C, killactive"
        "SHIFT, C, forcekillactive"
        "F, fullscreen, 1"
        "SHIFT, F, fullscreen, 0"
        "CTRL SHIFT, Z, exit"
        "B, togglefloating,"

        "G, exec, ${hyprtabs}"
        "SHIFT, G, togglegroup,"
        "CTRL, G, moveoutofgroup,"

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

        "S, togglespecialworkspace, dropterm"
        "SHIFT, S, movetoworkspacesilent, special:dropterm"

        "P, togglespecialworkspace, pwm"
        "SHIFT, P, movetoworkspacesilent, special:pwm"

        "SHIFT, K, split:grabroguewindows"
      ]
    ++
      evalBinds "ALT"
        [ ]
        [
          "TAB, exec, ${vicinae} vicinae://launch/wm/switch-windows"
        ]
    ++
      evalBinds "CTRL"
        [ "SHIFT" ]
        [
          "SHIFT, M, pass, ^vesktop$"
        ];

  bindm =
    evalBinds "SUPER"
      [ ]
      [
        "mouse:272, movewindow"
        "mouse:273, resizewindow"
      ];

  binde =
    evalBinds "SUPER"
      [ "ALT" "CTRL" "SHIFT" ]
      [
        "left,  movefocus, l"
        "right, movefocus, r"
        "up,    movefocus, u"
        "down,  movefocus, d"
        "SHIFT, left,  movewindoworgroup, l"
        "SHIFT, right, movewindoworgroup, r"
        "SHIFT, up,    movewindoworgroup, u"
        "SHIFT, down,  movewindoworgroup, d"
        "h, movefocus, l"
        "l, movefocus, r"
        "k, movefocus, u"
        "j, movefocus, d"
        "SHIFT, h, movewindoworgroup, l"
        "SHIFT, l, movewindoworgroup, r"
        "SHIFT, k, movewindoworgroup, u"
        "SHIFT, j, movewindoworgroup, d"

        "ALT, left,  resizeactive, -20 0"
        "ALT, right, resizeactive,  20 0"
        "ALT, up,    resizeactive, 0 -20"
        "ALT, down,  resizeactive, 0  20"

        "ALT, h, resizeactive, -20 0"
        "ALT, l, resizeactive,  20 0"
        "ALT, k, resizeactive, 0 -20"
        "ALT, j, resizeactive, 0  20"

        "CTRL, RIGHT, split:workspace, r+1"
        "CTRL, LEFT,  split:workspace, r-1"
        "CTRL SHIFT, RIGHT, split:movetoworkspace, r+1"
        "CTRL SHIFT, LEFT,  split:movetoworkspace, r-1"

        "CTRL, L, split:workspace, r+1"
        "CTRL, H, split:workspace, r-1"
        "CTRL SHIFT, L, split:movetoworkspace, r+1"
        "CTRL SHIFT, H, split:movetoworkspace, r-1"

        "TAB, changegroupactive, f"

        "SHIFT, TAB, changegroupactive, b"

        "M, focusmonitor, +1"
        "N, focusmonitor, -1"
        "SHIFT, M, movewindow, mon:+1"
        "SHIFT, N, movewindow, mon:-1"
      ];

  bindl =
    evalBinds ""
      [ ]
      [
        "XF86AudioMute,    exec, ${volumectl} -p toggle-mute"
        "XF86AudioMicMute, exec, ${volumectl} -m -p toogle-mute"
        "XF86AudioNext,    exec, ${playerctl} next"
        "XF86AudioPrev,    exec, ${playerctl} previous"
        "XF86AudioPlay,    exec, ${playerctl} play-pause"
        "XF86AudioPause,   exec, ${playerctl} play-pause"
      ];

  bindle =
    evalBinds ""
      [ ]
      [
        "XF86AudioRaiseVolume,  exec, ${volumectl} -p up"
        "XF86AudioLowerVolume,  exec, ${volumectl} -p down"
        "XF86MonBrightnessUp,   exec, ${brightnessctl} up"
        "XF86MonBrightnessDown, exec, ${brightnessctl} down"
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
    repeat_rate = 30;
    repeat_delay = 400;
  };

  gesture = [
    "3, horizontal, workspace"
  ];
  gestures = {
    workspace_swipe_forever = true;
    workspace_swipe_use_r = true;
    workspace_swipe_create_new = false;
  };

  group = {
    "col.border_active" = "rgba(${base0F}66)";
    "col.border_inactive" = "rgba(${base04}66)";
    "col.border_locked_active" = "rgba(${base0F}66)";
    "col.border_locked_inactive" = "rgba(${base04}66)";
    groupbar = {
      font_size = 10;
      gaps_in = 1;
      gaps_out = 1;
      gradients = true;
      gradient_rounding = 0;
      height = 15;
      indicator_gap = 0;
      indicator_height = 0;
      keep_upper_gap = false;
      scrolling = false;
      text_offset = 1;

      "col.active" = "rgb(${base00})";
      font_weight_active = "semibold";
      text_color = "rgb(${base05})";

      "col.inactive" = "rgb(${base01})";
      font_weight_inactive = "semilight";
      text_color_inactive = "rgba(${base05}cc)";
    };
  };

  misc = {
    allow_session_lock_restore = true;
    anr_missed_pings = 3;
    close_special_on_empty = false;
    disable_autoreload = true;
    disable_hyprland_logo = true;
    disable_splash_rendering = true;
    focus_on_activate = true;
    font_family = userSettings.default-font.name;
    key_press_enables_dpms = true;
    mouse_move_enables_dpms = false;
    on_focus_under_fullscreen = 2;
  };

  render.cm_enabled = false;

  windowrule = [
    {
      name = "group_non_float";
      "match:float" = false;
      group = "set";
    }
    {
      name = "round_float";
      "match:float" = true;
      group = "deny";
      rounding = 10;
    }

    {
      name = "disable_screenshare_classes";
      "match:class" = "keepassxc|org.keepassxc.KeePassXC";
      no_screen_share = true;
    }

    {
      name = "float_classes";
      float = true;
      group = "deny";
      "match:class" = lib.concatStringsSep "|" [
        "\\.blueman-manager-wrapped"
        "com\\.saivert\\.pwvucontrol"
        "nm-applet"
        "nm-connection-editor"
      ];
    }
    {
      name = "float_fileroller_popup";
      float = true;
      group = "deny";
      "match:class" = "org.gnome.FileRoller";
      "match:title" = lib.concatStringsSep "|" [
        "Extract"
        "Select App"
        ""
      ];
    }
    {
      name = "float_keepassxc_popups";
      float = true;
      group = "deny";
      "match:class" = "keepassxc|org.keepassxc.KeePassXC";
      "match:title" = lib.concatStringsSep "|" [
        "Generate Password"
        "KeePassXC -  Access Request"
        "Open .*"
        "Save attachments"
        "Select files"
      ];
    }
    {
      name = "float_mozilla_popup";
      float = true;
      group = "deny";
      "match:class" = "firefox|thunderbird";
      "match:title" = lib.concatStringsSep "|" [
        "About Mozilla (Firefox|Thunderbird)"
        "Library"
        "OpenPGP Key Manager"
        "Page Info — .*"
        "Password Required - Mozilla (Firefox|Thunderbird)"
      ];
    }
    {
      name = "float_steam_popup";
      float = true;
      group = "deny";
      "match:class" = "steam";
      "match:title" = lib.concatStringsSep "|" [
        "Steam Settings"
        "Friends List"
      ];
    }

    {
      name = "no_border_classes";
      border_size = 0;
      "match:class" = lib.concatStringsSep "|" [
        "vicinae"
      ];
    }

    {
      name = "pin_classes";
      pin = true;
      group = "deny";
      "match:class" = lib.concatStringsSep "|" [
        "dragon-drop"
        "xdragon"
      ];
    }

    {
      name = "pin_stay_focused_keepassxc_popups";
      center = true;
      pin = true;
      stay_focused = true;
      "match:class" = "keepassxc|org.keepassxc.KeePassXC";
      "match:title" = lib.concatStringsSep "|" [
        "KeePassXC -  Access Request"
        "KeePassXC - Browser Access Request"
        "Unlock Database - KeePassXC"
      ];
    }

    {
      name = "stay_focused_classes";
      stay_focused = true;
      "match:class" = lib.concatStringsSep "|" [
        "exo-open"
        "gcr-prompter"
        "gtk-ssh-askpass"
        "polkit-gnome-authentication-agent-1"
      ];
    }

    {
      name = "stay_focused_thunderbird_confirm";
      stay_focused = true;
      "match:class" = "thunderbird";
      "match:title" = lib.concatStringsSep "|" [
        "Confirm"
        "Confirm Deletion"
        "Save Message"
        "Send Message"
        "Source of: .* - Mozilla Thunderbird"
      ];
    }

    {
      name = "supress_fullscreen_all";
      "match:class" = ".*";
      suppress_event = lib.concatStringsSep " " [
        "fullscreen"
        "maximize"
      ];
    }

    {
      name = "no_gaps_when_only";
      border_size = 0;
      "match:float" = false;
      "match:workspace" = "w[tv1]";
    }
    {
      name = "no_gaps_when_max";
      border_size = 0;
      "match:float" = false;
      "match:workspace" = "f[1]";
    }

    # "match:float off, match:workspace w[t1], decorate off"
  ];

  layerrule = [
    {
      name = "blur_popup";
      blur = true;
      ignore_alpha = 0;
      xray = false;
      "match:namespace" = "avizo|vicinae|swaync-.*";
    }
    {
      name = "abovelock_avizo";
      above_lock = 1;
      "match:namespace" = "avizo";
    }
    {
      name = "no_anim_selection";
      no_anim = true;
      "match:namespace" = "selection";
    }
  ];

  workspace = [
    "special:dropterm, on-created-empty:${term_tmux_scratchpad}"
    "special:pwm, on-created-empty:${pwm}"
  ];

  general = {
    gaps_in = 1;
    gaps_out = "0,0,1,0";
    border_size = 1;
    "col.active_border" = "rgba(${base0F}aa)";
    "col.nogroup_border" = "rgba(${base04}aa)";
    "col.inactive_border" = "rgba(${base04}aa)";
    "col.nogroup_border_active" = "rgba(${base0F}aa)";

    layout = "master";
    allow_tearing = false;

    snap.enabled = true;
  };

  decoration = {
    rounding = 0;

    blur = {
      enabled = true;
      size = 7;
      passes = 2;
      xray = false;
    };
    shadow.enabled = false;
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

  plugin = {
    hyprsplit = {
      num_workspaces = 10;
      persistent_workspaces = true;
    };
  };
}
