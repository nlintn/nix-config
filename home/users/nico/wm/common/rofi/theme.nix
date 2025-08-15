{ config, pkgs, ... }:

builtins.toPath (pkgs.writeText "theme-final.rasi" (
  with config.colorScheme.palette; ''
    * {
      bg0:    #${base00}E6;
      bg1:    #${base04}80;
      bg2:    #${base0E}E6;

      fg0:    #${base05};
      fg1:    #${if config.colorScheme.variant == "dark" then "FFFFFF" else "000000"};
      fg2:    #${base05}80;
    }
  '' + builtins.readFile ./theme.rasi))
