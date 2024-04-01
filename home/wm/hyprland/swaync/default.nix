{ userSettings, ... }:

{
  xdg.configFile."swaync/style.css".source = ./. + "/${userSettings.catppuccin-flavour}.css";  
}
