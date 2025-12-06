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
      closeOnFocusLoss = true;
      faviconService = "twenty";
      font = {
        normal = userSettings.default-font.name;
        size = 10;
      };
      popToRootOnClose = false;
      theme = {
        iconTheme = config.gtk.iconTheme.name;
        name = "base16";
      };
      window = {
        csd = true;
        opacity = 0.75;
        rounding = 10;
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
}
