{ pkgs, config }:

pkgs.writeShellScriptBin "xdg-terminal-exec" /* ''
  if [[ $# -gt 0 ]] then
    ${config.programs.alacritty.package}/bin/alacritty --command $@
  else
    ${config.programs.alacritty.package}/bin/alacritty
  fi 
'' */
''
  ${config.programs.kitty.package}/bin/kitty --detach $@
''
