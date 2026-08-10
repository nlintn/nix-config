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
    completionInit =
      let
        dir = "${config.xdg.cacheHome}/zsh";
      in
      "mkdir -p ${dir} && autoload -U compinit && compinit -d ${dir}/zcompdump";
    history = {
      append = true;
      extended = true;
      path = "${config.xdg.stateHome}/zsh/history";
      share = false;
    };
    syntaxHighlighting = {
      enable = true;
      highlighters = [
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
