{ pkgs, config, inputs, userSettings, self, ... }:

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

  nix = {
    package = pkgs.nix;
    registry = {
      "n".flake = inputs.nixpkgs;
      "self".flake = self;
    };
    gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 14d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
    };
  };

  news.display = "silent";
}
