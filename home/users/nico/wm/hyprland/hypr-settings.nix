{
  config,
  hyreload,
  lib,
  lib-custom,
  pkgs,
  userSettings,
  ...
}@args:

let
  evalBinds = lib-custom.hyprland.evalBinds;

  var_brightnessctl = "${lib.getExe' config.services.avizo.package "lightctl"} -e 2";
  var_browser = lib.getExe config.programs.firefox.finalPackage;
  var_filemanager = lib.getExe' config.programs.thunar.finalPackage "thunar";
  var_grimblast = lib.getExe pkgs.grimblast;
  var_hyprpicker = lib.getExe pkgs.hyprpicker;
  var_hyprtabs = lib.getExe (pkgs.callPackage ./scripts/hyprtabs.nix args);
  var_launcher = lib.getExe config.programs.vicinae.package;
  var_lock-cmd = config.vars.sessionLockCmd;
  var_lock-transparent = lib.getExe (pkgs.callPackage ./hyprlock/lock-transparent.nix args);
  var_loginctl = config.systemd.user.loginctlPath;
  var_playerctl = lib.getExe config.services.playerctld.package;
  var_pwm = lib.getExe config.programs.keepassxc.package;
  var_swappy = lib.getExe config.programs.swappy.package;
  var_swaync-client = lib.getExe' config.services.swaync.package "swaync-client";
  var_term = lib.getExe config.xdg.terminal-exec.package;
  var_term_scratchpad = "${var_term} -- ${lib.getExe config.programs.sesh.package} connect \"scratchpad 󱞂 \"";
  var_term_tmux = "${var_term} -- ${config.vars.seshFzf}";
  var_volumectl = lib.getExe' config.services.avizo.package "volumectl";

