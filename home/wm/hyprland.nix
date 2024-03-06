{ config, pkgs, lib, inputs, userSettings, ... }:

{
  imports =  [
    ./hyprland/avizo.nix
    ./hyprland/waybar.nix
    ./hyprland/rofi.nix
    ./hyprland/swaylock.nix
    ./hyprland/gtk-theme.nix
  ];

  home.packages = with pkgs; [
    inputs.hyprland-contrib.packages.${pkgs.system}.scratchpad
    
    swayimg
    evince
    hyprpicker

    xdg-utils
    swaynotificationcenter
    networkmanagerapplet
    pavucontrol
    nwg-displays
    wlr-randr
    slurp
    xwaylandvideobridge

    (import ./hyprland/scripts/xdg-terminal-exec.nix { inherit pkgs config; })

    (import ./hyprland/scripts/rofi-powermenu.nix { inherit pkgs; }) 
  ] ++ (with pkgs.gnome; [
    gnome-calendar
    eog
    gnome-clocks
    totem
    file-roller
  ]) ++ (with pkgs.xfce; [
    (thunar.override {
      thunarPlugins = [ thunar-archive-plugin thunar-media-tags-plugin ];
    })
  ]);
  
  services.gnome-keyring.enable = true;
  services.blueman-applet.enable = true;

  home.file.".config/swaync/style.css".source = ./hyprland/swaync + "/${userSettings.catppuccin-flavour}.css";  

  home.file.".config/swappy/config".text = ''
    [Default]
    save_dir=$HOME/Pictures/Screenshots
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

    settings = import ./hyprland/hypr-settings.nix { inherit pkgs lib config; };
  };
}
