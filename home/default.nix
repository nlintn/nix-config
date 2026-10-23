{
  genSpecialArgs,
  home-manager,
  lib,
  pkgs,
}:

(lib.readDir ./users)
|> lib.mapAttrs (
  n: _:
  home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      ./users/${n}
      ./common.nix
    ];
    extraSpecialArgs = genSpecialArgs {
      hmUsername = n;
    };
  }
)
