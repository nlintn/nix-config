{ config, lib, pkgs, userSettings, ... } @ args:

let
  customPkgs = {
    hyreload = pkgs.callPackage ./scripts/hyreload.nix args;
  };
in {
  imports = [
    ../common/wayland.nix

    ../common/avizo.nix
    ../common/gtk-theme.nix
    ../common/rofi
    ../common/swaync
    ../common/wlogout

    ./hypridle.nix
    ./hyprlock
    ./waybar
  ];

  home.packages = with pkgs; [
    file-roller
    nwg-displays
    pwvucontrol
    swayimg
    wlr-randr
  ];

  programs = {
    nm-applet.enable = true;
    swaybg = {
      enable = true;
      image.path = userSettings.wallpaper;
    };
  };

  services.copyq = {
    enable = true;
    forceXWayland = false;
  };
  services = {
    blueman-applet.enable = true;
    polkit-gnome.enable = true;
    wayland-pipewire-idle-inhibit.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;

    xwayland.enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };

    plugins = with pkgs.hyprlandPlugins; [
      hyprsplit
    ];

    settings = import ./hypr-settings.nix (args // customPkgs);
  };

  xdg.portal = {
    enable = lib.mkDefault true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ]; # hyprland already auto added
    config."hyprland" = {
      default = [ "hyprland" "gtk" ];
    };
  };

  # home.activation.hyprlandActivation = lib.hm.dag.entryAfter [ "reloadSystemd" ] "run ${customPkgs.hyreload}";

  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir=${config.home.homeDirectory}/Pictures/Screenshots
    save_filename_format=screen-%Y%m%d-%H%M%S.png
  '';
}
