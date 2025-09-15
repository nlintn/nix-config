{ lib, ... }:

{
  home.sessionVariables = {
    X11_SUPPORT = "1";
    WAYLAND_SUPPORT = lib.mkDefault "0";
  };
}
