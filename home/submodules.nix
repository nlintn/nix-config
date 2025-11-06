(builtins.readDir ./users) |> builtins.mapAttrs (n: _:
  { home-manager, specialArgs, ... }:

  {
    imports = [
      home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = specialArgs;

      sharedModules = [
        ./common.nix
        ./options.nix
      ];

      users.${n} = {
        imports = [ ./users/${n} ];
        _module.args.hmUsername = n;
      };
    };
  })
