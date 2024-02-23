{ userSettings, ... }:

let 
  wmConfig = {
    "" = [];
    "hyprland" = [ import ./wm/hyprland.nix ];
  };
in {
  imports = wmConfig.${userSettings.wm};
}