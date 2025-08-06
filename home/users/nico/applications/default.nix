{ lib, osConfig, pkgs, ... }:

{
  imports = [
    ./packages.nix

    ./bat
    ./firefox.nix
    ./fzf.nix
    ./gdb.nix
    ./git.nix
    ./gpg.nix
    ./keepassxc
    ./kitty
    ./neovim
    ./obs-studio.nix
    ./shell
    ./ssh.nix
    ./thunar.nix
    ./thunderbird.nix
    ./vlc.nix
    ./yazi.nix
    ./zellij.nix
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
    zathura.enable = true;
  };

  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
    playerctld.enable = true;
    protonmail-bridge.enable = true;
  };
}
