{ lib, home-manager, pkgs, specialArgs }:

lib.mapAttrs (n: _:
  home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [ ./users/${n} ];
    extraSpecialArgs = specialArgs;
  }
) (builtins.readDir ./users)
