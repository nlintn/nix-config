{ ... }:

{
  programs.tmux = {
    enable = true;
    mouse = true;
    clock24 = true;
    newSession = true;
    prefix = "C-a";
    keyMode = "vi";
    escapeTime = 0;
    focusEvents = true;
  };
}
