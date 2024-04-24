{ pkgs, config, inputs, userSettings, ... }:

{
  programs.waybar = {
    enable = true;
    style = import ./style.nix { inherit config inputs userSettings; };
  };
  xdg.configFile."waybar/config".text = import ./config.nix { inherit pkgs config; };
}
