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
    localVariables = lib.mkMerge [
      {
        _cmd_base64 = lib.getExe' pkgs.coreutils "base64";
        _cmd_bat = lib.getExe config.programs.bat.package;
        _cmd_eza = lib.getExe pkgs.eza;
        _cmd_head = lib.getExe' pkgs.coreutils "head";
      }
      (lib.mapAttrs' (n: v: lib.nameValuePair "_col_${n}" v) config.colorScheme.palette)
    ];
    initContent = lib.readFile ./init.zsh;
    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
    ];
  };
}
