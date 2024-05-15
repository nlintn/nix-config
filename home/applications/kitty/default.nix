{ pkgs, ... }:

{
  imports = [ ./base16-colors.nix ];
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.85";

      cursor_shape = "block";
      cursor_blink_interval = 0;
      shell_integration = "no-cursor";

      mouse_hide_wait = -1;
      
      enable_audio_bell = "no";
    };
    keybindings = {
      "ctrl+n" = "launch --cwd=current --type=tab";
    };
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 10.5;
      package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });
    };
  };
}
