{
  config,
  ...
}:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  security.pam.services."swaylock" = {
    enable = true;
    enableGnomeKeyring = config.services.gnome.gnome-keyring.enable;
  };
}
