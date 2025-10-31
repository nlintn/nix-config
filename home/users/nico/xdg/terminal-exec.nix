{ config, lib, ... }:

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
}
