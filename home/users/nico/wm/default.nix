{ userSettings, ... }:

let
  wmConfig = {
    "hyprland" = [ ./hyprland ];
    "none" = [ ];
  };
in
{
  imports =
    wmConfig.${userSettings.wm} or (builtins.warn "Unsupported window manager: ${userSettings.wm}" [ ]);
}
