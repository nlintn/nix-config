{ config, pkgs, userSettings, ... }:

{
  system.stateVersion = "25.11";

  imports = [
    ./audio.nix
    ./bootloader.nix
    ./disko
    ./displaymanager.nix
    ./hardware-configuration.nix
    ./hardware-extra.nix
    ./network-configuration.nix
    ./nix-configuration.nix
    ./programs.nix
    ./services.nix

    ./hyprland.nix

    ./users/nico.nix
  ];

  colorScheme = userSettings.colorScheme;

  nixpkgs.config = {
    allowUnfree = true;
  };

  boot = {
    # initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;

    tmp = {
      useTmpfs = true;
      tmpfsHugeMemoryPages = "within_size";
    };
  };

  console = {
    # earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    colors = with config.colorScheme.palette; [
      base00 base08 base0B base0A base0D base0E base0C base07
      base04 base08 base0B base0A base0D base0E base0C base05
    ];
  };

  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };

  security.polkit.enable = true;
}
