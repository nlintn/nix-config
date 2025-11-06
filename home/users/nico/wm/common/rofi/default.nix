{ config, lib, pkgs, ... } @ args:

{
  programs.rofi = {
    enable = true;
    terminal = lib.getExe config.programs.ghostty.package;
    package = pkgs.rofi.override {
      rofi-unwrapped = pkgs.rofi-unwrapped.override  {
        inherit (config.vars) waylandSupport x11Support;
      };
    };
    theme = import ./theme.nix args;
    plugins = with pkgs; [ rofi-emoji ];
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
