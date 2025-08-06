{ pkgs, ... } @ args: # `pkgs` needed because otherwise not in `args`

{
  programs.waybar = {
    enable = true;
    style = import ./style.nix args;
    systemd.enable = true;
  };
  xdg.configFile."waybar/config".text = import ./config.nix args;
}
