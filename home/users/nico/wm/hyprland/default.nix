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
    ./hyprmon.nix
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
      enable = true;
      variables = [ "--all" ];
    };

    plugins = with pkgs.hyprlandPlugins; [
      (hyprsplit.overrideAttrs (finalAttrs: {
        # TODO: switch to lua
        version = "unstable";
        src = pkgs.fetchFromGitHub {
          owner = "shezdy";
          repo = "hyprsplit";
          rev = "ea230fc65b4bd591451d2305140a2e3fbce894ca";
          hash = "sha256-VeVHk55Vg9+0BfUS+GleE7vZfa7ssb4yM+p+noJ349w=";
        };
      }))
    ];

    configType = "hyprlang";
    settings = import ./hypr-settings.nix (args // customPkgs);
  };

  systemd.user.tmpfiles.rules = lib.map (
    f: "f ${lib.escapeShellArg f} - - - - -"
  ) config.wayland.windowManager.hyprland.settings.source;

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
