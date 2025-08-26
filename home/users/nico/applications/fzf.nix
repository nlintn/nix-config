{ config, pkgs, ... }:

let
  color = with config.colorScheme.palette;
    "bg+:#${base02},spinner:#${base06},hl:#${base08},fg:#${base05},header:#${base08},info:#${base0E},pointer:#${base06},marker:#${base06},fg+:#${base05},prompt:#${base0E},hl+:#${base08}";
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
    defaultCommand = "${pkgs.fd}/bin/fd -IL";
    defaultOptions = [
      "--height 60%"
      "--border"
      "--layout=reverse"
      "--color=${color}"
    ];
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd -IL -t d";
    changeDirWidgetOptions = [  #  ALT-C Options
      "--preview '${pkgs.tree}/bin/tree -C {}'"
    ];
    fileWidgetCommand = "${pkgs.fd}/bin/fd -IL -t f";
    fileWidgetOptions = [       # CTRL-T Options
      "--preview '(${config.programs.bat.package}/bin/bat --paging=never --color=always {} || ${pkgs.tree}/bin/tree -C {}) 2> /dev/null | head -200'"
    ];
    historyWidgetOptions = [    # CTRL-R Options
    ];
  }; 
}
