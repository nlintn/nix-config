{ pkgs, config, inputs, userSettings, ... }:

{
  imports = [
    inputs.nix-colors.homeManagerModules.default

    ./applications

    ./fonts.nix

    ./wm
  ];

  home.username = "nico";
  home.homeDirectory = "/home/nico";

  colorScheme = userSettings.colorScheme;
  
  home.sessionVariables = {
    NIX_CONFIG_DIR = "${config.home.homeDirectory}/nix-config";
  };

  systemd.user.startServices = true;

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  nix.package = pkgs.nix;

  news.display = "silent";
}
