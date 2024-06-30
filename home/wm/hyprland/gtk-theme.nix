{ pkgs, lib, config, userSettings, ...}:

let
  capitalize = str: (
    (lib.toUpper (lib.substring 0 1 str))
    +
    (lib.substring 1 ((lib.stringLength str) - 1) str)
  );
  gtk-catppuccin-theme = (
    pkgs.catppuccin-gtk.override {
      accents = [ "mauve" ];
      size = "compact";
      tweaks = [ "rimless" ];
      variant = userSettings.catppuccin-flavour;
    }
  );
in {
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 20;
  };

  gtk = {
    enable = true;
    theme = {
      package = (pkgs.colloid-gtk-theme.override { themeVariants = [ "purple" ]; colorVariants = [ config.colorScheme.variant ]; sizeVariants = [ "compact" ]; tweaks = [ "nord" "rimless" ]; });
      name = "Colloid-Purple-${capitalize config.colorScheme.variant}-Compact-Nord";
    };
  
    iconTheme = {
      package = pkgs.kora-icon-theme;
      name = "kora";
    };
  
    font = {
      name = userSettings.default-font;
      size = 10;
    };
  };
  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "";
    };
  };
}
