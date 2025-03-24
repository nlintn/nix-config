{ pkgs, inputs, ... }:

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

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ ];
  };

  home.packages = with pkgs; [
    # Coding stuff
    atac
    bear
    coq
    gdb
    ghidra
    ghostscript
    gnumake
    # isabelle2024-nvim-lsp
    jetbrains.idea-ultimate
    lazygit
    ocamlPackages.utop
    postgresql
    (inputs.pwndbg.packages.${pkgs.system}.pwndbg)
    (python3.withPackages ( python-pkgs: with python-pkgs; [
      pwntools
      requests
    ]))
    texlive.combined.scheme-full

    # Misc
    anki
    arp-scan
    blender
    copyq
    desmume
    dig
    element-desktop
    fastfetch
    fd
    file
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
    scanmem
    signal-desktop
    speedread
    spotify
    spotify-tray
    sshfs
    telegram-desktop
    tree
    ungoogled-chromium
    unzip
    usbutils
    vesktop
    wev
    wireshark
    wl-clipboard
    xdragon
    xournalpp
    yubioath-flutter
    zoom-us
    # zulip
  ];

  programs.zathura.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;

  services.playerctld.enable = true;

  home.file.".gdbinit".text = ''
    source ${(pkgs.fetchFromGitHub {
      owner = "ChaChaNop-Slide";
      repo = "ptrfind";
      rev = "c3f350e9e95b612330523c1515ea90ddace5c6e6";
      sha256 = "sha256-UoG/DDLlRdxH5r/jaNd7UuUEg7H9pfkpZBpAXkZBM98=";
    })}/ptrfind.py
  '';
}
