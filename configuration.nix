{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader = {
    # systemd-boot.enable = true;
    grub.enable = true;
    grub.efiSupport = true;
    grub.device = "nodev";
    grub.useOSProber = true;
    grub.theme = inputs.catppuccin-grub + "/src/catppuccin-macchiato-grub-theme/";
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "meoww";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "en_DK.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    enable = true;

    ## -------------------------------------
    ## KDE Plasma
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    displayManager.defaultSession = "plasmawayland";
    xkb.layout = "de";
    xkb.variant = "";
    ## -------------------------------------

    ## -------------------------------------
    ## GNOME
    # displayManager.gdm.enable = true;
    # desktopManager.gnome.enable = true;
    ## -------------------------------------
 
    # libinput.enable = false;
    # synaptics.enable = true;
  };

  # Configure console keymap
  console.keyMap = "de";

  # Sound
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
  };
  nixpkgs.config.pulseaudio = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  users.users.nico = {
    isNormalUser = true;
    description = "nico UwU";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    gcc
    gnumake
    # llvmPackages_17.libcxxClang clang-tools_17 llvmPackages_17.libcxx llvmPackages_17.stdenv
    
    man-pages linux-manual man-pages-posix

    vim 
    wget
  ];

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    # plasma-browser-integration
    konsole
    # oxygen
  ];

  programs = {
    zsh.enable = true;
    # zsh.loginShellInit = "neofetch";
    nix-ld.enable = true;
    # nix-ld.libraries = with pkgs; [];
    java.enable = true;
    steam.enable = true;
  };

  virtualisation.docker = {
    enable = true;
  };

  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };

  networking.firewall = { 
    enable = true;
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
