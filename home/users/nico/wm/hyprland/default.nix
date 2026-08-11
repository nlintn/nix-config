{
  config,
  lib,
  osConfig ? null,
  pkgs,
  userSettings,
  ...
}@args:

{
  imports = [
    ../common/wayland.nix

    ../common/avizo.nix
    ../common/gtk-theme.nix
    ../common/vicinae.nix
    ../common/swaync

    ./hypridle.nix
    ./hyprmon.nix
    ./swaylock
    ./waybar
  ];

  home.packages = with pkgs; [
    file-roller
    pwvucontrol
    wl-mirror
    wlr-randr
  ];

  programs = {
    swappy = {
      enable = true;
      settings.Default = {
        save_dir = "${config.home.homeDirectory}/Pictures/Screenshots";
        save_filename_format = "screen-%Y%m%d-%H%M%S.png";
      };
    };
    swaybg = {
      enable = true;
      image.path = userSettings.wallpaper;
    };
  };

  services = {
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
    polkit-gnome.enable = true;
    wayland-pipewire-idle-inhibit.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;

    xwayland.enable = true;
    systemd = {
      enable = !(osConfig.programs.hyprland.withUWSM or false);
      variables = [ "--all" ];
    };

    configType = "hyprlang";
    settings = import ./hypr-settings.nix args;
  };

  systemd.user.tmpfiles.rules = lib.map (
    f: "f ${lib.escapeShellArg f} - - - - -"
  ) config.wayland.windowManager.hyprland.settings.source;

  xdg.portal = {
    enable = lib.mkDefault true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ]; # hyprland already auto added
    config."hyprland" = {
      default = [
        "hyprland"
        "gnome"
        "gtk"
      ];
    };
    xdgOpenUsePortal = true;
  };

  home.sessionVariables.GTK_IM_MODULE = "simple";
}
