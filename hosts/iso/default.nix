{
  lib,
  modulesPath,
  pkgs,
  assets,
  config-store-path,
  systemConfiguration,
  ...
}:

{
  system.stateVersion = "25.11";

  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  networking = {
    networkmanager.enable = true;
    wireless.enable = false;
  };

  services = {
    qemuGuest.enable = true;
  };

  isoImage = {
    edition = "${if systemConfiguration == null then "raw" else systemConfiguration.n}-cmin";
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
        disko-config-path = "${config-store-path}/hosts/systems/${systemConfiguration.n}/disko/disko-config.nix";
      })
      (callPackage ./install-system-closure.nix {
        closureStorePath = systemConfiguration.v.config.system.build.toplevel;
      })
    ]);

  users.users.nixos.openssh.authorizedKeys.keyFiles = [
    assets."nico_id_ed25519.pub"
  ];

  nix.settings.flake-registry = "";
}
