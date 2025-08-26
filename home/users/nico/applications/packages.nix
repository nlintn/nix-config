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
    texlive.combined.scheme-full

    # Misc
    # anki TODO: add back when working again
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
    libqalculate
    libreoffice-fresh
    linux-wifi-hotspot
    lolcat
    nixln-edit
    nix-diff
    nix-inspect
    nix-output-monitor
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
}
