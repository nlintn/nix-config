{ lib, userSettings, ... }:

let
  wmConfig = {
    "hyprland" = [ ./hyprland ];
    "none" = [ ];
  };
in
{
  imports =
    wmConfig.${userSettings.wm} or (lib.warn "Unsupported window manager: ${userSettings.wm}" [ ]);
}
