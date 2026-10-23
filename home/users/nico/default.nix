{
  config,
  inputs,
  lib,
  pkgs,
  userSettings,
  ...
}:

{
  home.stateVersion = "26.05";

  imports = [
    ./applications
    ./backup.nix
    ./fonts.nix
    ./locale.nix
    ./shell
    ./xdg

    ./wm
  ];

  colorScheme = userSettings.colorScheme;

  common.setNixRegistry = true;

  age.identityPaths = [
    "${config.home.homeDirectory}/.ssh/id_agenix"
  ];

  systemd.user.tmpfiles.rules =
    let
      inherit (config.home.sessionVariables) NIX_CONFIG_DIR;
      inherit (lib) escapeShellArg;
    in
    [
      "C ${escapeShellArg NIX_CONFIG_DIR} - - - - ${escapeShellArg inputs.self.outPath}"
    ];

  vars.launchPrefix = lib.optionalString config.systemd.user.enable "${lib.getExe pkgs.runapp} -- ";

  nix = {
    registry = {
      "n".flake = inputs.nixpkgs-unstable-patched;
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
