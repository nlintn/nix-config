{ lib, system, specialArgs }:

let
  systemConfigurations = lib.mapAttrs (n: _:
    lib.nixosSystem {
      system = import ./systems/${n}/system.nix;
      specialArgs = specialArgs // { inherit specialArgs; nixSystemName = n; };
      modules = [
        ./systems/${n}
        ./common.nix
      ];
    }
  ) (builtins.readDir ./systems);
in systemConfigurations // {
  iso = lib.nixosSystem {
    inherit system;
    specialArgs = specialArgs // { inherit systemConfigurations; nixSystemName = "iso"; };
    modules = [
      ./iso
      ./common.nix
    ];
  };
}
