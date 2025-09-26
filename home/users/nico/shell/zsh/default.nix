{ config, pkgs, ... } @ args:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=#${config.colorScheme.palette.base04}";
      strategy = [ "history" "completion" ];
    };
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "cursor" "brackets" ];
      styles = import ./zsh-syntax-highlighting-base16.nix args;
    };
    initContent = pkgs.callPackage ./init.nix {};
  };
}
