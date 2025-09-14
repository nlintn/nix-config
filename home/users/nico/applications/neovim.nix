{ config, lib, pkgs, nvim-config, ... }:

let
  pkg = nvim-config.packages.${pkgs.system}.nvim.override {
    base16-palette = config.colorScheme.palette;
  };
  bin = lib.getExe pkg;
in {
  home.sessionVariables = rec {
    NVIM = bin;
    EDITOR = NVIM;
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
