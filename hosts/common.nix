{
  config,
  lib,
  agenix,
  nixSystemName,
  nix-colors,
  overlays,
  hostSecrets,
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
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LANGUAGE = "en_US.UTF-8";
      LC_ADDRESS = "de_DE.UTF-8";
      LC_CTYPE = "C.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "en_DK.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "en_IE.UTF-8";
    };
  };

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
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      use-xdg-base-directories = true;
    };
  };

  environment.pathsToLink = lib.mkMerge [
    (lib.mkIf (lib.any (u: u.xdg.enable) (builtins.attrValues config.home-manager.users or { })) [
      "/share/xdg-desktop-portal"
      "/share/applications"
    ])
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
