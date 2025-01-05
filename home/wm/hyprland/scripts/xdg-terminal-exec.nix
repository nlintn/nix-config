{ pkgs, config }:

pkgs.writeShellScriptBin "xdg-terminal-exec" ''
  ${config.programs.kitty.package}/bin/kitty --detach $@
''
