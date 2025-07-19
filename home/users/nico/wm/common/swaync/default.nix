{ config, userSettings, ... }:

{
  services.swaync = {
    enable = true;
    style = import ./theme.nix { inherit config userSettings; };
  };
}
