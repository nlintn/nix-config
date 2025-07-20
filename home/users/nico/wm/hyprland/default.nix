{ pkgs, lib, config, userSettings, ... } @ args:

let
  customPkgs = {
    hyreload = pkgs.callPackage ./scripts/hyreload.nix { inherit config userSettings; };
    lock-transparent = pkgs.callPackage ./hyprlock/lock-transparent.nix { inherit config; };
    rofi-power-menu = pkgs.callPackage ../common/rofi/rofi-power-menu.nix {};
    thunar_pkg = with pkgs.xfce;
      thunar.override {
        thunarPlugins = [ thunar-archive-plugin thunar-media-tags-plugin ];
      };
    xdg-terminal-exec = pkgs.callPackage ../common/scripts/xdg-terminal-exec.nix { inherit config; };
  };
in {
  imports = [
    ../common/wayland.nix

    ../common/avizo.nix
    ../common/gtk-theme.nix
    ../common/networkmanagerapplet.nix
    ../common/polkit-gnome-authentication-agent.nix
    ../common/rofi
    ../common/swaync
    ../common/wayland-pipewire-idle-inhibit.nix

    ./hypridle.nix
    ./hyprlock
    ./waybar
  ];

  home.packages = (with customPkgs; [
    thunar_pkg
    xdg-terminal-exec
  ]) ++ (with pkgs; [
    evince
    nwg-displays
    pavucontrol
    swayimg
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

    xwayland.enable = true;
    systemd.enable = true;

    plugins = with pkgs.hyprlandPlugins; [
      hyprsplit
    ];

    settings = import ./hypr-settings.nix (args // customPkgs);
  };

  home.activation.hyprlandActivation = lib.hm.dag.entryAfter [ "reloadSystemd" ] "run ${customPkgs.hyreload}";

  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir=${config.home.homeDirectory}/Pictures/Screenshots
    save_filename_format=screen-%Y%m%d-%H%M%S.png
  '';
}
