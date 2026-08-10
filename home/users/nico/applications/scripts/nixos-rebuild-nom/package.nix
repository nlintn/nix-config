{
  lib,
  nix-output-monitor,
  nixos-rebuild-ng,
  osConfig ? null,
  writeShellScriptBin,
  ...
}:

let
  nixos-rebuild = osConfig.system.build.nixos-rebuild or nixos-rebuild-ng;
in
writeShellScriptBin "nixos-rebuild" ''
  set -o pipefail
  ${lib.getExe nixos-rebuild} --log-format internal-json $@ |& ${lib.getExe nix-output-monitor} --json
''
