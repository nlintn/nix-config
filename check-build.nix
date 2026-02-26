{
  lib,
  stdenv,
  symlinkJoin,

  self,
}:

symlinkJoin {
  name = "check-build";
  paths =
    (lib.attrsToList self.homeConfigurations |> lib.map (s: s.value.activationPackage))
    ++ (lib.attrsToList self.nixosConfigurations |> lib.map (s: s.value.config.system.build.toplevel))
    ++ (lib.attrsToList self.packages.${stdenv.hostPlatform.system} |> lib.map (s: s.value));
}
