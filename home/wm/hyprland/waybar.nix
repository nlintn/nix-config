{ ... }:

{
  programs.waybar = {
    enable = true;
    style = builtins.readFile ./waybar/style.css;
    settings = builtins.fromJSON (builtins.readFile ./waybar/config.json);
  };
}