{ pkgs, lib, config, inputs, userSettings, ... }:

let thunar_pkg = with pkgs.xfce; 
  thunar.override {
    thunarPlugins = [ thunar-archive-plugin thunar-media-tags-plugin ];
  };
in {
  imports =  [
    ./avizo.nix
    ./gtk-theme.nix
    ./rofi.nix
    ./swayidle.nix
    ./swaylock.nix
    ./waybar
  ];

  home.packages = [
    config.services.playerctld.package

    inputs.hyprland-contrib.packages.${pkgs.system}.scratchpad
    thunar_pkg

    (import ./scripts/rofi-powermenu.nix { inherit pkgs; })
    (import ./scripts/xdg-terminal-exec.nix { inherit pkgs config; })    
  ] ++ (with pkgs; [  
    evince
    hyprpicker
    networkmanagerapplet
    nwg-displays
    pavucontrol
    swayimg
    swaynotificationcenter
    wlr-randr
    xdg-utils
    # xwaylandvideobridge
  ]) ++ (with pkgs.gnome; [
    eog
    file-roller
    gnome-calendar
    gnome-clocks
    totem
  ]);
  
  services.gnome-keyring.enable = true;
  services.blueman-applet.enable = true;

  xdg.configFile."swaync/style.css".source = ./swaync + "/${userSettings.catppuccin-flavour}.css";  

  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir=${config.home.homeDirectory}/Pictures/Screenshots
    save_filename_format=screen-%Y%m%d-%H%M%S.png
  '';

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    xwayland.enable = true;
    systemd.enable = true;

    plugins = [
      inputs.hycov.packages.${pkgs.system}.hycov
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];

    settings = import ./hypr-settings.nix { inherit pkgs lib config inputs userSettings thunar_pkg; };
  };
}
