{ pkgs, inputs, ... }:

{
  imports = [ 
    ./alacritty
    ./firefox.nix
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./kitty
    ./neovim
    ./obs-studio.nix
    ./opam.nix
    ./shell
    ./ssh.nix
    ./thunderbird.nix
    ./vim.nix
    ./vscode.nix
    ./zellij.nix
  ];

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # Coding stuff
    gdb
    github-desktop
    gitkraken
    isabelle
    jetbrains.idea-ultimate
    pwndbg
    (python3.withPackages ( python-pkgs: [
      python311Packages.pwntools
    ]))
    texlive.combined.scheme-full

    # Misc
    anki
    copyq
    desmume
    element-desktop
    fastfetch
    gimp
    btop
    libqalculate
    lolcat
    obsidian
    spotify
    spotify-tray
    telegram-desktop
    tree
    vesktop
    wl-clipboard
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