in
with config.colorScheme.palette;
{
  source = [
    "$HOME/.config/hypr/monitors.conf"
  ];

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
        "A, exec, ${var_grimblast} --freeze save area - | ${var_swappy} -f -"
        "SHIFT, A, exec, ${var_grimblast} --freeze save output - | ${var_swappy} -f -"
        "CTRL, A, exec, ${var_hyprpicker} -ar"
        "E, exec, ${var_filemanager}"
        "W, exec, ${var_browser}"
        "Q, exec, ${var_term}"
        "SHIFT, Q, exec, ${var_term_tmux}"
        "SPACE, exec, ${var_launcher} vicinae://toggle"
        "SHIFT, R, exec, ${hyreload}"
        "PERIOD, exec, ${var_launcher} vicinae://extensions/vicinae/core/search-emojis"
        "V, exec, ${var_launcher} vicinae://extensions/vicinae/clipboard/history"
        "BACKSPACE, exec, ${var_lock-cmd}"
        "SHIFT, BACKSPACE, exec, ${var_lock-transparent}"
        "RETURN, exec, ${var_launcher} vicinae://extensions/vicinae/power"
        "PLUS, exec, ${var_swaync-client} --toggle-panel"
        "SHIFT, PLUS, exec, ${var_swaync-client} -C"
        "CTRL, PLUS, exec, ${var_swaync-client} --toggle-dnd"

        "C, killactive"
        "SHIFT, C, forcekillactive"
        "F, fullscreen, 1"
        "SHIFT, F, fullscreen, 0"
        "SHIFT, Z, exec, ${var_loginctl} terminate-session self"
        "CTRL SHIFT, Z, exit"
        # "P, pseudo,"
        "B, togglefloating,"

        "G, exec, ${var_hyprtabs}"
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
          "TAB, exec, ${var_launcher} vicinae://extensions/vicinae/wm/switch-windows"
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
        "XF86AudioMute,    exec, ${var_volumectl} -p toggle-mute"
        "XF86AudioMicMute, exec, ${var_volumectl} -m -p toogle-mute"
        "XF86AudioNext,    exec, ${var_playerctl} next"
        "XF86AudioPrev,    exec, ${var_playerctl} previous"
        "XF86AudioPlay,    exec, ${var_playerctl} play-pause"
        "XF86AudioPause,   exec, ${var_playerctl} play-pause"
      ];

  bindle =
    evalBinds ""
      [ ]
      [
        "XF86AudioRaiseVolume,  exec, ${var_volumectl} -p up"
        "XF86AudioLowerVolume,  exec, ${var_volumectl} -p down"
        "XF86MonBrightnessUp,   exec, ${var_brightnessctl} up"
        "XF86MonBrightnessDown, exec, ${var_brightnessctl} down"
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
      gaps_out = 0;
      gradients = true;
      gradient_rounding = 0;
      height = 14;
      indicator_gap = 0;
      indicator_height = 1;
      keep_upper_gap = false;
      scrolling = false;
      text_offset = 1;

      "col.active" = "rgb(${base0E})";
      font_weight_active = "semibold";
      text_color = "rgb(${base01})";

      "col.inactive" = "rgb(${base00})";
      font_weight_inactive = "normal";
      text_color_inactive = "rgb(${base05})";
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

  windowrule =
    let
      template = {
        border_size = 0;
        float = true;
        group = "deny";
        rounding = 10;
      };
    in
    [
      {
        name = "group_non_float";
        "match:float" = false;
        group = "set";
      }
      {
        name = "supress_fullscreen";
        "match:class" = ".*";
        suppress_event = [
          "fullscreen"
          "maximize"
        ];
      }
      {
        name = "disable_screenshare";
        "match:class" = "keepassxc|org.keepassxc.KeePassXC";
        no_screen_share = true;
      }
      {
        name = "round_stay_focused_askpass";
        inherit (template) rounding;
        stay_focused = true;
        "match:class" = "gtk-ssh-askpass";
      }
      {
        name = "float_classes";
        inherit (template) float group;
        "match:class" = "nm-connection-editor|\\.blueman-manager-wrapped";
      }
      {
        name = "float_round_classes";
        inherit (template) float group rounding;
        "match:class" = "com\\.saivert\\.pwvucontrol||xdg-desktop-portal-gtk";
      }
      {
        name = "float_mozilla_pass_popup";
        inherit (template) float group;
        "match:class" = "firefox|thunderbird";
        "match:title" = "Password Required - Mozilla (Firefox|Thunderbird)";
      }
      {
        name = "focus_thunderbird_confirm";
        stay_focused = true;
        "match:class" = "thunderbird";
        "match:title" = "Send Message";
      }
      {
        name = "float_round_keepassxc_file_popup";
        inherit (template) float group rounding;
        "match:class" = "keepassxc";
        "match:title" = "Open .*|Save attachments|Select files";
      }
      {
        name = "float_keepassxc_gen_popup";
        inherit (template) float group;
        "match:class" = "org.keepassxc.KeePassXC";
        "match:title" = "Generate Password";
      }
      {
        name = "float_pin_keepassxc_access_popup";
        inherit (template) float group;
        center = true;
        pin = true;
        stay_focused = true;
        "match:class" = "org.keepassxc.KeePassXC";
        "match:title" = "KeePassXC - ( Access Request|Unlock Database)";
      }
      {
        name = "float_steam_popup";
        inherit (template) float group;
        "match:class" = "steam";
        "match:title" = "Steam Settings|Friends List";
      }
      {
        name = "float_round_thunar_popup";
        inherit (template) float group rounding;
        "match:class" = "(t|T)hunar";
        "match:title" = "Error|File Operation Progress|Rename .*";
      }
      {
        name = "float_round_pin_dragondrop";
        inherit (template) float group rounding;
        border_size = 0;
        pin = true;
        "match:class" = "dragon-drop|xdragon";
      }
      {
        name = "float_vicinae";
        inherit (template) float group rounding;
        border_size = 0;
        "match:class" = "vicinae";
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
      above_lock = true;
      "match:namespace" = "avizo";
    }
    {
      name = "no_anim_selection";
      no_anim = true;
      "match:namespace" = "selection";
    }
  ];

  workspace = [
    "special:dropterm, on-created-empty:${var_term_scratchpad}"
    "special:pwm, on-created-empty:${var_pwm}"
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
