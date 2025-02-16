{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  # boot.kernelParams = [ "i915.force_probe=46a6" ];

  networking.hostName = "meoww";

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

  services.logind = {
    powerKey = "suspend";
    lidSwitch = "suspend";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk  
    ];
    config.common.default = "*";
  };

  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
    touchpad.accelProfile = "adaptive";
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format \"%d. %b %Y %H:%M:%S\" --asterisks --user-menu --remember --remember-session --sessions ${config.programs.hyprland.package}/share/wayland-sessions";
        user = "greeter";
      };
    };
  };
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  # Configure console keymap
  console = {
    # keyMap = "neoqwertz";
    keyMap = "de";
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
  };

  # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    # alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    wireplumber = {
      enable = true;
      extraConfig = { };
    };
  };
  
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # User Managment
  users.users.nico = {
    isNormalUser = true;
    description = "nico UwU";
    extraGroups = [ "networkmanager" "wheel" "docker" "wireshark" ];
    shell = pkgs.zsh;
  };

  security.polkit.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    man-pages linux-manual man-pages-posix
    
    powertop
    sbctl
    vim
    wget
    psmisc
  ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  services = {
    blueman.enable = true;
    # gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    pcscd.enable = true;
    tumbler.enable = true;
    upower.enable = true;
  };

  programs = {
    ausweisapp = {
      enable = true;
      openFirewall = true;
    };
    # dconf.enable = true;
    java.enable = true;
    kdeconnect.enable = true;
    nix-ld.enable = true;
    # nix-ld.libraries = with pkgs; [];
    steam.enable = true;
    wireshark.enable = true;
    zsh.enable = true;
  };

  virtualisation.docker = {
    enable = true;
  };

  virtualisation.virtualbox = {
    host.enable = true;
  };

  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };

  networking.firewall = { 
    enable = true;
  };

  # hardware.opentabletdriver.enable = true;

  hardware.enableAllFirmware = true;
  # Power Management
  # powerManagement.enable = true;
  # powerManagement.powertop.enable = true;
  services.thermald.enable = true;
  # services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      USB_AUTOSUSPEND = 0;
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
    package = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system}.mesa.drivers;
    package32 = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system}.pkgsi686Linux.mesa.drivers;
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "i965"; NIXOS_OZONE_WL = "1"; }; # Force intel-media-driver

  environment.etc.hosts.mode = "0644";

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    extra-trusted-substituters = [ "https://hyprland.cachix.org" ];
    extra-trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    extra-trusted-users = [ "@wheel" ];
  };

  system.stateVersion = "25.05";
}
