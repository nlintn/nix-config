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

  common.setNixRegistry = true;

  systemd.user.tmpfiles.rules =
    let
      inherit (config.home.sessionVariables) NIX_CONFIG_DIR;
      inherit (lib) escapeShellArg;
    in
    [
      "C ${escapeShellArg NIX_CONFIG_DIR} - - - - ${escapeShellArg self.outPath}"
    ];

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
