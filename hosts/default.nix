{ lib, libStable, system, specialArgs }:

let
  systemConfigurations = builtins.mapAttrs (n: _:
    let
      buildConfig = import ./systems/${n}/build-config.nix;
      lib' = if buildConfig.use-nixpkgs-stable or false then libStable else lib;
    in
      lib'.nixosSystem {
        system = buildConfig.system;
        specialArgs = specialArgs // { inherit specialArgs; nixSystemName = n; };
        modules = [
          ./systems/${n}
          ./common.nix
        ];
      }
  ) (builtins.readDir ./systems);
  genIso = systemConfiguration: lib.nixosSystem {
    inherit system;
    specialArgs = specialArgs // { inherit systemConfiguration; nixSystemName = "iso"; };
    modules = [
      ./iso
      ./common.nix
    ];
  };
  isos = {
    isoRaw = genIso null;
  } // (lib.mapAttrs' (n: v: lib.nameValuePair "iso-${n}" (genIso { inherit n v; })) systemConfigurations);
in {
  nixosConfigurations = systemConfigurations // isos;
  inherit isos;
}
