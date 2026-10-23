{
  isos,
  lib,
  pkgs,
  self,
}:

let
  isoImages = lib.mapAttrs (_: v: v.config.system.build.isoImage) (
    isos pkgs.stdenv.hostPlatform.system
  );
in
isoImages
// {
  default = isoImages.isoRaw;
}
// {
  scripts = lib.packagesFromDirectoryRecursive {
    callPackage = lib.callPackageWith (pkgs // { inherit self; });
    directory = ./scripts;
  };
}
