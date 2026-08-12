{
  agenix,
  config,
  hostSecrets,
  lib,
  nix-colors,
  nixSystemName,
  overlays,
  self,
  ...
}:

{
  imports = [
    agenix.nixosModules.default
    nix-colors.homeManagerModules.default

    ./options.nix
  ];

  age.secrets = hostSecrets nixSystemName;
  services.openssh.generateHostKeys = true;

  nixpkgs = {
    inherit overlays;
  };

  networking.hostName = lib.mkDefault nixSystemName;

  programs = {
    git.enable = lib.mkDefault true;
    nano.enable = lib.mkDefault false;
    vim = {
      enable = lib.mkDefault true;
      defaultEditor = lib.mkDefault true;
    };
  };

  console = {
    keyMap = lib.mkDefault "de-latin1";
  };

  time.timeZone = lib.mkDefault "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  nixpkgs.flake.source = lib.mkForce null;
  nix = {
    registry = lib.mkIf config.common.setNixRegistry (
      lib.mapAttrs (_: v: {
        to = {
          type = "path";
          path = v.outPath;
        };
      }) (self.inputs // { inherit self; })
    );
    nixPath = lib.mapAttrsToList (n: v: "${n}=flake:${v.to.path or n}") config.nix.registry;
    channel.enable = false;

    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      use-xdg-base-directories = true;
    };
  };

  environment.pathsToLink = lib.mkMerge [
    (lib.mkIf
      (
        lib.any (u: u.xdg.portal.enable) (lib.attrValues config.home-manager.users or { })
        && config.home-manager.useUserPackages or false
      )
      [
        "/share/xdg-desktop-portal"
        "/share/applications"
      ]
    )
  ];

  environment.sessionVariables = {
    NIXPKGS_ALLOW_BROKEN = lib.mkIf (config.nixpkgs.config.allowBroken or false) (lib.mkDefault "1");
    NIXPKGS_ALLOW_INSECURE = lib.mkIf (config.nixpkgs.config.allowInsecure or false) (
      lib.mkDefault "1"
    );
    NIXPKGS_ALLOW_UNFREE = lib.mkIf (config.nixpkgs.config.allowUnfree or false) (lib.mkDefault "1");
  };

  system.configurationRevision = lib.mkIf (self ? rev) self.rev;
}
