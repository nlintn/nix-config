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
      hl = "-1:reverse:bold";
      "hl+" = "-1:reverse:bold";
      info = "#${base0E}";
      marker = "#${base06}";
      pointer = "#${base06}";
      prompt = "#${base0E}";
      spinner = "#${base06}";
    };
    defaultCommand = "${fd} -IL";
    defaultOptions = [
      "--border=rounded"
      "--cycle"
      "--height 60%"
      "--layout=reverse"
      "--no-sort"
    ]
    ++ lib.optional config.programs.tmux.enable "--tmux bottom,75%,60%";
    # ALT-C Options
    changeDirWidget = {
      command = "${zoxide} query --list && ${fd} -HIL -t d -E .cache";
      options = [
        "--border-label ' cd '"
        "--preview '${eza} --color=always --follow-symlinks --tree {}'"
      ];
    };
    # CTRL-T Options
    fileWidget = {
      command = "${fd} -IL -t f";
      options = [
        "--border-label ' file '"
        "--preview '(${bat} --paging=never --color=always {} || ${eza} --color=always --follow-symlinks --tree {}) 2> /dev/null | ${head} -200'"
      ];
    };
    # CTRL-R Options
    historyWidget = {
      options = [
        "--border-label ' history '"
      ];
    };
  };
}
