{ ... }:

{
  programs.waybar = {
    enable = true;
    style = builtins.readFile ./waybar/style.css;
  };
  home.file.".config/waybar/config".source = ./waybar/config.json;
}