{ config, pkgs, userSettings, ... }:

{
  programs.vicinae = {
    enable = true;
    systemd.enable = true;
    useLayerShell = true;

    extensions = with pkgs.vicinaeExtensions; [
      bluetooth
      firefox
      nix
    ];

    settings = {
      close_on_focus_loss = true;
      search_files_in_root = true;
      pop_to_root_on_close = false;
      favicon_service = "twenty";
      font = {
        normal = {
          family = userSettings.default-font.name;
          size = 10;
        };
      };
      theme = {
        dark = {
          name = "base16";
          icon_theme = config.gtk.iconTheme.name;
        };
        light = {
          name = "base16";
          icon_theme = config.gtk.iconTheme.name;
        };
      };
      launcher_window = {
        opacity = 0.75;
        client_side_decorations = {
          enabled = true;
          rounding = 10;
          border_width = 2;
        };
        layer_shell = {
          enabled = true;
          scope = "vicinae";
          keyboard_interactivity = "on_demand";
          layer = "top";
        };
      };
      providers = {
        "@Gelei/bluetooth-0" = {
          preferences = {
            connectionToggleable = true;
          };
        };
        core = {
          entrypoints = {
            inspect-local-storage.enabled = true;
            sponsor.enabled = false;
          };
        };
      };
    };

    themes = {
      base16 = {
        meta = {
          version = 1;
          name = "base16";
          description = "base16";
          variant = config.colorScheme.variant;
          inherits = "vicinae-${config.colorScheme.variant}";
        };

        colors = with config.colorScheme.palette; {
          core = {
            background = "#${base00}";
            foreground = "#${base05}";
            accent_foreground = "#${base01}";
            secondary_background = "#${base01}";
            border = "#${base02}";
            accent = "#${base0E}";
          };
          accents = {
            blue = "#${base0D}";
            green = "#${base0B}";
            magenta = "#${base07}";
            orange = "#${base09}";
            purple = "#${base0E}";
            red = "#${base08}";
            yellow = "#${base0A}";
            cyan = "#${base0C}";
          };
          list.item = {
            hover.background = "#${base02}";
            selection.background = "#${base02}";
          };
          scrollbars.background = "#${base03}";
          loading = {
            bar = "#${base04}";
            spinner = "#${base04}";
          };
        };
      };
    };
  };
  # xdg.configFile."vicinae/settings.json".force = true;
}
