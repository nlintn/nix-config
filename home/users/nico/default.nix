{
  config,
  lib,
  nixpkgs,
  self,
  userSettings,
  ...
}:

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

  home.activation.copyNixConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] (
    with config.home.sessionVariables;
    /* sh */ ''
      [ -e ${NIX_CONFIG_DIR} ] || cp -r ${self.outPath} ${NIX_CONFIG_DIR}
    ''
  );
  common.setNixRegistry = true;

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  nix = {
    registry = {
      "n".flake = nixpkgs;
      "nu" = {
        to = {
          type = "github";
          owner = "nixos";
          repo = "nixpkgs";
          ref = "nixos-unstable";
        };
      };
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
