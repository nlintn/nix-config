{ writeShellScriptBin, config }:

writeShellScriptBin "xdg-terminal-exec" ''
  ${config.programs.kitty.package}/bin/kitty --detach $@
''
