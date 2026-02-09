{
  disko-config-path,
  disko,
  lib,
  writeShellScriptBin,
}:

writeShellScriptBin "disko-dfm" ''
  ${lib.getExe disko} --no-deps -m destroy,format,mount ${lib.escapeShellArg disko-config-path} $@
''
