{
  config,
  lib,
  pkgs,
  ...
}@args:

{
  vars.scripts = lib.removeAttrs (lib.fix (
    self:
    lib.packagesFromDirectoryRecursive {
      callPackage = (path: attrs: pkgs.callPackage path (args // attrs // self));
      directory = ./.;
    }
  )) [ "default" ];

  home.packages = lib.attrValues config.vars.scripts;
}
