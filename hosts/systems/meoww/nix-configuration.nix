{ self, ... }:

{
  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    flags = [
      "--update-input nixpkgs" "--update-input nixpkgs-overlay"
      "-L" "--no-write-lock-file"
      "--option max-jobs 1" "--option cores 1"
    ];
    flake = self.outPath;
  };

  nix = {
    optimise = {
      automatic = true;
      dates = "weekly";
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
