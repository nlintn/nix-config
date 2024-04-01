{
  description = "UwU";

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
      userSettings = {
        default-font = "JetBrainsMono Nerd Font";
        catppuccin-flavour = "macchiato";
        enable-kde = false;
        wallpaper = "~/Pictures/Wallpapers/cat_peek_purple_full.jpg";
        lockscreen = "~/Pictures/Wallpapers/landscape-anime-digital-art-fantasy-art-wallpaper.png";
        wm = "hyprland";
      };
    in {
      nixosConfigurations = {
        meoww = lib.nixosSystem {
          inherit system;
          modules = [ ./configuration.nix ];
          specialArgs = {
            inherit inputs;
            inherit userSettings;
          };
        };
      };
      homeConfigurations = {
        nico = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home
          ];
          extraSpecialArgs = {
            inherit inputs;
            inherit userSettings;
          };
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hycov = {
      url = "github:nlintn/hycov";
      inputs.hyprland.follows = "hyprland";
    };
    split-monitor-workspaces = {
      url = "github:nlintn/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
      inputs.systems.follows = "hyprland/systems";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
      inputs.systems.follows = "hyprland/systems";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    catppuccin-grub = {
      url = "github:catppuccin/grub";
      flake = false;
    };

    catppuccin-zsh-syntax-highlighting = {
      url = "github:catppuccin/zsh-syntax-highlighting";
      flake = false;
    };  
    gdb-ptrfind = {
      url = "github:ChaChaNop-Slide/ptrfind";
      flake = false;
    };
  };
}
