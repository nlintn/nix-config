{ pkgs, userSettings, ... }:

{
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    package = pkgs.rofi-wayland;
    theme = ./rofi/launcher2.rasi;
    extraConfig = {
      modi = "run,drun,ssh";
      icon-theme = "Oranchelo";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      font = "JetBrainsMono Nerd Font 12";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 﩯  Window";
      display-Network = " 󰤨  Network";
      display-ssh = "   ssh";
      sidebar-mode = true;
      click-to-exit = true;

    };
  };
}