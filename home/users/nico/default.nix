{ config, lib, nixpkgs, userSettings, ... }:

{
  home.stateVersion = "25.11";

  imports = [
    ./applications
    ./fonts.nix
    ./shell
    ./xdg

    ./wm
  ];

  colorScheme = userSettings.colorScheme;

  home.activation.copyNixConfig = lib.hm.dag.entryAfter [ "linkGeneration" ]
    (with config.home.sessionVariables; /* sh */ ''
      [ -e ${NIX_CONFIG_DIR} ] || cp -r ${CONFIG_STORE_PATH} ${NIX_CONFIG_DIR}
    '');

  nix = {
    registry = {
      "n".flake = nixpkgs;
      "nu" = { to = { type = "github"; owner = "nixos"; repo = "nixpkgs"; ref = "nixos-unstable"; }; };
    };

    gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
