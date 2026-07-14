{
  config,
  lib,
  pkgs,
  ...
}@args:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=#${config.colorScheme.palette.base04}";
      strategy = [
        "history"
        "completion"
      ];
    };
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "cursor"
        "brackets"
      ];
      styles = import ./zsh-syntax-highlighting-base16.nix args;
    };
    setOptions = [
      "globdots"
    ];
    localVariables = {
      _cmd_base64 = lib.getExe' pkgs.coreutils "base64";
    };
    initContent = import ./init args;
    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
    ];
  };
}
