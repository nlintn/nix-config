{ config, pkgs, lib, inputs, userSettings, ... }:


let
  evalBind = mainMod: modifiers: bind: (
    mainMod + (
      if (lib.foldl (acc: mod: acc || (lib.hasPrefix mod bind)) false modifiers) then " " else ", "
    ) + bind
  );
in {
  home.packages = with pkgs; [
    grim
    slurp
    gwenview
    swaynotificationcenter
    xdg-utils
    networkmanagerapplet
    pavucontrol
    polkit_gnome
  ] ++ (with pkgs.gnome; [
    nautilus
    eog
    gnome-keyring
  ]);

  /*home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };
  
  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };
  
    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };
  
    font = {
      name = "Sans";
      size = 11;
    };#
  };*/

  qt = {
    enable = true;
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
    platformTheme = "qtct";
  };

  imports =  [
    ./hyprland/waybar.nix
  ];

  programs.rofi.enable = true;
  programs.rofi.terminal = "${pkgs.alacritty}/bin/alacritty";
  programs.rofi.package = pkgs.rofi-wayland;
  programs.rofi.theme = inputs.catppuccin-rofi + "/basic/.local/share/rofi/themes/catppuccin-${userSettings.catppuccin-flavour}.rasi";
  programs.rofi.extraConfig = {
    modi = "run,drun";
    icon-theme = "Oranchelo";
    show-icons = true;
    drun-display-format = "{icon} {name}";
    location = 0;
    disable-history = false;
    hide-scrollbar = true;
    display-drun = "   Apps ";
    display-run = "   Run ";
    display-window = " 﩯  Window";
    display-Network = " 󰤨  Network";
    sidebar-mode = true;
  };

  # programs.swaylock.enable = true;
  # programs.swaylock.settings = inputs.catppuccin-swaylock + "/themes/${userSettings.catppuccin-flavour}.conf";

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    settings = {
      "$terminal" =     "${pkgs.alacritty}/bin/alacritty";
      "$fileManager" =  "${pkgs.gnome.nautilus}/bin/nautilus";
      "$menu" =         "${pkgs.rofi-wayland}/bin/rofi -show drun";
      "$windows" =      "${./hyprland/scripts/windows.sh}";

      /*env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"

        # GDK_BACKEND,wayland
        "QT_QPA_PLATFORM,wayland"
        "QT_QPA_PLATFORMTHEME,qt5ct" #env = QT_STYLE_OVERRIDE,kvantum
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"

        "SDL_VIDEODRIVER,wayland"
        "_JAVA_AWT_WM_NONREPARENTING,1"
        "WLR_NO_HARDWARE_CURSORS,1"

        "MOZ_DISABLE_RDD_SANDBOX,1"
        "MOZ_ENABLE_WAYLAND,1"

        "OZONE_PLATFORM,wayland"

        "XCURSOR_SIZE,24"
      ];*/

      exec-once = [
        "${pkgs.swaynotificationcenter}/bin/swaync"
        "${pkgs.waybar}/bin/waybar"
      ];

      monitor = [
        "eDP-1, 2560x1440, 0x0, 1.5"
        ", preferred, auto, 1"
      ];
      "debug:disable_scale_checks" = true;

      workspace = [
        "eDP-1, 1"
        ",6"
        "1, monitor:eDP-1"
        "2, monitor:eDP-1"
        "3, monitor:eDP-1"
        "4, monitor:eDP-1"
        "5, monitor:eDP-1"
      ];

      bind = builtins.map (evalBind "SUPER" [ "SHIFT" ]) [
        "SHIFT, A, exec, ${./hyprland/scripts/captureArea.sh}"
        "Q, exec, $terminal"
        "C, killactive,"
        "SHIFT, M, exit,"
        "E, exec, $fileManager"
        "V, togglefloating,"
        "R, exec, $menu"
        "P, pseudo,"# dwindle
        "J, togglesplit,"# dwindle
        "tab, exec, $windows"

        "left, movefocus, l"
        "right, movefocus, r"
        "up, movefocus, u"
        "down, movefocus, d"
        "SHIFT, left, movewindow, l"
        "SHIFT, right, movewindow, r"
        "SHIFT, up, movewindow, u"
        "SHIFT, down, movewindow, d"


        "1, workspace, 1"
        "2, workspace, 2"
        "3, workspace, 3"
        "4, workspace, 4"
        "5, workspace, 5"
        "6, workspace, 6"
        "7, workspace, 7"
        "8, workspace, 8"
        "9, workspace, 9"
        "0, workspace, 10"
        
        "SHIFT, 1, movetoworkspace, 1"
        "SHIFT, 2, movetoworkspace, 2"
        "SHIFT, 3, movetoworkspace, 3"
        "SHIFT, 4, movetoworkspace, 4"
        "SHIFT, 5, movetoworkspace, 5"
        "SHIFT, 6, movetoworkspace, 6"
        "SHIFT, 7, movetoworkspace, 7"
        "SHIFT, 8, movetoworkspace, 8"
        "SHIFT, 9, movetoworkspace, 9"
        "SHIFT, 0, movetoworkspace, 10"

        "S, togglespecialworkspace, magic"
        "SHIFT, S, movetoworkspace, special:magic"

        "mouse_down, workspace, e+1"
        "mouse_up, workspace, e-1"

        "F, fullscreen, 0"
        "SHIFT, F, fullscreen, 1"
      ];

      bindm = builtins.map (evalBind "SUPER" []) [
        "mouse:272, movewindow"
        "mouse:273, resizewindow"
      ];

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
      };

      misc = {
        force_default_wallpaper = 3;
      };

      general = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          gaps_in = 5;
          gaps_out = 15;
          border_size = 1;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";

          layout = "dwindle";

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false;
      };

      decoration = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          rounding = 10;

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

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

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
      };

      windowrulev2 = "nomaximizerequest, class:.*"; # You'll probably like this.
    };
  };
}
