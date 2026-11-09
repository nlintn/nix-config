{
  outputs =
    {
      agenix,
      home-manager,
      jail-nix,
      nix-colors,
      nixpkgs,
      nixpkgs-overlay,
      nixpkgs-stable,
      self,
      ...
    }@inputs:
    let
      defaultSystem = "x86_64-linux";
      lib = inputs.nixpkgs.lib;
      lib-custom = nixpkgs-overlay.lib;
      overlays = [
        (import ./jail-nix jail-nix)
        agenix.overlays.default
        nixpkgs-overlay.overlays.default
      ];

      # Hopefully possible to do this a bit less cursed with Nix 2.35
      patchFlake =
        src: patches: system:
        if patches == [ ] then
          src
        else
          let
            patchedSrc = (
              src.legacyPackages.${system}.applyPatches {
                name = "source";
                inherit src patches;
              }
            );
            self =
              let
                inputs = src.inputs;
                outputs = (import "${patchedSrc.outPath}/flake.nix").outputs { inherit self; };
                sourceInfo = src.sourceInfo // {
                  inherit (patchedSrc) outPath;
                };
              in
              inputs
              // outputs
              // sourceInfo
              // {
                inherit inputs outputs sourceInfo;
                _type = "flake";
              };
          in
          self;
      importPkgs =
        flake: system:
        import (flake system) {
          inherit system overlays;
          config = {
            allowUnfree = true;
          };
        };

      patches-stable = [ ];
      nixpkgs-stable-patched = patchFlake nixpkgs-stable patches-stable;
      lib-stable = system: (nixpkgs-stable-patched system).lib;
      pkgs-stable = importPkgs nixpkgs-stable-patched;

      patches-unstable = [
        ./patches/555876.patch
      ];
      nixpkgs-unstable-patched = patchFlake nixpkgs patches-unstable;
      lib-unstable = system: (nixpkgs-unstable-patched system).lib;
      pkgs-unstable = importPkgs nixpkgs-unstable-patched;

      assets = lib.readDir ./assets |> lib.mapAttrs (n: _: builtins.path { path = "${./assets}/${n}"; });
      inherit (import ./secrets lib) hostSecrets userSecrets;
      userSettings = {
        colorScheme = nix-colors.colorSchemes.catppuccin-macchiato;
        default-font = {
          name = "JetBrainsMono Nerd Font";
          getPackage = pkgs: pkgs.nerd-fonts.jetbrains-mono;
        };
        lockscreen = assets."lockscreen.png";
        wallpaper = assets."wallpaper.jpg";
        rel-config-path = "nix-config";
        wm = "hyprland";
      };

      genSpecialArgs =
        system: extraAttrs:
        let
          inputs' = inputs // {
            nixpkgs-stable-patched = nixpkgs-stable-patched system;
            nixpkgs-unstable-patched = nixpkgs-unstable-patched system;
          };
          specialArgs = {
            inherit
              assets
              hostSecrets
              lib-custom
              overlays
              specialArgs
              userSecrets
              userSettings
              ;
            hmSubmodules = import ./home/submodules.nix lib;
            inputs = inputs';
            pkgs-stable = pkgs-stable system;
            pkgs-unstable = pkgs-unstable system;
          }
          // extraAttrs;
        in
        specialArgs;

      hosts = import ./hosts {
        inherit
          defaultSystem
          genSpecialArgs
          lib
          lib-stable
          lib-unstable
          ;
      };

      home = import ./home {
        inherit
          home-manager
          lib
          ;
        genSpecialArgs = genSpecialArgs defaultSystem;
        pkgs = pkgs-unstable defaultSystem;
      };
    in
    {
      nixosConfigurations = hosts.nixosConfigurations;
      homeConfigurations = home;
      packages = lib-custom.eachSystemPkgs nixpkgs (
        pkgs:
        pkgs.callPackages ./packages.nix {
          inherit (hosts) isos;
          inherit self;
        }
      );
      checks = lib-custom.eachSystemPkgs nixpkgs (pkgs: rec {
        build = pkgs.callPackage ./check-build.nix { inherit self; };
        default = build;
      });
    };

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    nixpkgs-stable.url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.zst";

    nixpkgs-overlay = {
      url = "github:nlintn/nixpkgs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
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

    jail-nix.url = "sourcehut:~alexdavid/jail.nix";

    nix-colors.url = "github:misterio77/nix-colors";
  };
}
