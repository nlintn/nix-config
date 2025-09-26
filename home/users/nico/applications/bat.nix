{ config, lib, pkgs, ... } @ args:

{
  programs.bat = {
    enable = true;
    package = let
      pkg = pkgs.bat;
    in pkgs.symlinkJoin {
      inherit (pkg) name meta;
      paths = [ pkg ];
      postBuild = ''
        sed -i 's/\/nix\/store\/.*-less-.*\/bin/${lib.makeBinPath [ config.programs.less.package ] |>
          lib.escapeRegex |> lib.escape [ "/" ]}/' $out/bin/bat
      '';
    };
    config = {
      theme = "base16";
      paging = "always";
    };
    themes = {
      "base16".src = import ./tm-theme.nix args;
    };
  };
}
