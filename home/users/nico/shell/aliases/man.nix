{ config, pkgs, ... }:

let
  pkg = config.programs.man.package;
in "${
  pkgs.symlinkJoin {
    name = pkg.name;
    paths = [ pkg ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = let
      reset      = "\\e[00m";
      bold       = "\\e[01m";
      black      = "\\e[30m";
      red        = "\\e[31m";
      green      = "\\e[32m";
      bg_magenta = "\\e[45m";
    in /* sh */ ''
      wrapProgram $out/bin/man \
        --set LESS_TERMCAP_mb $'${bold + red}' \
        --set LESS_TERMCAP_md $'${bold + red}' \
        --set LESS_TERMCAP_me $'${reset}' \
        --set LESS_TERMCAP_so $'${bold + black + bg_magenta}' \
        --set LESS_TERMCAP_se $'${reset}' \
        --set LESS_TERMCAP_us $'${bold + green}' \
        --set LESS_TERMCAP_ue $'${reset}' \
        --set GROFF_NO_SGR "1"
    '';
  }}/bin/man"
