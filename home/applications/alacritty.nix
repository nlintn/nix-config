{ /*pkgs,*/ inputs, userSettings, ... }:

{ 
  programs.alacritty = {
    enable = true;
    settings = {
      /* shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [ "-c" "tmux" ];
      }; */
      env.XTERM = "xterm-256color";
      import = [ (inputs.catppuccin-alacritty + "/catppuccin-${userSettings.catppuccin-flavour}.toml") ];
      window = {
        dimensions = { columns = 80; lines = 25; };
        # startup_mode = "Maximized";
        opacity = 0.70;
        blur = true;
      };
      # cursor.style.blinking = "On";
      keyboard.bindings = [
        { key = "N"; mods = "Control"; action = "CreateNewWindow"; }
        { key = "F"; mods = "Control"; chars = "**\t"; }
        { key = "ArrowLeft"; mods = "Alt"; chars = "cd ..\n"; }
        { key = "ArrowRight"; mods = "Alt"; chars = "cd - > /dev/null\n"; }
        { key = "ArrowUp"; mods = "Alt"; chars = "cd ~\n"; }
        { key = "ArrowDown"; mods = "Alt"; chars = "cd /\n"; }
      ];
    };
  };
}

