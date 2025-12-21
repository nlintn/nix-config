{ lib, pkgs, ... }:

{
  vars = {
    waylandSupport = true;
    x11Support = lib.mkDefault false;
  };

  home.sessionVariables = {
    CLUTTER_BACKEND = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    GDK_BACKEND = "wayland";
    NIXOS_OZONE_WL = "1";
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
  };
  home.packages = with pkgs; [
    wl-mirror
    wlr-randr
  ];
}
