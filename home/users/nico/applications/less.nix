{ pkgs, ... }:

{
  programs.less = {
    enable = true;
    options = {
      ignore-case = true;
      RAW-CONTROL-CHARS = true;
    };
    package =
      let
        pkg = pkgs.less;
      in
      pkgs.symlinkJoin {
        inherit (pkg) name meta outputs;
        paths = [ pkg ];
        nativeBuildInputs = [
          pkgs.makeWrapper
          pkgs.lndir
        ];
        postBuild =
          let
            reset = "\\e[00m";
            black = "\\e[30m";
            bg_magenta = "\\e[45m";
          in
          /* sh */ ''
            wrapProgram $out/bin/less \
              --set LESS_TERMCAP_so $'${black + bg_magenta}' \
              --set LESS_TERMCAP_se $'${reset}' \

            # necessary to preserve additional man output derivation
            mkdir $man
            lndir -silent ${pkg.man} $man
          '';
      };
  };
}
