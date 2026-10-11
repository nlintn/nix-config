{
  config,
  lib,
  lib-custom,
  pkgs,
  userSettings,
  ...
}@args:

let
  inherit (lib-custom.hyprland) mkBinds mkBindsExec mkEnv;

  inherit (config.vars) launchPrefix;

  brightnessctl = "${lib.getExe' config.services.avizo.package "lightctl"} -e 2";
  browser = lib.getExe config.programs.firefox.finalPackage;
  filemanager = lib.getExe config.programs.nautilus.package;
  grim = lib.getExe pkgs.grim;
  hyprpicker = lib.getExe pkgs.hyprpicker;
  hyreload = pkgs.callPackage ./scripts/hyreload.nix args;
  lock-transparent = lib.getExe (pkgs.callPackage ./swaylock/lock-transparent.nix args);
  playerctl = lib.getExe config.services.playerctld.package;
  pwm = "${lib.getExe config.programs.keepassxc.package}";
  satty = lib.getExe config.programs.satty.package;
  slurp = lib.getExe pkgs.slurp;
  swaync-client = lib.getExe' config.services.swaync.package "swaync-client";
  term_tmux_scratchpad = "${xdg-terminal-exec} -- ${lib.getExe config.programs.sesh.package} connect \"scratchpad 󱞂 \"";
  term_tmux_sesh = "${xdg-terminal-exec} -- ${config.vars.seshFzf}";
  vicinae = lib.getExe config.programs.vicinae.package;
  volumectl = lib.getExe' config.services.avizo.package "volumectl";
  xdg-terminal-exec = lib.getExe config.xdg.terminal-exec.package;
in
with config.colorScheme.palette;
let
  slurpOpts = ''-F "${userSettings.default-font.name}" -c "#${base01}ff" -b "#${base05}33"'';
