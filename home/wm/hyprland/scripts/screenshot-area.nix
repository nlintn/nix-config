{ pkgs, ... }:

pkgs.writeShellScript "screenshot-area" ''
  ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -d)" - | ${pkgs.swappy}/bin/swappy -f -
''
