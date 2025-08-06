{ config, lib, pkgs, config-store-path, hmUsername, inputs, nixpkgs-overlay, nix-colors, self, userSettings, ... }:

{
  imports = [
    nixpkgs-overlay.homeManagerModule
    nix-colors.homeManagerModules.default
  ];

  home = {
    username = lib.mkDefault hmUsername;
    homeDirectory = lib.mkDefault "/home/${config.home.username}";

    sessionVariables = {
      NIX_CONFIG_DIR = "${config.home.homeDirectory}/${userSettings.rel-config-path}";
      CONFIG_STORE_PATH = config-store-path;
    } // lib.optionalAttrs config.nixpkgs.config.allowBroken or false {
      NIXPKGS_ALLOW_BROKEN = lib.mkDefault "1";
    } // lib.optionalAttrs config.nixpkgs.config.allowInsecure or false {
      NIXPKGS_ALLOW_INSECURE = lib.mkDefault "1";
    } // lib.optionalAttrs config.nixpkgs.config.allowUnfree or false {
      NIXPKGS_ALLOW_UNFREE = lib.mkDefault "1";
    };
  };

  systemd.user.sessionVariables = config.home.sessionVariables;

  nix = {
    package = lib.mkDefault pkgs.nix;
    registry = lib.mapAttrs (_: flake: { inherit flake; }) inputs // {
      "self".flake = self;
    };
    nixPath = lib.mapAttrsToList (n: v: "${n}=flake:${v.flake.outPath or n}") config.nix.registry;

    settings = {
      experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
      use-xdg-base-directories = lib.mkIf (!config.submoduleSupport.enable) (lib.mkDefault true);
    };
  };

  programs.home-manager.enable = lib.mkDefault true;
  news.display = lib.mkDefault "silent";
}
