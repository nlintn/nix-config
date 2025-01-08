{ pkgs, inputs, ... }:

{
  imports = [ 
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./kitty
    ./librewolf.nix
    ./neovim
    ./obs-studio.nix
    ./shell
    ./ssh.nix
    ./thunderbird.nix
    ./vlc.nix
    ./vscode.nix
    ./yazi.nix
    ./zellij.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "jitsi-meet-1.0.8043"
    ];
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
    lean4
    ocamlPackages.utop
    postgresql
    pwndbg
    (python3.withPackages ( python-pkgs: with python-pkgs; [
      pwntools
      requests
    ]))
    texlive.combined.scheme-full

    # Misc
    anki
    blender
    copyq
    # desmume
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
    jq
    keepassxc
    libqalculate
    libreoffice-fresh
    lolcat
    nixln-edit
    nix-tree
    nmap
    obsidian
    pdfarranger
    pdftk
    poppler_utils
    prismlauncher
    prusa-slicer
    rclone
    ripgrep
    speedread
    spotify
    spotify-tray
    sshfs
    telegram-desktop
    tree
    ungoogled-chromium
    unzip
    vesktop
    wireshark
    wl-clipboard
    xdragon
    xournalpp
    yubioath-flutter
    zoom-us
    zulip
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
