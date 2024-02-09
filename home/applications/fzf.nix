{ userSettings, ... }:

let 
  color = {
    "latte"     = "bg+:#ccd0da,spinner:#dc8a78,hl:#d20f39,fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78,marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39";
    "frappe"    = "bg+:#414559,spinner:#f2d5cf,hl:#e78284,fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf,marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284";
    "macchiato" = "bg+:#363a4f,spinner:#f4dbd6,hl:#ed8796,fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6,marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796";
    "mocha"     = "bg+:#313244,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8";
  };
in {
  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--height 60%"
      "--border"
      "--layout=reverse"
      "--color=${color.${userSettings.catppuccin-flavour}}"
    ];
    fileWidgetOptions = [       # CTRL-T Options
      "--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
    ];
    historyWidgetOptions = [    # CTRL-R Options
    ];
    changeDirWidgetOptions = [  #  ALT-C Options
      "--preview 'tree -C {}'"
    ];
  };
}
