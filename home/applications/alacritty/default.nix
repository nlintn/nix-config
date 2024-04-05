{ config, ... }:

{ 
  programs.alacritty = {
    enable = true;
    settings = {
      colors = import ./base16-colors.nix { inherit config; }; 
      # cursor.style.blinking = "On";
      env.XTERM = "xterm-256color";
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font"; 
          style = "Regular";
        };
      };
      mouse.hide_when_typing = true;
      window = {
        dimensions = { columns = 80; lines = 25; };
        # startup_mode = "Maximized";
        opacity = 0.85;
        blur = true;
      };

      keyboard.bindings = [
        { key = "N"; mods = "Control"; action = "CreateNewWindow"; }
      ];
    };
  };
}

