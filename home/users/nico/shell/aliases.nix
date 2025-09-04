{ config, lib, pkgs, ... }:

{
  home.shellAliases = let
    configDirectory = config.home.sessionVariables.NIX_CONFIG_DIR;
  in lib.mkMerge [
    rec {
      c = "${pkgs.ncurses}/bin/clear";
      cat = lib.mkIf config.programs.bat.enable "${config.programs.bat.package}/bin/bat --paging=never";
      confdir = "builtin cd -- ${configDirectory}";
      ls = "${lib.getExe pkgs.eza} -g --color=auto --git";
      ll = "${ls} -l --group-directories-first --icons=auto --time-style=long-iso";
      la = "${ll} -a";
      lt = "${ll} --sort=newest";
      open = "${pkgs.xdg-utils}/bin/xdg-open";
      xx = "${pkgs.writeShellScript "xx" "$@ >/dev/null >&1 2>&1 & builtin disown"}";
      xopen = "${pkgs.writeShellScript "xopen" ''${open} "$@" & builtin disown''}";
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

  home.packages = with pkgs; [
    eza
  ];
}
