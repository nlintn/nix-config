{ lib, lib-stable, system, specialArgs }:

let
  module-common = import ./common.nix;
  systemConfigurations = builtins.mapAttrs (n: _:
    let
      buildConfig = import ./systems/${n}/build-config.nix;
      lib' = if buildConfig.use-nixpkgs-stable or false then lib-stable else lib;
    in
      lib'.nixosSystem {
        system = buildConfig.system;
        specialArgs = specialArgs // { inherit module-common specialArgs ; nixSystemName = n; };
        modules = [
          ./systems/${n}
          module-common
        ];
      }
  ) (builtins.readDir ./systems);
  genIso = systemConfiguration: lib.nixosSystem {
    inherit system;
    specialArgs = specialArgs // { inherit module-common specialArgs systemConfiguration; nixSystemName = "iso"; };
    modules = [
      ./iso
      module-common
    ];
  };
  isos = {
    isoRaw = genIso null;
  } // (lib.mapAttrs' (n: v: lib.nameValuePair "iso-${n}" (genIso { inherit n v; })) systemConfigurations);
in {
  nixosConfigurations = systemConfigurations // isos;
  inherit isos;
}
