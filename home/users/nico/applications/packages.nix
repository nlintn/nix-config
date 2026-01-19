{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Coding stuff
    ansible
    atac
    bear
    bviplus
    cyberchef
    ghidra
    ghostscript
    gnumake
    jetbrains.idea
    ocamlPackages.utop
    pgcli
    postman
    (python3.withPackages ( python-pkgs: with python-pkgs; [
      pwntools
      requests
    ]))
    qemu
    quickemu
    texlive.combined.scheme-full

    llvmPackages_latest.clang-manpages llvmPackages_latest.llvm-manpages

    # Misc
    agenix
    audacity
    blender
    cowsay
    desmume
    dnsutils
    dragon-drop
    eza
    file
    file-roller
    font-manager
    gimp
    gnome-characters
    gnome-clocks
    hieroglyphic
    imagemagick
    inkscape
    ipinfo
    jellyfin-desktop
    libnotify
    libqalculate
    libreoffice-fresh
    lolcat
    nix-diff
    nix-inspect
    nix-output-monitor
    nix-tree
    nixln-edit
    nmap
    openssl
    papers
    pdfarranger
    pdftk
    planify
    poppler-utils
    prismlauncher
    protonmail-desktop
    protonvpn-gui
    prusa-slicer
    showtime
    signal-desktop
    speedread
    spotify
    spotify-tray
    sshfs
    telegram-desktop
    traceroute
    unar
    usbutils
    wev
    wireshark
    xournalpp
    yubioath-flutter
  ];
}
