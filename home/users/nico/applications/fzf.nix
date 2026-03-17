{
  config,
  lib,
  pkgs,
  ...
}:

let
  bat = lib.getExe config.programs.bat.package;
  eza = lib.getExe pkgs.eza;
  fd = lib.getExe config.programs.fd.package;
  head = lib.getExe' pkgs.coreutils "head";
  zoxide = lib.getExe config.programs.zoxide.package;
in
{
  programs.fzf = {
    enable = true;
    colors = with config.colorScheme.palette; {
      "bg+" = "#${base03}";
      fg = "#${base05}";
      "fg+" = "#${base05}";
      header = "#${base08}";
      hl = "#${base08}";
      "hl+" = "#${base08}";
      info = "#${base0E}";
      marker = "#${base06}";
      pointer = "#${base06}";
      prompt = "#${base0E}";
      spinner = "#${base06}";
    };
    defaultCommand = "${fd} -IL";
    defaultOptions = [
      "--height 60%"
      "--border"
      "--layout=reverse"
      "--no-sort"
    ]
    ++ lib.optional config.programs.tmux.enable "--tmux bottom,75%,60%";
    # ALT-C Options
    changeDirWidgetCommand = "${fd} -IL -t d -E .cache && ${zoxide} query --list";
    changeDirWidgetOptions = [
      "--preview '${eza} --color=always --follow-symlinks --tree {}'"
    ];
    # CTRL-T Options
    fileWidgetCommand = "${fd} -IL -t f";
    fileWidgetOptions = [
      "--preview '(${bat} --paging=never --color=always {} || ${eza} --color=always --follow-symlinks --tree {}) 2> /dev/null | ${head} -200'"
    ];
    # CTRL-R Options
    historyWidgetOptions = [
    ];
  };
}
