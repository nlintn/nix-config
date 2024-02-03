{ config, pkgs, ... }:

{
  imports = [ 
    ./home/applications/zsh/zsh.nix
    ./home/applications/alacritty.nix
    ./home/applications/tmux.nix

    ./home/applications/vim.nix
    ./home/applications/vscode.nix

    ./home/applications/git.nix
    ./home/applications/ssh.nix
    ./home/applications/opam.nix
    # ./home/wm/hyprland.nix
  ];

  home.username = "nico";
  home.homeDirectory = "/home/nico";

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # Coding stuff
    clang_17 clang-tools_17
    cmake
    gdb pwndbg
    doctest
    cargo
    python3
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
    scanmem
    # xorg.xrandr

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

  programs.lf.enable = true;

  home.file.".gdbinit".source = pkgs.fetchurl {
    url = "https://aengelke.net/.gdbinit";
    hash = "sha256-m+gaIUShS/edvrnftJZAzXQgtoux9BHok630PursCLA=";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
