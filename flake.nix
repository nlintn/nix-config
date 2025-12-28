{
  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, nixpkgs-overlay, nix-colors, ... } @ inputs:
    let
      system = "x86_64-linux"; # default system
      lib = nixpkgs.lib;
      libStable = nixpkgs-stable.lib;
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
      hosts = import ./hosts {
        inherit lib libStable system specialArgs;
      };
      home = import ./home {
        inherit home-manager pkgs specialArgs;
      };
    in {
      nixosConfigurations = hosts.nixosConfigurations;
      homeConfigurations = home;
      packages = lib'.eachSystem nixpkgs (_: let
        isos = builtins.mapAttrs (_: v: v.config.system.build.isoImage) hosts.isos;
      in isos // { default = isos.isoRaw; });
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

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
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
