{ lib
, symlinkJoin
, system

, self
}:

symlinkJoin {
  name = "check-build";
  paths =
    (lib.attrsToList self.homeConfigurations  |> builtins.map (s: s.value.activationPackage)) ++
    (lib.attrsToList self.nixosConfigurations |> builtins.map (s: s.value.config.system.build.toplevel)) ++
    (lib.attrsToList self.packages.${system}  |> builtins.map (s: s.value));
}
