{
  assets,
  lib,
  modulesPath,
  pkgs,
  ...
}:

{
  system.stateVersion = "26.05";

  imports = [
    (modulesPath + "/profiles/minimal.nix")
    (modulesPath + "/profiles/headless.nix")

    ./disko
    ./hardware-configuration.nix
    ./network-configuration.nix
    ./nix-configuration.nix
    ./remote-unlock.nix
    ./tailscale.nix
    ./users.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  boot.loader.grub.enable = true;

  security.sudo = {
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

  environment.systemPackages = with pkgs; [
    dnsutils
    htop
    molly-guard
    psmisc
    tcpdump
  ];

  programs = {
    tmux = {
      enable = true;
      baseIndex = 1;
      keyMode = "vi";
    };
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };
}
