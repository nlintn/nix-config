{ ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    mouse = true;
    clock24 = true;
    baseIndex = 1;
    # extraConfig = ''
    #   set-option -ga terminal-overrides ",xterm-256color:Tc"
    # '';
  };
}