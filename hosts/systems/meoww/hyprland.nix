{ config, ... }:

{
  programs.hyprland = {
    enable = true;
  };
  security.pam.services."hyprlock" = {
    enable = true;
    enableGnomeKeyring = config.services.gnome.gnome-keyring.enable;
  };
}
