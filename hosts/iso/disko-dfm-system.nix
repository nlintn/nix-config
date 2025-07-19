{ disko-config-path, systemName, disko, lib, writeShellScriptBin }:

writeShellScriptBin "disko-dfm-${systemName}" ''
  ${disko}/bin/disko -m destroy,format,mount ${lib.escapeShellArg disko-config-path} $@
''
