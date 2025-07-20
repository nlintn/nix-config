{ config, pkgs, lib, inputs, ... }:

{
  imports = [ 
    ./bat
    ./firefox.nix
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./kitty
    ./neovim
    ./obs-studio.nix
    ./protonmail-bridge.nix
    ./shell
    ./ssh.nix
    ./thunderbird.nix
    ./vlc.nix
    ./yazi.nix
    ./zellij.nix
  ];

  nixpkgs.config = lib.mkIf (! config.submoduleSupport.enable) {
    allowUnfree = true;
    permittedInsecurePackages = [ ];
  };

  home.packages = with pkgs; [
    # Coding stuff
    atac
    bear
    bviplus
    coq
    gdb
    ghidra
    ghostscript
    gnumake
    # jetbrains.idea-ultimate
    lazygit
    ocamlPackages.utop
    postgresql
    postman
    (inputs.pwndbg.packages.${pkgs.system}.pwndbg)
    (python3.withPackages ( python-pkgs: with python-pkgs; [
      pwntools
      requests
    ]))
    qemu
    texlive.combined.scheme-full

    # Misc
    anki
    blender
    copyq
    cowsay
    desmume
    dig
    fastfetch
    fd
    file
    fractal-next
    inkscape
    gimp
    gnome-clocks
    htop
    image-roll
    ipinfo
    jq
    keepassxc
    libqalculate
    libreoffice-fresh
    linux-wifi-hotspot
    lolcat
    nixln-edit
    nix-inspect
    nix-tree
    nmap
    obsidian
    pdfarranger
    pdftk
    poppler_utils
    prismlauncher
    protonmail-desktop
    protonvpn-gui
    prusa-slicer
    rclone
    ripgrep
    signal-desktop
    speedread
    spotify
    spotify-tray
    sshfs
    telegram-desktop
    tree
    unar
    usbutils
    vesktop
    wev
    wireshark
    wl-clipboard
    xdragon
    xournalpp
    yubioath-flutter
  ];

  programs = {
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
    };
    zathura.enable = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  };

  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
    playerctld.enable = true;
  };

  home.file.".gdbinit".text = ''
    source ${(pkgs.fetchFromGitHub {
      owner = "ChaChaNop-Slide";
      repo = "ptrfind";
      rev = "c3f350e9e95b612330523c1515ea90ddace5c6e6";
      sha256 = "sha256-UoG/DDLlRdxH5r/jaNd7UuUEg7H9pfkpZBpAXkZBM98=";
    })}/ptrfind.py
  '';
}
