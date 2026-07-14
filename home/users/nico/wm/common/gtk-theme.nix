{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}:

{
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 20;
  };

  gtk = {
    enable = true;
    theme =
      let
        accent = "catppuccin";
        size = "compact";
        tweaks = [
          accent
          "rimless"
        ];
        variant = "purple";
      in
      {
        package = (
          pkgs.colloid-gtk-theme.override {
            themeVariants = [ variant ];
            colorVariants = [ config.colorScheme.variant ];
            sizeVariants = [ size ];
            inherit tweaks;
          }
        );
        name = "Colloid-${lib.toSentenceCase variant}-${lib.toSentenceCase config.colorScheme.variant}-${lib.toSentenceCase size}-${lib.toSentenceCase accent}";
      };
    gtk4.theme = config.gtk.theme;

    iconTheme = {
      package = pkgs.kora-icon-theme;
      name = "kora";
    };

    font = {
      package = userSettings.default-font.package;
      name = userSettings.default-font.name;
      size = 10;
    };
  };
  xdg.configFile = lib.mkIf (config.gtk.gtk4.theme != null) {
    "gtk-4.0/assets".source =
      "${config.gtk.gtk4.theme.package}/share/themes/${config.gtk.gtk4.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source =
      "${config.gtk.gtk4.theme.package}/share/themes/${config.gtk.gtk4.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source =
      "${config.gtk.gtk4.theme.package}/share/themes/${config.gtk.gtk4.theme.name}/gtk-4.0/gtk-dark.css";
  };

  dconf.settings = {
    "org/gnome/desktop/wm/preferences".button-layout = "";
    "org/gnome/desktop/interface".color-scheme = "prefer-${config.colorScheme.variant}";
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };
}
