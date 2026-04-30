{
  pkgs,
  ...
}:

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
    # pgcli TODO: add back when not broken anymore
    postman
    (python3.withPackages (
      python-pkgs: with python-pkgs; [
        pwntools
        requests
      ]
    ))
    qemu
    quickemu
    texlive.combined.scheme-full

    llvmPackages_latest.clang-manpages
    llvmPackages_latest.llvm-manpages

    # Misc
    agenix
    audacity
    blender
    cowsay
    desmume
    dnsutils
    dragon-drop
    eza
    ferdium
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
    it-tools
    jellyfin-desktop
    ldapvi
    libnotify
    libqalculate
    libreoffice-fresh
    logseq
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
    proton-vpn
    protonmail-desktop
    prusa-slicer
    pv
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
