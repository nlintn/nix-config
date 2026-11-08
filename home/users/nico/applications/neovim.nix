{
  config,
  lib,
  pkgs,
  ...
}:

let
  pkg = pkgs.nvim-custom.override {
    base16-palette = config.colorScheme.palette;
  };
  bin = lib.getExe pkg;
  name = lib.baseNameOf bin;
in
{
  vars.nvimPackage = pkg;
  home.sessionVariables = {
    EDITOR = name;
    VISUAL = name;
    MANPAGER = "${name} +Man!";
  };
  home.shellAliases.vimdiff = "${bin} -d";
  home.packages = [ pkg ];

  programs.neovide = {
    enable = true;
    settings = {
      neovim-bin = bin;
    };
  };
}
