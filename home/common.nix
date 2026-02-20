{
  config,
  lib,
  osConfig ? null,
  pkgs,
  hmUsername,
  inputs,
  agenix,
  nixpkgs-overlay,
  nix-colors,
  userSecrets,
  self,
  userSettings,
  ...
}:

{
  imports = [
    agenix.homeManagerModules.default
    nixpkgs-overlay.homeManagerModules.default
    nix-colors.homeManagerModules.default

    ./options.nix
  ];

  age.secrets = userSecrets hmUsername;

  nixpkgs.config = lib.mkIf (!(osConfig.home-manager.useGlobalPkgs or false)) {
    allowUnfree = true;
  };

  home = {
    username = lib.mkDefault hmUsername;
    homeDirectory = lib.mkDefault "/home/${config.home.username}";

    sessionVariables = {
      NIX_CONFIG_DIR = "${config.home.homeDirectory}/${userSettings.rel-config-path}";
    }
    // lib.optionalAttrs config.nixpkgs.config.allowBroken or false {
      NIXPKGS_ALLOW_BROKEN = lib.mkDefault "1";
    }
    // lib.optionalAttrs config.nixpkgs.config.allowInsecure or false {
      NIXPKGS_ALLOW_INSECURE = lib.mkDefault "1";
    }
    // lib.optionalAttrs config.nixpkgs.config.allowUnfree or false {
      NIXPKGS_ALLOW_UNFREE = lib.mkDefault "1";
    };
  };

  systemd.user.sessionVariables = config.home.sessionVariables;

  nix = {
    package = lib.mkDefault pkgs.nix;
    registry = lib.mkIf config.common.setNixRegistry (
      lib.mapAttrs (_: v: {
        to = {
          type = "path";
          path = v;
        };
      }) (inputs // { inherit self; })
    );
    nixPath = lib.mapAttrsToList (n: v: "${n}=flake:${v.to.path or n}") config.nix.registry;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      use-xdg-base-directories = lib.mkIf (!config.submoduleSupport.enable) (lib.mkDefault true);
    };
  };

  programs.home-manager.enable = lib.mkDefault true;
  news.display = lib.mkDefault "silent";
}
