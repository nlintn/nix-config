{
  outputs = { self, nixpkgs, home-manager, nixpkgs-overlay, ... } @ inputs:
    let
      system = "x86_64-linux"; # default system
      lib = nixpkgs.lib;
      lib' = nixpkgs-overlay.lib;
      overlays = [ nixpkgs-overlay.overlays.default ];
      pkgs = import nixpkgs { inherit system overlays; config.allowUnfree = true; };
      userSettings = {
        colorScheme = inputs.nix-colors.colorSchemes.catppuccin-macchiato;
        default-font = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
        };
        lockscreen = builtins.path { path = ./etc/lockscreen.png; };
        rel-config-path = "nix-config";
        wallpaper = builtins.path { path = ./etc/wallpaper.jpg; };
        wm = "hyprland";
      };
      specialArgs = {
        inherit inputs self overlays lib' userSettings;
        config-store-path = builtins.path { path = self; };
      };
    in {
      nixosConfigurations = import ./hosts {
        inherit lib system specialArgs;
      };
      homeConfigurations = import ./home {
        inherit lib home-manager pkgs specialArgs;
      };
      packages = lib'.eachSystem nixpkgs (_: rec {
        iso = self.nixosConfigurations.iso.config.system.build.isoImage;
        default = iso;
      });
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-overlay = {
      url = "github:nlintn/nixpkgs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    pwndbg = {
      url = "github:pwndbg/pwndbg";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
