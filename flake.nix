{
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      agenix,
      home-manager,
      nixpkgs-overlay,
      nix-colors,
      ...
    }@inputs:
    let
      system = "x86_64-linux"; # default system
      lib = nixpkgs.lib;
      lib-stable = nixpkgs-stable.lib;
      lib' = nixpkgs-overlay.lib;
      overlays = [
        agenix.overlays.default
        nixpkgs-overlay.overlays.default
      ];
      pkgs-unstable = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
      pkgs-stable = import nixpkgs-stable {
        inherit system overlays;
        config.allowUnfree = true;
      };
      pkgs = pkgs-unstable;
      assets = lib.readDir ./assets |> lib.mapAttrs (n: _: builtins.path { path = "${./assets}/${n}"; });
      inherit (import ./secrets lib) hostSecrets userSecrets;
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
        inherit
          inputs
          overlays
          lib'
          assets
          hostSecrets
          userSecrets
          userSettings
          pkgs-unstable
          pkgs-stable
          ;
        hmSubmodules = import ./home/submodules.nix lib;
      }
      // inputs;
      hosts = import ./hosts {
        inherit
          lib
          lib-stable
          system
          specialArgs
          ;
      };
      home = import ./home {
        inherit
          home-manager
          lib
          pkgs
          specialArgs
          ;
      };
    in
    {
      nixosConfigurations = hosts.nixosConfigurations;
      homeConfigurations = home;
      packages = lib'.eachSystem (
        _:
        let
          isos = lib.mapAttrs (_: v: v.config.system.build.isoImage) hosts.isos;
        in
        isos // { default = isos.isoRaw; }
      );
      checks = lib'.eachSystemPkgs nixpkgs (pkgs: rec {
        build = pkgs.callPackage ./check-build.nix { inherit self; };
        default = build;
      });
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    nixpkgs-overlay = {
      url = "github:nlintn/nixpkgs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";
  };
}
