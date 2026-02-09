{ config, lib, pkgs, ... }:

{
  home.shellAliases = let
    configDirectory = config.home.sessionVariables.NIX_CONFIG_DIR;
  in lib.mkMerge [
    rec {
      cat = lib.mkIf config.programs.bat.enable "${lib.getExe config.programs.bat.package} --paging=never";
      ls = "${lib.getExe pkgs.eza} -g --color=auto --git";
      ll = "${ls} -l --group-directories-first --icons=auto --time-style=long-iso";
      la = "${ll} -aa";
      lt = "${ll} --sort=newest";
      lta = "${la} --sort=newest";
      tree = "${ls} --tree";
      open = "${pkgs.writeShellScript "open" ''${lib.getExe' pkgs.xdg-utils "xdg-open"} "$@" &> /dev/null & builtin disown''}";
    }
    (lib.mkIf (!config.submoduleSupport.enable && config.programs.home-manager.enable) {
      hms = "home-manager switch --flake ${configDirectory}";
    })
    (lib.mkIf (config.nix.enable && config.submoduleSupport.enable) {
      nrs = "nixos-rebuild switch --flake ${configDirectory} --sudo";
      nrb = "nixos-rebuild boot --flake ${configDirectory} --sudo";
    })
    (lib.mkIf config.nix.enable {
      nd = "nix shell -c $SHELL";
      ns = "nix shell";
      nr = "nix repl --expr '{ inherit (import <nixpkgs> {}) pkgs lib; }'";
    })
  ];
}
