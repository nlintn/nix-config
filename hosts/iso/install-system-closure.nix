{
  closureStorePath,
  lib,
  nixos-install,
  writeShellScriptBin,
}:

writeShellScriptBin "install-system" ''
  ${lib.getExe nixos-install} --system ${closureStorePath} $@
''
