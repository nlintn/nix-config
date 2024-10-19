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
    ./vim.nix
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

  home.packages = with pkgs; let
    vlc = (pkgs.symlinkJoin {
      name = "vlc";
      paths = [ pkgs.vlc ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/vlc \
          --unset DISPLAY
        mv $out/share/applications/vlc.desktop{,.orig}
        substitute $out/share/applications/vlc.desktop{.orig,} \
          --replace-fail Exec=${pkgs.vlc}/bin/vlc Exec=$out/bin/vlc
      '';
    }); 
  in [
    # Coding stuff
    atac
    bear
    coq
    gdb
    ghidra
    ghostscript
    isabelle2024-nvim-lsp
    jetbrains.idea-ultimate
    lazygit
    lean4
    ocamlPackages.utop
    postgresql
    pwndbg
    (python3.withPackages ( python-pkgs: with python-pkgs; [
      pillow
      pwntools
      requests
    ]))
    texlive.combined.scheme-full

    # Misc
    anki
    btop
    copyq
    desmume
    dig
    element-desktop
    fastfetch
    fd
    inkscape
    gimp
    gnome-clocks
    image-roll
    libqalculate
    libreoffice-fresh
    lolcat
    nixln-edit
    nix-tree
    obsidian
    pdfarranger
    pdftk
    poppler_utils
    prismlauncher
    prusa-slicer
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
    vlc
    wl-clipboard
    xdragon
    xournalpp
    zoom-us
  ];

  programs.zathura.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;

  services.playerctld.enable = true;

  home.file.".gdbinit".text = ''
    source ${inputs.gdb-ptrfind}/ptrfind.py
  '';
}
