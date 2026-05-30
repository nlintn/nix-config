{
  config,
  ...
}:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  security.pam.services."hyprlock" = {
    enable = true;
    enableGnomeKeyring = config.services.gnome.gnome-keyring.enable;
  };
}
