{ inputs, config, ... }:

{ 
  programs.alacritty = {
    enable = true;
    settings = {
      colors = import ./base16-colors.nix { inherit config; }; 
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font"; 
          style = "Regular";
        };
      };
      env.XTERM = "xterm-256color";
      window = {
        dimensions = { columns = 80; lines = 25; };
        # startup_mode = "Maximized";
        opacity = 0.85;
        blur = true;
      };
      # cursor.style.blinking = "On";
      /* keyboard.bindings = [
        { key = "N"; mods = "Control"; action = "CreateNewWindow"; }
        { key = "F"; mods = "Control"; chars = "**\t"; }
        { key = "ArrowLeft"; mods = "Alt"; chars = "cd ..\n"; }
        { key = "ArrowRight"; mods = "Alt"; chars = "cd - > /dev/null\n"; }
        { key = "ArrowUp"; mods = "Alt"; chars = "cd ~\n"; }
        { key = "ArrowDown"; mods = "Alt"; chars = "cd /\n"; }
      ]; */
    };
  };
}

