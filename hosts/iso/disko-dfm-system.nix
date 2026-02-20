{
  disko-config-path,
  disko,
  lib,
  writeShellScriptBin,
}:

writeShellScriptBin "disko-dfm" ''
  ${lib.getExe disko} -m destroy,format,mount ${lib.escapeShellArg disko-config-path} $@
''
