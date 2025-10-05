{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Coding stuff
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
    gimp
    gnome-clocks
    hieroglyphic
    htop
    image-roll
    inkscape
    ipinfo
    jq
    libnotify
    libqalculate
    libreoffice-fresh
    linux-wifi-hotspot
    lolcat
    nix-diff
    nix-inspect
    nix-output-monitor
    nix-tree
    nixln-edit
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
}
