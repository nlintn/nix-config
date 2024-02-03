{
  description = "UwU";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin-grub = {
      url = "github:catppuccin/grub";
      flake = false;
    };

    catppuccin-zsh-syntax-highlighting = {
      url = "github:catppuccin/zsh-syntax-highlighting";
      flake = false;
    };  
    catppuccin-alacritty = {
      url = "github:catppuccin/alacritty";
      flake = false;
    };
    aengelke-gdbinit = {
      url = "https://aengelke.net/.gdbinit";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
      userSettings = {
        catppuccin-flavour = "macchiato";
      };
    in {
      nixosConfigurations = {
        meoww = lib.nixosSystem {
          inherit system;
          modules = [ ./configuration.nix ];
          specialArgs = {
            inherit inputs;
          };
        };
      };
      homeConfigurations = {
        nico = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            inherit inputs;
            inherit userSettings;
          };
        };
      };
    };
}
