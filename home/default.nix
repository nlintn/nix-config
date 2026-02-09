{ home-manager, pkgs, specialArgs }:

(builtins.readDir ./users) |> builtins.mapAttrs (n: _:
  home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      ./users/${n}
      ./common.nix
    ];
    extraSpecialArgs = specialArgs // { hmUsername = n; };
  }
)
