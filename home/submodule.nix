hmUsers:

{ lib, inputs, specialArgs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = specialArgs;

  home-manager.users = lib.listToAttrs (builtins.map (user: {
    name = user;
    value = {
      imports = [ ./users/${user} ];
    };
  }) hmUsers);
}
