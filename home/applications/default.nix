{ pkgs, inputs, ... }:

{
  imports = [ 
    ./zsh
    ./alacritty.nix
    # ./tmux.nix
    ./fzf.nix

    ./vim.nix
    ./neovim
    ./vscode.nix

    ./firefox.nix
    ./git.nix
    ./ssh.nix
    ./opam.nix
    # ./feh.nix
  ];

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # Coding stuff
    cargo
    # clang_17 clang-tools_17
    gdb
    # github-desktop
    gitkraken
    (python3.withPackages ( python-pkgs: [
      python311Packages.pwntools
    ]))
    jetbrains.idea-ultimate
    nil
    pwndbg

    # Misc
    anki
    copyq
    gimp
    htop
    libqalculate
    lolcat
    neofetch
    spotify
    spotify-tray
    thunderbird
    tree
    vesktop
    wl-clipboard
  ];

  programs.zathura.enable = true;
  programs.gpg.enable = true;
  services.gpg-agent.enable = true;

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
