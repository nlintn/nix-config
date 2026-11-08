{
  assets,
  inputs,
  lib,
  ...
}:

{
  common.setNixRegistry = [
    "nixpkgs-stable"
    "nixpkgs"
  ];

  system.autoUpgrade = {
    enable = true;
    dates = "06:00";
    persistent = true;
    flags = [
      "--update-input nixpkgs-stable"
      "--update-input nixpkgs"
      "-L"
      "--no-write-lock-file"
      "--option max-jobs 1"
      "--option cores 1"
    ];
    flake = inputs.self.outPath;
  };

  nix = {
    settings = {
      trusted-public-keys = [
        (lib.readFile assets."nix-key-meoww.pub")
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
