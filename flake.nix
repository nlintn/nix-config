{
  outputs = { self, nixpkgs, home-manager, nixpkgs-overlay, nix-colors, ... } @ inputs:
    let
      system = "x86_64-linux"; # default system
      lib = nixpkgs.lib;
      lib' = nixpkgs-overlay.lib;
      overlays = [ nixpkgs-overlay.overlays.default ];
      pkgs = import nixpkgs { inherit system overlays; config.allowUnfree = true; };
      assets = builtins.readDir ./assets |> builtins.mapAttrs (n: _: builtins.path { path = "${./assets}/${n}"; });
      userSettings = {
        colorScheme = nix-colors.colorSchemes.catppuccin-macchiato;
        default-font = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
        };
        lockscreen = assets."lockscreen.png";
        wallpaper = assets."wallpaper.jpg";
        rel-config-path = "nix-config";
        wm = "hyprland";
      };
      specialArgs = {
        inherit inputs overlays lib' assets userSettings;
        config-store-path = builtins.path { path = self; };
        hmSubmodules = import ./home/submodules.nix;
      } // inputs;
    in {
      nixosConfigurations = import ./hosts {
        inherit lib system specialArgs;
      };
      homeConfigurations = import ./home {
        inherit home-manager pkgs specialArgs;
      };
      packages = lib'.eachSystem nixpkgs (_: rec {
        iso = self.nixosConfigurations.iso.config.system.build.isoImage;
        default = iso;
      });
      checks = lib'.eachSystemPkgs nixpkgs (pkgs: rec {
        build = pkgs.callPackage ./check-build.nix { inherit self; };
        default = build;
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
      inputs.pre-commit-hooks-nix.follows = "";
    };

    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    nvim-config = {
      url = "github:nlintn/nvim-config";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-overlay.follows = "nixpkgs-overlay";
    };
  };
}
