{ config, pkgs, lib, inputs, userSettings, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
      theme = inputs.catppuccin-grub + "/src/catppuccin-${userSettings.catppuccin-flavour}-grub-theme/";
      # extraConfig = "GRUB_CMDLINE_LINUX=\"vt.default_red=36,237,166,238,138,245,139,184,91,237,166,238,138,245,139,165 vt.default_grn=39,135,218,212,173,189,213,192,96,135,218,212,173,189,213,173 vt.default_blu=58,150,149,159,244,230,202,224,120,150,149,159,244,230,202,203\"";
    };
    efi.canTouchEfiVariables = true;
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

  services.xserver = if userSettings.enable-kde == true then {
    enable = true;

    ## -------------------------------------
    # KDE Plasma
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    displayManager.defaultSession = "plasmawayland";
    xkb.layout = "de";
    xkb.variant = "";
    ## -------------------------------------

    ## -------------------------------------
    # GNOME
    # displayManager.gdm.enable = true;
    # desktopManager.gnome.enable = true;
    ## -------------------------------------
 
    # libinput.enable = false;
    # synaptics.enable = true;
  } else {
    /* enable = true;
    displayManager = { 
      defaultSession = "hyprland"; 
      lightdm = { 
        enable = true; 
      }; 
    };*/
  };

  services.greetd = lib.mkIf (userSettings.wm == "hyprland") {
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

  # Configure console keymap
  console = {
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
    wireplumber.enable = true;
  };
  
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # User Managment
  users.users.nico = {
    isNormalUser = true;
    description = "nico UwU";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  security.polkit.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    man-pages linux-manual man-pages-posix
    
    powertop
    vim 
    wget
    psmisc
  ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };
  # programs.dconf.enable = userSettings.wm == "hyprland";
  services.blueman.enable = userSettings.wm == "hyprland";
  services.gnome.gnome-keyring.enable = userSettings.wm == "hyprland";
  services.upower.enable = userSettings.wm == "hyprland";
  programs.gnome-disks.enable = userSettings.wm == "hyprland";
  services.gvfs.enable = userSettings.wm == "hyprland";
  services.tumbler.enable = userSettings.wm == "hyprland";
  services.gnome.evolution-data-server.enable = userSettings.wm == "hyprland";
  services.gnome.gnome-online-accounts.enable = userSettings.wm == "hyprland";

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    konsole
    oxygen
  ];

  programs = {
    zsh.enable = true;
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

  programs.kdeconnect = {
    enable = true;
  };

  networking.firewall = { 
    enable = true;
  };

  hardware.opentabletdriver.enable = true;

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
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      # intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; NIXOS_OZONE_WL = "1"; }; # Force intel-media-driver

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
    extra-trusted-substituters = ["https://hyprland.cachix.org"];
    extra-trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  system.stateVersion = "24.05";
}
