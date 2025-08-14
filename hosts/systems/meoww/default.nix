{ config, pkgs, self, userSettings, ... }:

{
  system.stateVersion = "25.11";

  imports = [
    ./bootloader.nix
    ./disko
    ./displaymanager.nix
    ./hardware-configuration.nix
    ./network-configuration.nix

    ./users/nico.nix
  ];

  colorScheme = userSettings.colorScheme;

  nixpkgs.config = {
    allowUnfree = true;
  };

  boot = {
    # initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    blacklistedKernelModules = [ "intel-ipu6-isys" ];
  };

  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsHugeMemoryPages = "within_size";
  nix.settings.build-dir = "/var/tmp";
  systemd.services.nix-daemon.environment."TMPDIR" = config.nix.settings.build-dir;

  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    flags = [ "--update-input" "nixpkgs" "-L" "--no-write-lock-file" ];
    flake = self.outPath;
  };

  console = {
    # earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    colors = with config.colorScheme.palette; [
      base00 base08 base0B base0A base0D base0E base0C base07
      base04 base08 base0B base0A base0D base0E base0C base05
    ];
  };

  time.hardwareClockInLocalTime = true;

  hardware.i2c.enable = true;

  services.logind = {
    powerKey = "suspend";
    lidSwitch = "suspend";
  };

  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
    touchpad.accelProfile = "adaptive";
  };

  # hardware.ipu6 = {
  #   enable = true;
  #   platform = "ipu6ep";
  # };

  # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
    alsa.enable = false;
    jack.enable = false;
  };
  services.pulseaudio.enable = false;
  
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.printing = {
    enable = true;
    browsing = true;
    defaultShared = true;
    # drivers = [ pkgs.cupsDrivers.generic ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    man-pages linux-manual man-pages-posix

    arp-scan
    powertop
    psmisc
    sbctl
    tcpdump
  ];

  programs.hyprland = {
    enable = true;
  };
  programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

  services = {
    blueman.enable = true; # bluetooth manager
    gvfs.enable = true; # for hot plugging usb storage etc
    pcscd.enable = true; # smart cards
    tumbler.enable = true; # thumbnails
    upower.enable = true;
  };

  programs = {
    ausweisapp = {
      enable = true;
      openFirewall = true;
    };
    java.enable = true;
    kdeconnect.enable = true;
    nix-ld.enable = true;
    # nix-ld.libraries = with pkgs; [];
    steam.enable = true;
    wireshark.enable = true;
    xfconf.enable = true;
    zsh.enable = true;
  };
  environment.etc."vimrc".text = ''
    let &t_SI = "\e[6 q"
    let &t_EI = "\e[2 q"
  '';

  virtualisation.virtualbox = {
    host = {
      enable = true;
      # enableExtensionPack = true;
    };
  };

  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };

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
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "i965"; }; # Force intel-media-driver

  nix = {
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
