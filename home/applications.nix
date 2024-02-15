{ pkgs, inputs, ... }:

{
  imports = [ 
    ./applications/zsh/zsh.nix
    ./applications/alacritty.nix
    ./applications/tmux.nix
    ./applications/fzf.nix

    ./applications/vim.nix
    ./applications/vscode.nix

    ./applications/git.nix
    ./applications/ssh.nix
    ./applications/opam.nix
    ./applications/feh.nix
  ];

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # Coding stuff
    clang_17 clang-tools_17
    cmake
    gdb pwndbg
    doctest
    cargo
    (python3.withPackages ( python-pkgs: [
      python311Packages.pwntools
    ]))
    jetbrains.idea-ultimate
    gitkraken # github-desktop
    nil

    # Misc
    htop
    firefox-wayland
    discord
    thunderbird
    spotify-tui
    gimp
    libqalculate
    tree
    wl-clipboard

    # Meme stuff
    neofetch
    # uwufetch curr not working :(( 
    lolcat
  ];

  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;

  services.spotifyd = {
    enable = true;
    settings = {
      device_name = "meoww";
    };
  };  

  home.file.".gdbinit".text = ''
    source ${inputs.gdb-ptrfind + "/ptrfind.py"}
  '';
}