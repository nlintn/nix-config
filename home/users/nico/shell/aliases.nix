{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}:

{
  home.shellAliases =
    let
      bat = lib.getExe config.programs.bat.package;
      configDirectory = config.home.sessionVariables.NIX_CONFIG_DIR;
      eza = lib.getExe pkgs.eza;
      home-manager = lib.getExe config.programs.home-manager.package;
      nix = lib.getExe config.nix.package;
      nixos-rebuild = lib.getExe osConfig.system.build.nixos-rebuild;
    in
    lib.mkMerge [
      rec {
        cat = lib.mkIf config.programs.bat.enable "${bat} --paging=never";
        la = "${ll} -aa";
        ll = "${ls} -l --group-directories-first --icons=auto --time-style=long-iso";
        ls = "${eza} -g --color=auto --git";
        lt = "${ll} --sort=newest";
        lta = "${la} --sort=newest";
        open = "${pkgs.writeShellScript "open" "${lib.getExe' pkgs.xdg-utils "xdg-open"} \"$@\" &> /dev/null & builtin disown"}";
        tree = "${ls} --tree";
      }
      (lib.mkIf (!config.submoduleSupport.enable && config.programs.home-manager.enable) {
        hms = "${home-manager} switch --flake ${configDirectory}";
      })
      (lib.mkIf (osConfig.system.tools.nixos-rebuild.enable or false && config.submoduleSupport.enable) {
        nrb = "${nixos-rebuild} boot --flake ${configDirectory} --sudo";
        nrs = "${nixos-rebuild} switch --flake ${configDirectory} --sudo";
      })
      (lib.mkIf config.nix.enable {
        nd = "${nix} shell -c $SHELL";
        nr = "${nix} repl --expr '{ inherit (import <nixpkgs> {}) pkgs lib; }'";
        ns = "${nix} shell";
      })
    ];
}
