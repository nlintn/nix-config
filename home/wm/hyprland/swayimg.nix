{ pkgs, ... }:

{
  home.packages = [ pkgs.swayimg ];

  xdg.configFile."swayimg/config".text = ''
    [general]
    transparency=none
    [info]
    mode=off
  '';
}
