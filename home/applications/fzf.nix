{ pkgs, config, ... }:

let 
  color = with config.colorScheme.palette; "bg+:#${base02},spinner:#${base06},hl:#${base08},fg:#${base05},header:#${base08},info:#${base0E},pointer:#${base06},marker:#${base06},fg+:#${base05},prompt:#${base0E},hl+:#${base08}";
in {
  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--height 60%"
      "--border"
      "--layout=reverse"
      "--color=${color}"
    ];
    fileWidgetOptions = [       # CTRL-T Options
      "--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
    ];
    historyWidgetOptions = [    # CTRL-R Options
    ];
    changeDirWidgetOptions = [  #  ALT-C Options
      "--preview 'tree -C {}'"
    ];
    fileWidgetCommand = "${pkgs.fd}/bin/fd -t f";
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd -t d";
  }; 
}
