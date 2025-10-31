{ config, lib, pkgs, ... } @ args:

{
  programs.rofi = {
    enable = true;
    terminal = lib.getExe config.programs.ghostty.package;
    package = pkgs.rofi.override {
      rofi-unwrapped = pkgs.rofi-unwrapped.override (with config.home.sessionVariables; {
        waylandSupport = WAYLAND_SUPPORT == "1"; x11Support = X11_SUPPORT == "1";
      });
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
