{ disko-config-path, systemName, disko, lib, writeShellScriptBin }:

writeShellScriptBin "disko-dfm-${systemName}" ''
  ${lib.getExe disko} --no-deps -m destroy,format,mount ${lib.escapeShellArg disko-config-path} $@
''
