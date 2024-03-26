{ pkgs, inputs, ... }:

{
  imports = [ 
    ./alacritty
    ./firefox.nix
    ./fzf.nix
    ./git.nix
    ./neovim
    ./obs-studio.nix
    ./opam.nix
    ./ssh.nix
    # ./tmux.nix
    ./vim.nix
    ./vscode.nix
    ./zellij.nix
    ./zsh
  ];

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # Coding stuff
    cargo
    # clang-tools_17
    gdb
    github-desktop
    gitkraken
    /* (python3.withPackages ( python-pkgs: [
      python311Packages.pwntools
    ])) */
    jetbrains.idea-ultimate
    nil
    # pwndbg

    # Misc
    anki
    copyq
    desmume
    gimp
    btop
    libqalculate
    lolcat
    neofetch
    spotify
    spotify-tray
    telegram-desktop
    thunderbird
    tree
    vesktop
    wl-clipboard
    zoom-us
  ];

  programs.zathura.enable = true;
  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

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
    source ${inputs.gdb-ptrfind}/ptrfind.py
  '';
}
