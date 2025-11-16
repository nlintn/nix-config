{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Coding stuff
    ansible
    atac
    bear
    bviplus
    coq
    ghidra
    ghostscript
    gnumake
    jetbrains.idea-ultimate
    ocamlPackages.utop
    postgresql
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
    audacity
    blender
    cowsay
    desmume
    dig
    file
    fractal
    gimp
    gnome-clocks
    hieroglyphic
    imagemagick
    image-roll
    inkscape
    ipinfo
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
    pdfarranger
    pdftk
    poppler-utils
    prismlauncher
    protonmail-desktop
    # protonvpn-gui TODO: add back when fixed
    prusa-slicer
    rclone
    signal-desktop
    speedread
    spotify
    spotify-tray
    sshfs
    telegram-desktop
    unar
    usbutils
    wev
    wireshark
    wl-clipboard
    dragon-drop
    xournalpp
    yubioath-flutter
  ];
}
