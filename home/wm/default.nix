{ userSettings, ... }:

let 
  wmConfig = {
    "" = [];
    "hyprland" = [ ./hyprland ];
  };
in {
  imports = wmConfig.${userSettings.wm};
}