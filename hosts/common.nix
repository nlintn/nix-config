{
  config,
  hostSecrets,
  inputs,
  lib,
  nixSystemName,
  overlays,
  ...
}:

{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.nix-colors.homeManagerModules.default

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
      }) inputs
    );
    nixPath = lib.mapAttrsToList (n: v: "${n}=flake:${v.to.path or n}") config.nix.registry;
    channel.enable = false;

    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "flakes"
        "nix-command"
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
        "/share/applications"
        "/share/xdg-desktop-portal"
      ]
    )
  ];

  # Add keepassxc polkit action file
  environment.systemPackages = (
    lib.attrValues config.home-manager.users or { }
    |> lib.filter (
      v: v.programs.keepassxc.enable && v.programs.keepassxc.settings.Security.QuickUnlock or true
    )
    |> lib.map (v: v.programs.keepassxc.package)
  );

  environment.sessionVariables = {
    NIXPKGS_ALLOW_BROKEN = lib.mkIf (config.nixpkgs.config.allowBroken or false) (lib.mkDefault "1");
    NIXPKGS_ALLOW_INSECURE = lib.mkIf (config.nixpkgs.config.allowInsecure or false) (
      lib.mkDefault "1"
    );
    NIXPKGS_ALLOW_UNFREE = lib.mkIf (config.nixpkgs.config.allowUnfree or false) (lib.mkDefault "1");
  };

  system.configurationRevision = lib.mkIf (inputs.self ? rev) inputs.self.rev;
}
