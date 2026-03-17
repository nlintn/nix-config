{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}@args:

let
  customPkgs = {
    hyreload = pkgs.callPackage ./scripts/hyreload.nix args;
  };
in
{
  imports = [
    ../common/wayland.nix

    ../common/avizo.nix
    ../common/gtk-theme.nix
    ../common/vicinae.nix
    ../common/swaync

    ./hypridle.nix
    ./hyprlock
    ./waybar
  ];

  home.packages = with pkgs; [
    file-roller
    nwg-displays
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
      enable = true;
      variables = [ "--all" ];
    };

    plugins = with pkgs.hyprlandPlugins; [
      (hyprsplit.overrideAttrs (finalAttrs: {
        version = "0.54.1";
        src = pkgs.fetchFromGitHub {
          owner = "shezdy";
          repo = "hyprsplit";
          rev = "395b780d517ee475e7e94beb149ec9a9fdac292d";
          hash = "sha256-IksjbT24cgWl2h6ZV4bPxoORmHCQ7h/M/OLQ4epReAE=";
        };
      }))
    ];

    settings = import ./hypr-settings.nix (args // customPkgs);
  };

  xdg.portal = {
    enable = lib.mkDefault true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ]; # hyprland already auto added
    config."hyprland" = {
      default = [
        "hyprland"
        "gtk"
      ];
    };
  };

  home.sessionVariables.GTK_IM_MODULE = "simple";

  # home.activation.hyprlandActivation = lib.hm.dag.entryAfter [ "reloadSystemd" ] "run ${customPkgs.hyreload}";
}
