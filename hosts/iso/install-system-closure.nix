{ closurePath, lib, systemName, writeShellScriptBin }:

writeShellScriptBin "install-system-${systemName}" ''
  nixos-install --system ${lib.escapeShellArg closurePath} $@
''
