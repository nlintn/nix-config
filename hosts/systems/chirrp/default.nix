{
  modulesPath,
  pkgs,
  ...
}:

{
  system.stateVersion = "26.05";

  imports = [
    (modulesPath + "/profiles/minimal.nix")

    ./bootloader.nix
    ./container-setup.nix
    ./disko
    ./dnscrypt-proxy.nix
    ./hardware-configuration.nix
    ./hardware-extra.nix
    ./hw-accel.nix
    ./network-configuration.nix
    ./nix-configuration.nix
    ./passless-boot
    ./postgresql.nix
    ./users.nix
    ./zfs.nix

    ./web
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  security.sudo = {
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

  environment.systemPackages = with pkgs; [
    arp-scan
    dnsutils
    ffmpeg-headless
    htop
    intel-gpu-tools
    molly-guard
    powertop
    psmisc
    strace
    tcpdump
    zfs
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
    logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandlePowerKey = "ignore";
    };
    redis.package = pkgs.valkey;
    # smartd.enable = true; TODO
  };
}
