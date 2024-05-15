{ pkgs, config, ... }:

{
  programs.rofi = {
    enable = true;
    terminal = "${config.programs.alacritty.package}/bin/alacritty";
    package = pkgs.rofi-wayland;
    theme = import ./theme.nix { inherit pkgs config; };
    extraConfig = {
      modi = "run,drun,ssh,window";
      show-icons = true;
      icon-theme = "kora";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      click-to-exit = true;
      matching = "fuzzy";
    };
  };
}
