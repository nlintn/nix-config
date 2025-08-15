{ config, pkgs, lib', userSettings, ... }:

{
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
      package = (pkgs.colloid-gtk-theme.override { colorVariants = [ config.colorScheme.variant ]; sizeVariants = [ "compact" ]; tweaks = [ "nord" "rimless" ]; });
      name = "Colloid-${lib'.capitalizeString config.colorScheme.variant}-Compact-Nord";
    };
  
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
  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
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
