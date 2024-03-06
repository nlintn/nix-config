{ pkgs, inputs, ... }:

{
  imports = [ 
    ./applications/zsh/zsh.nix
    ./applications/alacritty.nix
    # ./applications/tmux.nix
    ./applications/fzf.nix

    ./applications/vim.nix
    ./applications/neovim.nix
    ./applications/vscode.nix

    ./applications/firefox.nix
    ./applications/git.nix
    ./applications/ssh.nix
    ./applications/opam.nix
    # ./applications/feh.nix
  ];

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # Coding stuff
    # clang_17 clang-tools_17
    gdb pwndbg
    cargo
    (python3.withPackages ( python-pkgs: [
      python311Packages.pwntools
    ]))
    jetbrains.idea-ultimate
    gitkraken # github-desktop
    nil

    # Misc
    htop
    vesktop # discord
    thunderbird
    spotify
    spotify-tray
    # spotify-tui
    gimp
    libqalculate
    tree
    wl-clipboard
    playerctl
    anki
    copyq

    # Meme stuff
    neofetch
    # uwufetch curr not working :(( 
    lolcat
  ];

  programs.zathura.enable = true;

  programs.imv = {
    enable = true;
    settings = {

    };
  };

  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;

  services.playerctld.enable = true;

  /*
  services.spotifyd = {
    enable = true;
    settings = {
      device_name = "meoww";
    };
  };
  */  

  home.file.".gdbinit".text = ''
    source ${inputs.gdb-ptrfind + "/ptrfind.py"}
  '';
}
