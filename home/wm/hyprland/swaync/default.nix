{ pkgs, config, ... }:

{
  home.packages = [ pkgs.swaynotificationcenter ];

  xdg.configFile."swaync/style.css".text = import ./theme.nix { inherit config; };
}
