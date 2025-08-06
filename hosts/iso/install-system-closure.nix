{ closureStorePath, systemName, writeShellScriptBin }:

writeShellScriptBin "install-system-${systemName}" ''
  nixos-install --system ${closureStorePath} $@
''
