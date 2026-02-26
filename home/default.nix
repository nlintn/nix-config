{
  home-manager,
  lib,
  pkgs,
  specialArgs,
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
    extraSpecialArgs = specialArgs // {
      hmUsername = n;
    };
  }
)
