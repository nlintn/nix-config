{ pkgs, lib, config, inputs, self, userSettings, config-store-path, ... }:

{
  home.stateVersion = "25.11";

  imports = [
    ./options.nix

    inputs.nix-colors.homeManagerModules.default

    ./applications

    ./fonts.nix

    ./xdg

    ./wm
  ];

  home.username = "nico";
  home.homeDirectory = "/home/nico";

  colorScheme = userSettings.colorScheme;

  home.sessionVariables = {
    NIX_CONFIG_DIR = config.home.configDirectory;
    CONFIG_STORE_PATH = config-store-path;
  };

  home.activation.copyNixConfig = lib.hm.dag.entryAfter [ "linkGeneration" ]
    /* sh */ '' [ -e ${config.home.configDirectory} ] || cp -r ${config-store-path} ${config.home.configDirectory} '';

  nix = let
    pre_reg = lib.mapAttrs (_: flake: { inherit flake; }) self.inputs;
  in {
    package = lib.mkDefault pkgs.nix;
    registry = pre_reg // {
      "self".flake = self;
      "n" = pre_reg."nixpkgs";
      "nu" = { to = { type = "github"; owner = "nixos"; repo = "nixpkgs/nixos-unstable"; }; };
    };
    nixPath = lib.mapAttrsToList (n: v: "${n}=flake:${v.flake.outPath or n}") config.nix.registry;

    gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 14d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
    };
  };

  systemd.user.startServices = true;

  programs.home-manager.enable = true;
  news.display = "silent";
}
