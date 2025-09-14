{ config, lib, pkgs, ... }:

let
  color = with config.colorScheme.palette;
    "bg+:#${base02},spinner:#${base06},hl:#${base08},fg:#${base05},header:#${base08},info:#${base0E},pointer:#${base06},marker:#${base06},fg+:#${base05},prompt:#${base0E},hl+:#${base08}";
  fd = lib.getExe pkgs.fd;
in {
  programs.fzf = {
    enable = true;
    colors = with config.colorScheme.palette; {
      "bg+"   = "#${base02}";
      fg      = "#${base05}";
      "fg+"   = "#${base05}";
      header  = "#${base08}";
      hl      = "#${base08}";
      "hl+"   = "#${base08}";
      info    = "#${base0E}";
      marker  = "#${base06}";
      pointer = "#${base06}";
      prompt  = "#${base0E}";
      spinner = "#${base06}";
    };
    defaultCommand = "${fd} -IL";
    defaultOptions = [
      "--height 60%"
      "--border"
      "--layout=reverse"
      "--color=${color}"
    ];
    changeDirWidgetCommand = "${fd} -IL -t d";
    changeDirWidgetOptions = [  #  ALT-C Options
      "--preview '${lib.getExe pkgs.tree} -C {}'"
    ];
    fileWidgetCommand = "${fd} -IL -t f";
    fileWidgetOptions = [       # CTRL-T Options
      "--preview '(${lib.getExe config.programs.bat.package} --paging=never --color=always {} || ${lib.getExe pkgs.tree} -C {}) 2> /dev/null | head -200'"
    ];
    historyWidgetOptions = [    # CTRL-R Options
    ];
  }; 
}
