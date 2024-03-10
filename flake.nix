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
        wallpaper = "nix-black-4k.png";
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
          ] ++ (if userSettings.wm == "hyprland" then [
            inputs.hyprland.homeManagerModules.default { wayland.windowManager.hyprland.enable = true; }
          ] else []);
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
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xdph.url = "github:hyprwm/xdg-desktop-portal-hyprland";

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
    zsh-nix-shell = {
      url = "github:chisui/zsh-nix-shell";
      flake = false;
    };
    gdb-ptrfind = {
      url = "github:ChaChaNop-Slide/ptrfind";
      flake = false;
    };
  };
}
