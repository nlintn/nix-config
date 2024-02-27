{ config, pkgs, lib, inputs, userSettings, ... }:

{
  home.packages = with pkgs; [
    swayimg
    xfce.thunar
    evince
          
    xdg-utils
    swaynotificationcenter
    networkmanagerapplet
    pavucontrol
    nwg-displays
    wlr-randr
    slurp

    (pkgs.writeShellScriptBin "xdg-terminal-exec"
    ''
      if [[ $# -gt 0 ]] then
        ${pkgs.alacritty}/bin/alacritty --command $@
      else
        ${pkgs.alacritty}/bin/alacritty
      fi
    '')

    (import ./hyprland/scripts/rofi-powermenu.nix { inherit pkgs; }) 
  ] ++ (with pkgs.gnome; [
    gnome-calendar
    eog
  ]);
  
  services.gnome-keyring.enable = true;
  services.blueman-applet.enable = true;
  services.swayosd.enable = true;

  home.file.".config/swaync/style.css".source = ./hyprland/swaync + "/${userSettings.catppuccin-flavour}.css";  

  home.file.".config/swappy/config".text = ''
    [Default]
    save_dir=$HOME/Pictures/Screenshots
    save_filename_format=screen-%Y%m%d-%H%M%S.png
  '';
  
  imports =  [
    ./hyprland/waybar.nix
    ./hyprland/rofi.nix
    ./hyprland/swaylock.nix
    ./hyprland/gtk-theme.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;

    xwayland.enable = true;
    systemd.enable = true;

    plugins = [
      inputs.hycov.packages.${pkgs.system}.hycov
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];

    settings = import ./hyprland/hypr-settings.nix { inherit pkgs; inherit lib; inherit config; };
  };
}
