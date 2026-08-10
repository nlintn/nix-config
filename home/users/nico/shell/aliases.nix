{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.shellAliases =
    let
      bat = lib.getExe config.programs.bat.package;
      eza = lib.getExe pkgs.eza;
      nix = lib.getExe config.nix.package;
    in
    lib.mkMerge [
      rec {
        cat = lib.mkIf config.programs.bat.enable "${bat} --paging=never";
        la = "${ll} -aa";
        ll = "${ls} -l --group-directories-first --icons=auto --time-style=long-iso";
        ls = "${eza} -g --color=auto --git";
        lt = "${ll} --sort=newest";
        lta = "${la} --sort=newest";
        open = "${lib.getExe' pkgs.xdg-utils "xdg-open"}";
        tree = "${ls} --tree";
      }
      (lib.mkIf config.nix.enable {
        nd = "${nix} shell -c $SHELL";
        nr = "${nix} repl --expr '{ inherit (import <nixpkgs> {}) pkgs lib; }'";
        ns = "${nix} shell";
      })
    ];
}
