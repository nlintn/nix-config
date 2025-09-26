{ config, pkgs, ... }:

builtins.toPath (pkgs.writeText "theme-final.rasi" (
  with config.colorScheme.palette; ''
    * {
      bg0:    #${base00}5f;
      bg1:    #${base04}80;
      bg2:    #${base0E}8f;
      bg3:    #${base01}5f;

      fg0:    #${base05};
      fg1:    #${base05};
      fg2:    #${base04};
    }
  '' + builtins.readFile ./theme.rasi))
