{ pkgs, lib, config, inputs, userSettings, ... }:

let thunar_pkg = with pkgs.xfce;
  thunar.override {
    thunarPlugins = [ thunar-archive-plugin thunar-media-tags-plugin ];
  };
in {
  imports = [
    inputs.hyprland.homeManagerModules.default

    ./avizo.nix
    ./gtk-theme.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./networkmanagerapplet.nix
    ./polkit-gnome-authentication-agent.nix
    ./rofi
    ./swayimg.nix
    ./swaync
    ./waybar
    ./wayland-pipewire-idle-inhibit.nix
  ];

  home.packages = [
    thunar_pkg
    (import ./scripts/xdg-terminal-exec.nix { inherit pkgs config; })    
  ] ++ (with pkgs; [
    evince
    hyprpicker
    networkmanagerapplet
    nwg-displays
    pavucontrol
    wlr-randr
    xdg-utils
    file-roller
  ]);
  
  services.copyq = {
    enable = true;
    forceXWayland = false;
  };
  services.blueman-applet.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    xwayland.enable = true;
    systemd.enable = true;

    plugins = [ ];

    settings = import ./hypr-settings.nix { inherit pkgs lib config inputs userSettings thunar_pkg; };
  };

  home.activation.hyprlandActivation = ''
    run ${import ./scripts/hyreload.nix { inherit pkgs config userSettings; } }
  '';

  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir=${config.home.homeDirectory}/Pictures/Screenshots
    save_filename_format=screen-%Y%m%d-%H%M%S.png
  '';

  nix.settings = {
    extra-trusted-substituters = [ "https://hyprland.cachix.org" ];
    extra-trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
