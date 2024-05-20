{
  description = "UwU";

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
      userSettings = {
        catppuccin-flavour = "macchiato"; # for apps whose theme I haven't ported to base16 yet
        colorScheme = inputs.nix-colors.colorSchemes.catppuccin-macchiato;
        default-font = "JetBrainsMono Nerd Font";
        enable-kde = false;
        lockscreen = builtins.toString ./etc/lockscreen.png;
        wallpaper = builtins.toString ./etc/wallpaper.jpg;
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

    hyprland.url = "github:hyprwm/Hyprland";
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

    nix-colors.url = "github:misterio77/nix-colors";

    catppuccin-grub = {
      url = "github:catppuccin/grub";
      flake = false;
    };

    gdb-ptrfind = {
      url = "github:ChaChaNop-Slide/ptrfind";
      flake = false;
    };
  };
}
