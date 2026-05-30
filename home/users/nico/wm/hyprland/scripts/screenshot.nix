{
  config,
  grimblast,
  lib,
  writeShellScript,
  ...
}:

writeShellScript "screenshot" /* sh */ ''
  set -euo pipefail
  ${lib.getExe grimblast} --freeze save ''${1} - | ${lib.getExe config.programs.swappy.package} -f -
''
