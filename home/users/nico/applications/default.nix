{ config, lib, osConfig, pkgs, ... }:

{
  imports = [
    ./packages.nix

    ./bat.nix
    ./firefox
    ./fzf.nix
    ./gdb.nix
    ./git.nix
    ./gpg.nix
    ./less.nix
    ./keepassxc
    ./kitty
    ./neovim
    ./obs-studio.nix
    ./ssh.nix
    ./thunar.nix
    ./thunderbird.nix
    ./vlc.nix
    ./yazi.nix
    ./zathura.nix
  ];

  nixpkgs.config = lib.mkIf (!(osConfig.home-manager.useGlobalPkgs or false)) {
    allowUnfree = true;
    permittedInsecurePackages = [ ];
  };

  programs = {
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
    };
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    evince.enable = true;
    lazygit = {
      enable = true;
      settings.git.overrideGpg = true;
    };
  };

  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
    playerctld.enable = true;
    protonmail-bridge = {
      enable = true;
      enableCfgScript = true;
      extraPackages = [ config.programs.keepassxc.package ];
    };
  };
}
