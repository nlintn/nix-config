{ inputs, userSettings, ... }:

let 
  theme_location = ".config/alacritty/theme.toml";
in { 
  programs.alacritty = {
    enable = true;
    settings = {
      env.XTERM = "xterm-256color";
      import = [ ("~/" + theme_location) ];
      window = {
        dimensions = { columns = 80; lines = 25; };
        # startup_mode = "Maximized";
        opacity = 0.70;
        blur = true;
      };
      # cursor.style.blinking = "On";

    };
  };

  home.file.${theme_location}.source = inputs.catppuccin-alacritty + "/catppuccin-${userSettings.catppuccin-flavour}.toml";
}
