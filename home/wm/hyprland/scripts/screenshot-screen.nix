{ pkgs, ... }:

pkgs.writeShellScript "screenshot-screen" ''
  ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -o)" - | ${pkgs.swappy}/bin/swappy -f -
''
