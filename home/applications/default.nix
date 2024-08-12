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

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # Coding stuff
    bear
    gdb
    github-desktop
    gitkraken
    isabelle2024-nvim-lsp
    jetbrains.idea-ultimate
    ocamlPackages.utop
    pwndbg
    (python3.withPackages ( python-pkgs: [
      python311Packages.pwntools
    ]))
    texlive.combined.scheme-full

    # Misc
    anki
    btop
    copyq
    desmume
    element-desktop
    fastfetch
    inkscape
    gimp
    gnome.gnome-clocks
    image-roll
    libqalculate
    libreoffice-fresh
    lolcat
    nixln-edit
    nix-tree
    obsidian
    speedread
    spotify
    spotify-tray
    telegram-desktop
    tree
    ungoogled-chromium
    unzip
    vesktop
    (pkgs.symlinkJoin {
      name = "vlc";
      paths = [ pkgs.vlc ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/vlc \
          --unset DISPLAY
      '';
    })
    wl-clipboard
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
