{ config, lib, pkgs,  ... }:

{
  imports = [
    ./zsh.nix
  ];

  home.shellAliases = let
    configDirectory = config.home.sessionVariables.NIX_CONFIG_DIR;
  in rec {
    c = "${pkgs.ncurses}/bin/clear";
    cat = lib.mkIf config.programs.bat.enable "${config.programs.bat.package}/bin/bat --paging=never";
    confdir = "builtin cd -- ${configDirectory}";
    open = "${pkgs.xdg-utils}/bin/xdg-open";
    xx = "${pkgs.writeShellScript "xx" "$@ >/dev/null >&1 2>&1 & builtin disown"}";
    xopen = "${pkgs.writeShellScript "xopen" ''${open} "$@" & builtin disown''}";
    lt = "ls -ltr";
  } // lib.optionalAttrs (!config.submoduleSupport.enable && config.programs.home-manager.enable) {
    hms = "home-manager switch --flake ${configDirectory}";
  } // lib.optionalAttrs (config.nix.enable && config.submoduleSupport.enable) {
    nrs = "nixos-rebuild switch --flake ${configDirectory} --sudo";
    nrb = "nixos-rebuild boot --flake ${configDirectory} --sudo";
  } // lib.optionalAttrs config.nix.enable {
    nd = "nix shell -c $SHELL";
    ns = "nix shell";
    nr = "nix repl --expr 'let pkgs = import <nixpkgs> {}; in { inherit pkgs; lib = pkgs.lib; }'";
  };

  programs.bash.enable = true;
}
