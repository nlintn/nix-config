{ config, lib, pkgs, ... }:

{
  xdg.terminal-exec = {
    enable = true;
    settings = {
      "*" = [
        (lib.optionalString config.programs.ghostty.enable "ghostty.desktop")
        (lib.optionalString config.programs.kitty.enable "kitty.desktop")
      ];
    };
  };
  # home.packages = [ pkgs.xdg-terminal-exec ];
  #
  # xdg.configFile."xdg-terminals.list".text = lib.concatLines [
  #   (lib.optionalString config.programs.kitty.enable "kitty.desktop")
  # ];
}
