{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}@args:

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
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-${config.colorScheme.variant}";
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
  xdg.configFile =
    let
      src = import ./gtk.css.nix args;
    in
    {
      "gtk-4.0/gtk.css".text = lib.mkForce src;
      "gtk-4.0/gtk-dark.css".text = lib.mkForce src;
      "gtk-3.0/gtk.css".text = src;
      "gtk-3.0/gtk-dark.css".text = src;
    };

  home.sessionVariables.GTK_THEME = lib.mkIf config.gtk.enable config.gtk.theme.name;

  dconf.settings = {
    "org/gnome/desktop/wm/preferences".button-layout = "";
    "org/gnome/desktop/interface".color-scheme = "prefer-${config.colorScheme.variant}";
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };
}
