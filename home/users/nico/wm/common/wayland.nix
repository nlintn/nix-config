{ lib, ... }:

{
  home.sessionVariables = {
    ONLY_WAYLAND_SESSIONS = lib.mkDefault "1";

    CLUTTER_BACKEND = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    GDK_BACKEND = "wayland";
    NIXOS_OZONE_WL = "1";
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
  };
}
