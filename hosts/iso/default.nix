{ lib, modulesPath, pkgs, config-store-path, systemConfigurations, ... }:

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
    edition = "custom-min";
    squashfsCompression = "gzip -Xcompression-level 1";
  };

  environment.systemPackages = (with pkgs; [
    disko
    sbctl
  ]) ++ lib.flatten (
    lib.mapAttrsToList (systemName: v: with pkgs; [
      (callPackage ./disko-dfm-system.nix { disko-config-path = "${config-store-path}/hosts/systems/${systemName}/disko/disko-config.nix"; inherit systemName; })
      (callPackage ./install-system-closure.nix { closureStorePath = v.config.system.build.toplevel; inherit systemName; })
    ]) systemConfigurations
  );

  nix.settings.flake-registry = "";
}
