{ config, lib, self, ... }:

{
  nix.settings.build-dir = lib.mkIf config.boot.tmp.useTmpfs "/var/tmp";
  systemd.services.nix-daemon.environment."TMPDIR" =
    lib.mkIf (config.nix.settings ? build-dir) config.nix.settings.build-dir;

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
