{
  defaultSystem,
  genSpecialArgs,
  lib,
  lib-stable,
  lib-unstable,
}:

let
  module-common = import ./common.nix;
  systemConfigurations = lib.mapAttrs (
    n: _:
    let
      buildConfig = import ./systems/${n}/build-config.nix;
      lib' =
        (if buildConfig.use-nixpkgs-stable or false then lib-stable else lib-unstable)
          buildConfig.system;
      system = buildConfig.system;
      specialArgs = genSpecialArgs system {
        inherit module-common;
        nixSystemName = n;
      };
    in
    lib'.nixosSystem {
      inherit system specialArgs;
      modules = [
        ./systems/${n}
        module-common
      ];
    }
  ) (lib.readDir ./systems);
  genIso =
    system: systemConfiguration:
    let
      specialArgs = genSpecialArgs system {
        inherit module-common systemConfiguration;
        nixSystemName = "iso-${systemConfiguration.name or "raw"}";
      };
    in
    lib.nixosSystem {
      inherit system specialArgs;
      modules = [
        ./iso
        module-common
      ];
    };
  isos =
    system:
    {
      isoRaw = genIso system null;
    }
    // (lib.mapAttrs' (
      n: v: lib.nameValuePair "iso-${n}" (genIso system (lib.nameValuePair n v))
    ) systemConfigurations);
in
{
  nixosConfigurations = systemConfigurations // (isos defaultSystem);
  inherit isos;
}
