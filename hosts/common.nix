{ config, lib, pkgs, self, overlays, config-store-path, ... }:

{
  environment.systemPackages = with pkgs; [
    git
  ];
  programs.nano.enable = false;
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  # Configure console keymap
  console = {
    keyMap = "de";
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "en_DK.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  nixpkgs = {
    overlays = overlays;
    config.allowUnfree = true;
  };

  nix = {
    registry = lib.mapAttrs (_: flake: { inherit flake; }) self.inputs // {
      "self".flake = self;
    };
    nixPath = lib.mapAttrsToList (n: v: "${n}=flake:${v.flake.outPath or n}") config.nix.registry;
    channel.enable = false;

    settings = {
      experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  environment.sessionVariables.CONFIG_STORE_PATH = config-store-path;

  system.configurationRevision = lib.mkIf (self ? rev) self.rev;
  system.stateVersion = "25.05";
}
