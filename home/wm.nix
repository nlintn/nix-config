{ userSettings, ... }:

let 
  wmConfig = {
    "" = [];
    "hyprland" = [ ./wm/hyprland.nix ];
  };
in {
  imports = wmConfig.${userSettings.wm};
}