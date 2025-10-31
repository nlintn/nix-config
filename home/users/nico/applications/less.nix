{ pkgs, ... }:

{
  programs.less = {
    enable = true;
    package = let
      pkg = pkgs.less;
    in pkgs.symlinkJoin {
      inherit (pkg) name;
      meta.mainProgram = pkg.meta.mainProgram;
      paths = [ pkg ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = let
        reset      = "\\e[00m";
        bold       = "\\e[01m";
        black      = "\\e[30m";
        red        = "\\e[31m";
        green      = "\\e[32m";
        grey       = "\\e[90m";
        bg_magenta = "\\e[45m";
      in /* sh */ ''
        wrapProgram $out/bin/less \
          --set LESS_TERMCAP_mb $'${bold + red}' \
          --set LESS_TERMCAP_md $'${grey}' \
          --set LESS_TERMCAP_me $'${reset}' \
          --set LESS_TERMCAP_so $'${black + bg_magenta}' \
          --set LESS_TERMCAP_se $'${reset}' \
          --set LESS_TERMCAP_us $'${bold + green}' \
          --set LESS_TERMCAP_ue $'${reset}' \
      '';
    };
  };
}
