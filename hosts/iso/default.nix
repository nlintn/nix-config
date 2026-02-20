{
  config,
  lib,
  modulesPath,
  pkgs,
  assets,
  self,
  systemConfiguration,
  ...
}:

{
  system.stateVersion = "25.11";

  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };
  system.installer.channel.enable = false;

  common.setNixRegistry = true;

  networking.networkmanager.enable = true;

  services = {
    qemuGuest.enable = true;
  };

  isoImage = {
    edition = "${systemConfiguration.name or "raw"}-cmin";
    squashfsCompression = "gzip -Xcompression-level 1";
  };

  environment.systemPackages =
    with pkgs;
    [
      disko
      sbctl
    ]
    ++ (lib.optionals (systemConfiguration != null) [
      (callPackage ./disko-dfm-system.nix {
        disko-config-path = builtins.path {
          path = "${self.outPath}/hosts/systems/${systemConfiguration.name}/disko/disko-config.nix";
        };
      })
      (callPackage ./install-system-closure.nix {
        closureStorePath = systemConfiguration.value.config.system.build.toplevel;
      })
    ]);

  users.users.nixos.openssh.authorizedKeys.keyFiles = [
    assets."nico_id_ed25519.pub"
  ];

  systemd.tmpfiles.rules = [
    "C  ${lib.escapeShellArg config.users.users.nixos.home}/flake  -  -  -  -  ${lib.escapeShellArg self.outPath}"
  ];

  nix.settings.flake-registry = "";
}