in
{
  monitor = [
    {
      output = "";
      mode = "preferred";
      position = "0x0";
      scale = "1";
    }
    {
      output = "eDP-1";
      mode = "preferred";
      position = "auto-center-down";
      scale = "1.6";
    }
  ];

  env = mkEnv {
    HYPRCURSOR_THEME = config.home.pointerCursor.name;
    HYPRCURSOR_SIZE = config.home.pointerCursor.size;
  };

  bind =
    mkBindsExec (
      lib.mapAttrs (_: v: launchPrefix + v) {
        "SUPER + SHIFT + A" =
          pkgs.writeShellScript "screenshot-output" "${slurp} ${slurpOpts} -or | ${grim} -g - - | ${satty} -f -";
        "SUPER + CTRL + A" = "${hyprpicker} -ar";
        "SUPER + E" = filemanager;
        "SUPER + W" = browser;
        "SUPER + Q" = xdg-terminal-exec;
        "SUPER + SHIFT + Q" = term_tmux_sesh;
        "SUPER + SPACE" = "${vicinae} vicinae://toggle";
        "SUPER + SHIFT + SPACE" = "${vicinae} vicinae://pop_to_root";
        "SUPER + SHIFT + R" = hyreload;
        "SUPER + PERIOD" = "${vicinae} vicinae://launch/core/search-emojis?toggle=true";
        "SUPER + V" = "${vicinae} vicinae://launch/clipboard/history?toggle=true";
        "SUPER + BACKSPACE" = config.vars.sessionLockCmd;
        "SUPER + SHIFT + BACKSPACE" = lock-transparent;
        "SUPER + RETURN" = "${vicinae} vicinae://launch/power?toggle=true";
        "SUPER + PLUS" = "${swaync-client} --toggle-panel";
        "SUPER + SHIFT + PLUS" = "${swaync-client} -C";
        "SUPER + CTRL + PLUS" = "${swaync-client} --toggle-dnd";

        "ALT + TAB" = "${vicinae} vicinae://launch/wm/switch-windows?toggle=true";
      }
    )
    ++ mkBinds [
      # {
      #   keys = "SUPER + A";
      #   dispatcher = /* lua */ ''
      #     function()
      #       hl.dispatch(hl.dsp.exec_cmd("${pkgs.writeShellScript "screenshot-area" ''hyprland-dialog --text "$1"''} \"" .. functions.visible_window_rectangles() .. "\""))
      #     end
      #   '';
      # }
      {
        keys = "SUPER + A";
        dispatcher = /* lua */ ''
          function()
            hl.dispatch(hl.dsp.exec_cmd("${pkgs.writeShellScript "screenshot-area" ''([ $# -gt 0 ] && ${slurp} ${slurpOpts} -d <<< "$@" || ${slurp} ${slurpOpts} -d) | ${grim} -g - - | ${satty} -f -''} " .. functions.visible_window_rectangles()))
          end
        '';
      }
      {
        keys = "SUPER + C";
        dispatcher = "hl.dsp.window.close()";
      }
      {
        keys = "SUPER + SHIFT + C";
        dispatcher = "hl.dsp.window.kill()";
      }
      {
        keys = "SUPER + F";
        dispatcher = "hl.dsp.window.fullscreen({ mode = \"maximized\", action = \"toggle\" })";
      }
      {
        keys = "SUPER + SHIFT + F";
        dispatcher = "hl.dsp.window.fullscreen({ mode = \"fullscreen\", action = \"toggle\" })";
      }
      {
        keys = "SUPER + B";
        dispatcher = "hl.dsp.window.float({ action = \"toggle\" })";
      }
      {
        keys = "SUPER + G";
        dispatcher = "functions.toggle_group";
      }
      {
        keys = "SUPER + SHIFT + G";
        dispatcher = "hl.dsp.group.toggle()";
      }
      {
        keys = "SUPER + CTRL + G";
        dispatcher = "hl.dsp.window.move({ out_of_group = true })";
      }
      {
        keys = "SUPER + Z";
        dispatcher = "function() functions.zoom(0.5) end";
      }
      {
        keys = "SUPER + SHIFT + Z";
        dispatcher = "function() functions.zoom(-0.5) end";
      }
      {
        keys = "SUPER + CTRL + Z";
        dispatcher = "function() functions.zoom(nil) end";
      }
      {
        keys = "SUPER + dead_circumflex";
        dispatcher = "hl.dsp.focus({ workspace = \"previous_per_monitor\" })";
      }
      {
        keys = "SUPER + 1";
        dispatcher = "hl.dsp.focus({ workspace = 1, on_current_monitor = true })";
      }
      {
        keys = "SUPER + 2";
        dispatcher = "hl.dsp.focus({ workspace = 2, on_current_monitor = true })";
      }
      {
        keys = "SUPER + 3";
        dispatcher = "hl.dsp.focus({ workspace = 3, on_current_monitor = true })";
      }
      {
        keys = "SUPER + 4";
        dispatcher = "hl.dsp.focus({ workspace = 4, on_current_monitor = true })";
      }
      {
        keys = "SUPER + 5";
        dispatcher = "hl.dsp.focus({ workspace = 5, on_current_monitor = true })";
      }
      {
        keys = "SUPER + 6";
        dispatcher = "hl.dsp.focus({ workspace = 6, on_current_monitor = true })";
      }
      {
        keys = "SUPER + 7";
        dispatcher = "hl.dsp.focus({ workspace = 7, on_current_monitor = true })";
      }
      {
        keys = "SUPER + 8";
        dispatcher = "hl.dsp.focus({ workspace = 8, on_current_monitor = true })";
      }
      {
        keys = "SUPER + 9";
        dispatcher = "hl.dsp.focus({ workspace = 9, on_current_monitor = true })";
      }
      {
        keys = "SUPER + 0";
        dispatcher = "hl.dsp.focus({ workspace = 10, on_current_monitor = true })";
      }
      {
        keys = "SUPER + SHIFT + 1";
        dispatcher = "hl.dsp.window.move({ workspace = 1, follow = false })";
      }
      {
        keys = "SUPER + SHIFT + 2";
        dispatcher = "hl.dsp.window.move({ workspace = 2, follow = false })";
      }
      {
        keys = "SUPER + SHIFT + 3";
        dispatcher = "hl.dsp.window.move({ workspace = 3, follow = false })";
      }
      {
        keys = "SUPER + SHIFT + 4";
        dispatcher = "hl.dsp.window.move({ workspace = 4, follow = false })";
      }
      {
        keys = "SUPER + SHIFT + 5";
        dispatcher = "hl.dsp.window.move({ workspace = 5, follow = false })";
      }
      {
        keys = "SUPER + SHIFT + 6";
        dispatcher = "hl.dsp.window.move({ workspace = 6, follow = false })";
      }
      {
        keys = "SUPER + SHIFT + 7";
        dispatcher = "hl.dsp.window.move({ workspace = 7, follow = false })";
      }
      {
        keys = "SUPER + SHIFT + 8";
        dispatcher = "hl.dsp.window.move({ workspace = 8, follow = false })";
      }
      {
        keys = "SUPER + SHIFT + 9";
        dispatcher = "hl.dsp.window.move({ workspace = 9, follow = false })";
      }
      {
        keys = "SUPER + SHIFT + 0";
        dispatcher = "hl.dsp.window.move({ workspace = 10, follow = false })";
      }
      {
        keys = "SUPER + S";
        dispatcher = "hl.dsp.workspace.toggle_special(\"dropterm\")";
      }
      {
        keys = "SUPER + SHIFT + S";
        dispatcher = "hl.dsp.window.move({ workspace = \"special:dropterm\", follow = false })";
      }
      {
        keys = "SUPER + P";
        dispatcher = "hl.dsp.workspace.toggle_special(\"pwm\")";
      }
      {
        keys = "SUPER + SHIFT + P";
        dispatcher = "hl.dsp.window.move({ workspace = \"special:pwm\", follow = false })";
      }

      {
        keys = "SUPER + mouse:272";
        dispatcher = "hl.dsp.window.drag()";
      }
      {
        keys = "SUPER + mouse:273";
        dispatcher = "hl.dsp.window.resize()";
      }

      {
        keys = "SUPER + left";
        dispatcher = "hl.dsp.focus({ direction = \"left\" })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + right";
        dispatcher = "hl.dsp.focus({ direction = \"right\" })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + up";
        dispatcher = "hl.dsp.focus({ direction = \"up\" })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + down";
        dispatcher = "hl.dsp.focus({ direction = \"down\" })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + SHIFT + left";
        dispatcher = "hl.dsp.window.move({ direction = \"l\" })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + SHIFT + right";
        dispatcher = "hl.dsp.window.move({ direction = \"r\" })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + SHIFT + up";
        dispatcher = "hl.dsp.window.move({ direction = \"u\" })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + SHIFT + down";
        dispatcher = "hl.dsp.window.move({ direction = \"d\" })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + h";
        dispatcher = "hl.dsp.focus({ direction = \"left\" })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + l";
        dispatcher = "hl.dsp.focus({ direction = \"right\" })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + k";
        dispatcher = "hl.dsp.focus({ direction = \"up\" })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + j";
        dispatcher = "hl.dsp.focus({ direction = \"down\" })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + SHIFT + h";
        dispatcher = "hl.dsp.window.move({ direction = \"l\" })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + SHIFT + l";
        dispatcher = "hl.dsp.window.move({ direction = \"r\" })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + SHIFT + k";
        dispatcher = "hl.dsp.window.move({ direction = \"u\" })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + SHIFT + j";
        dispatcher = "hl.dsp.window.move({ direction = \"d\" })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + ALT + left";
        dispatcher = "hl.dsp.window.resize({ x = -20, y = 0, relative = true })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + ALT + right";
        dispatcher = "hl.dsp.window.resize({ x = 20, y = 0, relative = true })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + ALT + up";
        dispatcher = "hl.dsp.window.resize({ x = 0, y = -20, relative = true })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + ALT + down";
        dispatcher = "hl.dsp.window.resize({ x = 0, y = 20, relative = true })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + ALT + h";
        dispatcher = "hl.dsp.window.resize({ x = -20, y = 0, relative = true })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + ALT + l";
        dispatcher = "hl.dsp.window.resize({ x = 20, y = 0, relative = true })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + ALT + k";
        dispatcher = "hl.dsp.window.resize({ x = 0, y = -20, relative = true })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + ALT + j";
        dispatcher = "hl.dsp.window.resize({ x = 0, y = 20, relative = true })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + CTRL + RIGHT";
        dispatcher = "hl.dsp.focus({ workspace = \"+1\", on_current_monitor = true })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + CTRL + LEFT";
        dispatcher = "hl.dsp.focus({ workspace = -1, on_current_monitor = true })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + CTRL + SHIFT + RIGHT";
        dispatcher = "hl.dsp.window.move({ workspace = \"+1\" })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + CTRL + SHIFT + LEFT";
        dispatcher = "hl.dsp.window.move({ workspace = -1 })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + CTRL + L";
        dispatcher = "hl.dsp.focus({ workspace = \"+1\", on_current_monitor = true })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + CTRL + H";
        dispatcher = "hl.dsp.focus({ workspace = -1, on_current_monitor = true })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + CTRL + SHIFT + L";
        dispatcher = "hl.dsp.window.move({ workspace = \"+1\" })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + CTRL + SHIFT + H";
        dispatcher = "hl.dsp.window.move({ workspace = -1 })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + TAB";
        dispatcher = "hl.dsp.group.next()";
        flags.repeating = true;
      }
      {
        keys = "SUPER + SHIFT + TAB";
        dispatcher = "hl.dsp.group.prev()";
        flags.repeating = true;
      }
      {
        keys = "SUPER + M";
        dispatcher = "hl.dsp.focus({ monitor = \"+1\" })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + N";
        dispatcher = "hl.dsp.focus({ monitor = -1 })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + SHIFT + M";
        dispatcher = "hl.dsp.window.move({ monitor = \"+1\" })";
        flags.repeating = true;
      }
      {
        keys = "SUPER + SHIFT + N";
        dispatcher = "hl.dsp.window.move({ monitor = \"-1\" })";
        flags.repeating = true;
      }

      {
        keys = "XF86AudioMute";
        dispatcher = "hl.dsp.exec_cmd(\"${launchPrefix + volumectl} -p toggle-mute\")";
        flags.locked = true;
      }
      {
        keys = "XF86AudioMute";
        dispatcher = "hl.dsp.exec_cmd(\"${launchPrefix + volumectl} -p toggle-mute\")";
        flags.locked = true;
      }
      {
        keys = "XF86AudioMicMute";
        dispatcher = "hl.dsp.exec_cmd(\"${launchPrefix + volumectl} -m -p toggle-mute\")";
        flags.locked = true;
      }
      {
        keys = "XF86AudioNext";
        dispatcher = "hl.dsp.exec_cmd(\"${launchPrefix + playerctl} next\")";
        flags.locked = true;
      }
      {
        keys = "XF86AudioPrev";
        dispatcher = "hl.dsp.exec_cmd(\"${launchPrefix + playerctl} previous\")";
        flags.locked = true;
      }
      {
        keys = "XF86AudioPlay";
        dispatcher = "hl.dsp.exec_cmd(\"${launchPrefix + playerctl} play-pause\")";
        flags.locked = true;
      }
      {
        keys = "XF86AudioPause";
        dispatcher = "hl.dsp.exec_cmd(\"${launchPrefix + playerctl} play-pause\")";
        flags.locked = true;
      }

      {
        keys = "XF86AudioRaiseVolume";
        dispatcher = "hl.dsp.exec_cmd(\"${launchPrefix + volumectl} -p up\")";
        flags.locked = true;
        flags.repeating = true;
      }
      {
        keys = "XF86AudioLowerVolume";
        dispatcher = "hl.dsp.exec_cmd(\"${launchPrefix + volumectl} -p down\")";
        flags.locked = true;
        flags.repeating = true;
      }
      {
        keys = "XF86MonBrightnessUp";
        dispatcher = "hl.dsp.exec_cmd(\"${launchPrefix + brightnessctl} up\")";
        flags.locked = true;
        flags.repeating = true;
      }
      {
        keys = "XF86MonBrightnessDown";
        dispatcher = "hl.dsp.exec_cmd(\"${launchPrefix + brightnessctl} down\")";
        flags.locked = true;
        flags.repeating = true;
      }
    ];

  gesture = [
    {
      fingers = 3;
      direction = "horizontal";
      action = "workspace";
    }
  ];

  window_rule =
    let
      floatPreset = lib.recursiveUpdate {
        float = true;
        group = "deny";
        persistent_size = true;
        max_size = "monitor_w monitor_h-20";
      };
    in
    [
      {
        name = "group_non_float";
        match.float = false;
        group = "set";
      }
      {
        name = "deny_group_float";
        match.float = true;
        group = "deny";
      }
      {
        name = "round_float";
        match.float = true;
        rounding = 10;
      }

      {
        name = "disable_screenshare_classes";
        match.initial_class = "keepassxc|org\\.keepassxc\\.KeePassXC";
        no_screen_share = true;
      }

      (floatPreset {
        name = "float_classes";
        match.initial_class = lib.concatStringsSep "|" [
          "\\.blueman-.*"
          "blueman-.*"
          "com\\.saivert\\.pwvucontrol"
          "io\\.github\\.finefindus\\.Hieroglyphic"
          "nm-applet"
          "nm-connection-editor"
          "xdg-desktop-portal-gnome"
          "xdg-desktop-portal-gtk"
        ];
      })
      (floatPreset {
        name = "float_fileroller_popup";
        match.initial_class = "org\\.gnome\\.FileRoller";
        match.initial_title = lib.concatStringsSep "|" [
          "Extract"
          "Select App"
          ""
        ];
      })
      (floatPreset {
        name = "float_keepassxc_popups";
        match.initial_class = "keepassxc|org\\.keepassxc\\.KeePassXC";
        match.initial_title = lib.concatStringsSep "|" [
          "Generate Password"
          "KeePassXC -  Access Request"
          "Open .*"
          "Save attachments"
          "Select files"
        ];
      })
      (floatPreset {
        name = "float_mozilla_popup";
        match.initial_class = "firefox|thunderbird";
        match.initial_title = lib.concatStringsSep "|" [
          ""
          "About Mozilla (Firefox|Thunderbird)"
          "Add calendar"
          "Alert"
          "Authentication Required - Mozilla (Firefox|Thunderbird)"
          "Calendar Reminders"
          "Compact Folders"
          "Download Messages"
          "Edit Calendar"
          "Edit Item"
          "Library"
          "OpenPGP Key Manager"
          "Password Required - Mozilla (Firefox|Thunderbird)"
        ];
      })
      (floatPreset {
        name = "float_nautilus_popup";
        match.initial_class = "org\\.gnome\\.Nautilus";
        match.initial_title = lib.concatStringsSep "|" [
          "Open Directory"
        ];
      })
      (floatPreset {
        name = "float_share_popup";
        match.initial_class = "";
        match.initial_title = lib.concatStringsSep "|" [
          "Select what to share"
        ];
      })
      (floatPreset {
        name = "float_steam_popup";
        match.initial_class = "steam";
        match.initial_title = lib.concatStringsSep "|" [
          "Steam Settings"
          "Friends List"
        ];
      })

      {
        name = "no_border_classes";
        border_size = 0;
        match.initial_class = lib.concatStringsSep "|" [
          "vicinae"
        ];
      }

      {
        name = "pin_classes";
        border_size = 0;
        pin = true;
        group = "deny";
        match.initial_class = lib.concatStringsSep "|" [
          "dragon-drop"
          "xdragon"
        ];
      }

      {
        name = "pin_stay_focused_keepassxc_popups";
        pin = true;
        stay_focused = true;
        match.initial_class = "keepassxc|org\\.keepassxc\\.KeePassXC";
        match.initial_title = lib.concatStringsSep "|" [
          "KeePassXC -  Access Request"
          "KeePassXC - Browser Access Request"
          "KeePassXC - Passkey credentials"
          "Unlock Database - KeePassXC"
        ];
      }

      {
        name = "pin_stay_focused_open_with_popup";
        pin = true;
        stay_focused = true;
        match.initial_class = "xdg-desktop-portal-gnome";
        match.initial_title = lib.concatStringsSep "|" [
          "Open With"
        ];
      }
      {
        name = "pin_stay_focused_permission_request";
        pin = true;
        stay_focused = true;
        match.initial_class = "";
        match.initial_title = lib.concatStringsSep "|" [
          "Permission request"
        ];
      }

      {
        name = "stay_focused_classes";
        stay_focused = true;
        match.initial_class = lib.concatStringsSep "|" [
          "gcr-prompter"
          "gtk-ssh-askpass"
          "polkit-gnome-authentication-agent-1"
        ];
      }

      {
        name = "stay_focused_thunderbird_confirm";
        stay_focused = true;
        match.initial_class = "thunderbird";
        match.initial_title = lib.concatStringsSep "|" [
          "Confirm"
          "Confirm Deletion"
          "Delete Folder"
          "Link Properties"
          "Save Message"
          "Send Message"
        ];
      }

      {
        name = "supress_fullscreen_all";
        match.initial_class = ".*";
        suppress_event = lib.concatStringsSep " " [
          "fullscreen"
          "maximize"
        ];
      }

      {
        name = "no_gaps_when_only";
        border_size = 0;
        match.float = false;
        match.workspace = "w[tv1]";
      }
      {
        name = "no_gaps_when_max";
        border_size = 0;
        match.float = false;
        match.workspace = "f[1]";
      }
    ];

  layer_rule = [
    {
      name = "blur_popup";
      match.namespace = "avizo|vicinae|swaync-.*";
      blur = true;
      ignore_alpha = 0;
      xray = false;
    }
    {
      name = "abovelock_avizo";
      match.namespace = "avizo";
      above_lock = 1;
    }
    {
      name = "no_anim_selection";
      match.namespace = "selection";
      no_anim = true;
    }
  ];

  workspace_rule = [
    {
      workspace = "special:dropterm";
      on_created_empty = term_tmux_scratchpad;
    }
    {
      workspace = "special:pwm";
      on_created_empty = pwm;
    }
  ];

  permission = [
    {
      binary = grim;
      type = "screencopy";
      mode = "allow";
    }
    {
      binary = hyprpicker;
      type = "screencopy";
      mode = "allow";
    }
    (lib.mkIf config.programs.swaylock.enable {
      binary = lib.getExe config.programs.swaylock.package;
      type = "screencopy";
      mode = "allow";
    })
    {
      binary = "${config.wayland.windowManager.hyprland.portalPackage}/libexec/.xdg-desktop-portal-hyprland-wrapped";
      type = "screencopy";
      mode = "allow";
    }
  ];

  config = {
    animations.enabled = false;

    binds = {
      window_direction_monitor_fallback = false;
      workspace_back_and_forth = true;
    };

    debug = {
      disable_logs = false;
      enable_stdout_logs = true;
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

    ecosystem = {
      no_update_news = true;
      no_donation_nag = true;
      enforce_permissions = true;
    };

    general = {
      gaps_in = 1;
      gaps_out = {
        top = 0;
        right = 0;
        bottom = 1;
        left = 0;
      };
      border_size = 1;
      col = {
        active_border = "rgba(${base0F}aa)";
        nogroup_border = "rgba(${base04}aa)";
        inactive_border = "rgba(${base04}aa)";
        nogroup_border_active = "rgba(${base0F}aa)";
      };
      layout = "master";
      allow_tearing = false;
      snap.enabled = true;
    };

    gestures = {
      workspace_swipe_forever = true;
      workspace_swipe_use_r = true;
      workspace_swipe_create_new = false;
    };

    group = {
      col = {
        border_active = "rgba(${base0F}66)";
        border_inactive = "rgba(${base04}66)";
        border_locked_active = "rgba(${base0F}66)";
        border_locked_inactive = "rgba(${base04}66)";
      };
      groupbar = {
        disable_when_only = true;
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

        col.active = "rgb(${base0D})";
        font_weight_active = "bold";
        text_color = "rgb(${base01})";

        col.inactive = "rgb(${base00})";
        font_weight_inactive = "normal";
        text_color_inactive = "rgba(${base05}cc)";
      };
    };

    input = {
      kb_layout = "de,de";
      kb_variant = ",neo_qwertz";
      kb_options = "grp:alt_space_toggle";
      follow_mouse = 2;

      touchpad = {
        natural_scroll = true;
        tap_to_click = true;
      };

      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      repeat_rate = 30;
      repeat_delay = 400;
    };

    master = {
      new_status = "slave";
      new_on_top = true;
      mfact = 0.65;
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

    xwayland.force_zero_scaling = true;
  };
}
