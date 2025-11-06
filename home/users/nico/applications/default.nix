{ config, lib, osConfig ? null, pkgs, ... }:

{
  imports = [
    ./packages.nix

    ./bat.nix
    ./element-desktop.nix
    ./firefox
    ./fzf.nix
    ./gdb.nix
    ./ghostty
    ./git.nix
    ./gpg.nix
    ./keepassxc
    ./kitty
    ./lazygit.nix
    ./less.nix
    ./neovim.nix
    ./obs-studio.nix
    ./ssh.nix
    ./thunar.nix
    ./thunderbird.nix
    ./tmux.nix
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
      commandLineArgs = [ "--no-default-browser-check" ];
    };
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    evince.enable = true;
    java.enable = true;
    zoxide.enable = true;
  };

  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
      package = lib.mkIf (osConfig != null) osConfig.programs.kdeconnect.package;
    };
    playerctld.enable = true;
    protonmail-bridge = {
      enable = true;
      enableCfgScript = true;
      extraPackages = [ config.programs.keepassxc.package ];
    };
    systembus-notify.enable = true;
  };
}
