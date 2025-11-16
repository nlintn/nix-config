{ config, lib, pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    colors = with config.colorScheme.palette; {
      "bg+"       = "#${base03}";
      fg          = "#${base05}";
      "fg+"       = "#${base05}";
      header      = "#${base08}";
      hl          = "#${base08}";
      "hl+"       = "#${base08}";
      info        = "#${base0E}";
      marker      = "#${base06}";
      pointer     = "#${base06}";
      prompt      = "#${base0E}";
      spinner     = "#${base06}";
    };
    defaultCommand = "${lib.getExe config.programs.fd.package} -IL";
    defaultOptions = [
      "--height 60%"
      "--border"
      "--layout=reverse"
    ] ++ lib.optional config.programs.tmux.enable "--tmux bottom,75%,60%";
    changeDirWidgetCommand = "${lib.getExe' pkgs.coreutils "cat"} <(${lib.getExe config.programs.fd.package} <(${lib.getExe config.programs.zoxide.package} query --list) -IL -t d -E .cache)";
    changeDirWidgetOptions = [  #  ALT-C Options
      "--preview '${lib.getExe pkgs.eza} --color=always --follow-symlinks --tree {}'"
    ];
    fileWidgetCommand = "${lib.getExe config.programs.fd.package} -IL -t f";
    fileWidgetOptions = [       # CTRL-T Options
      "--preview '(${lib.getExe config.programs.bat.package} --paging=never --color=always {} || ${lib.getExe pkgs.tree} -C {}) 2> /dev/null | head -200'"
    ];
    historyWidgetOptions = [    # CTRL-R Options
    ];
  };
}
