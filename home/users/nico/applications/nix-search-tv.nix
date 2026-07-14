{
  config,
  lib,
  pkgs,
  ...
}:

let
  nix-search-tv = lib.getExe config.programs.nix-search-tv.package;
  fzf = lib.getExe config.programs.fzf.package;
in
{
  programs.nix-search-tv = {
    enable = true;
    settings = {
      indexes = [
        "home-manager"
        "nixos"
        "nixpkgs"
        "noogle"
      ];
    };
  };

  home.packages = [
    (pkgs.writeScriptBin "nix-search" /* sh */ ''
      ${nix-search-tv} print \
        | env TMUX="" ${fzf} --border-label  ' nix-search-tv ' --exact --height 100% --preview '${nix-search-tv} preview {}' --scheme history
    '')
  ];
}
