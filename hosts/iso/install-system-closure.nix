{ closureStorePath, writeShellScriptBin }:

writeShellScriptBin "install-system" ''
  nixos-install --system ${closureStorePath} $@
''
