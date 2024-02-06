{ /*pkgs,*/ inputs, userSettings, ... }:

let 
  theme_location = ".config/alacritty/theme.toml";
in { 
  programs.alacritty = {
    enable = true;
    settings = {
      /* shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [ "-c" "tmux" ];
      }; */
      env.XTERM = "xterm-256color";
      import = [ ("~/" + theme_location) ];
      window = {
        dimensions = { columns = 80; lines = 25; };
        # startup_mode = "Maximized";
        opacity = 0.70;
        blur = true;
      };
      # cursor.style.blinking = "On";
      keyboard.bindings = [
        { key = "N"; mods = "Control"; action = "CreateNewWindow"; }
        { key = "ArrowLeft"; mods = "Alt"; chars = "cd ..\n"; }
        { key = "ArrowRight"; mods = "Alt"; chars = "cd - > /dev/null\n"; }
        { key = "ArrowUp"; mods = "Alt"; chars = "cd ~\n"; }
        { key = "ArrowDown"; mods = "Alt"; chars = "cd /\n"; }
      ];
    };
  };

  home.file.${theme_location}.source = inputs.catppuccin-alacritty + "/catppuccin-${userSettings.catppuccin-flavour}.toml";
}
