{ lib, modulesPath, pkgs, systemConfigurations, config-store-path, ... }:

let
  isoClosureDir = "toplevel-closures";
  isoConfigDir = "config";
in {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  networking = {
    hostName = "iso";
    networkmanager.enable = true;
    wireless.enable = false;
  };

  services = {
    qemuGuest.enable = true;
  };

  isoImage = {
    edition = "custom-min";
    squashfsCompression = "gzip -Xcompression-level 1";

    contents = [
      {
        source = config-store-path;
        target = "/${isoConfigDir}";
      }
    ] ++ lib.mapAttrsToList (n: v: {
      source = v.config.system.build.toplevel;
      target = "/${isoClosureDir}/${n}";
    }) systemConfigurations;
  };

  environment.systemPackages = (with pkgs; [
    disko
  ]) ++ lib.flatten (
    lib.mapAttrsToList (systemName: _: with pkgs; [
      (callPackage ./disko-dfm-system.nix { disko-config-path = "/iso/${isoConfigDir}/hosts/systems/${systemName}/disko/disko-config.nix"; inherit systemName; })
      (callPackage ./install-system-closure.nix { closurePath = "/iso/${isoClosureDir}/${systemName}"; inherit systemName; })
    ]) systemConfigurations
  );

  nix.settings.flake-registry = "";
}
