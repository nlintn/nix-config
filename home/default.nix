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
    DOT_DIR = "${config.home.homeDirectory}/dotfiles";
  };

  systemd.user.startServices = true;

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  nix.package = pkgs.nix;
}
