{
  pkgs,
  ...
}@args:

{
  programs.waybar = {
    enable = true;
    style = import ./style.nix args;
    systemd.enable = true;
  };
  xdg.configFile."waybar/config".source = pkgs.callPackage ./config.nix args;
}
