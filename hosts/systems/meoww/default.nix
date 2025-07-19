{ config, pkgs, ... }:

{
  imports = [
    ./bootloader.nix
    ./hardware-configuration.nix
    ./network-configuration.nix
    ./disko
    ./users
  ];

  hardware.i2c.enable = true;

  services.logind = {
    powerKey = "suspend";
    lidSwitch = "suspend";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
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

  # hardware.ipu6 = {
  #   enable = true;
  #   platform = "ipu6ep";
  # };

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

  programs.zsh.enable = true;

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

  services = {
    blueman.enable = true;
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
    java.enable = true;
    kdeconnect.enable = true;
    nix-ld.enable = true;
    # nix-ld.libraries = with pkgs; [];
    steam.enable = true;
    wireshark.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

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
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "i965"; NIXOS_OZONE_WL = "1"; }; # Force intel-media-driver

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
    settings.extra-trusted-users = [ "@wheel" ];
  };
}
