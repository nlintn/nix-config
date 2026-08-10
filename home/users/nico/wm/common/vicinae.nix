{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}:

let
  webSearchSctId = "sct-websearch";
in
{
  programs.vicinae = {
    enable = true;
    systemd.enable = true;
    useLayerShell = true;

    extensions = with pkgs.vicinaeExtensions; [
      bluetooth
      color-converter
      firefox
      nerdfont-search
      nix
      player-pilot
    ];

    settings = {
      close_on_focus_loss = true;
      pop_to_root_on_close = false;
      favicon_service = "twenty";
      search_files_in_root = true;
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
      telemetry.system_info = false;
      launcher_window = {
        opacity = 0.75;
        client_side_decorations = {
          enabled = true;
          rounding = 10;
          border_width = 2;
        };
        compact_mode.enabled = true;
        layer_shell = {
          enabled = true;
          scope = "vicinae";
          keyboard_interactivity = "on_demand";
          layer = "top";
        };
      };
      fallbacks = [
        "shortcuts:${webSearchSctId}"
        "files:search"
      ];
      providers = {
        "@Gelei/vicinae-extension-bluetooth-unstable" = {
          preferences.connectionToggleable = true;
        };
        "@knoopx/vicinae-extension-firefox-0" = {
          preferences.profile_dir = config.programs.firefox.configPath;
        };
        applications = {
          preferences = {
            defaultAction = "launch";
            launchPrefix = config.vars.launchPrefix;
          };
        };
        core = {
          entrypoints = {
            forget-telemetry.enabled = true;
            inspect-local-storage.enabled = true;
            sponsor.enabled = false;
          };
        };
        files.preferences = {
          autoIndexing = true;
          excludedIndexingPaths = [ config.xdg.cacheHome ];
          indexingPaths = [ config.home.homeDirectory ];
        };
        system.entrypoints.browse-apps.enabled = true;
        theme.entrypoints.set.enabled = false;
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
  xdg.dataFile."vicinae/shortcuts/shortcuts.json" = {
    force = true;
    text = lib.toJSON [
      {
        id = webSearchSctId;
        name = "Search with DuckDuckGo";
        icon = "icon://favicon/duckduckgo.com?fallback=icon://omnicast/image?fill%3Dprimary-text";
        url = "https://duckduckgo.com/?q={argument}";
        app = "firefox.desktop";
        openCount = 0;
        createdAt = 0;
        updatedAt = 0;
      }
    ];
  };
}
