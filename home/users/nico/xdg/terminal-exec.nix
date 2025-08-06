{ config, lib, pkgs, ... }:

{
  home.packages = [ pkgs.xdg-terminal-exec ];

  xdg.configFile."xdg-terminals.list".text = lib.concatLines [
    (lib.optionalString config.programs.kitty.enable "kitty.desktop")
  ];
}
