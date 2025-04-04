{ pkgs, config, ... }:

{
  programs.rofi = {
    enable = true;
    terminal = "${config.programs.kitty.package}/bin/kitty";
    package = pkgs.rofi-wayland;
    theme = import ./theme.nix { inherit pkgs config; };
    plugins = with pkgs; [ rofi-emoji-wayland ];
    extraConfig = {
      ssh-command = "${config.programs.kitty.package}/bin/kitty -- kitty +kitten ssh {host}";
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
