{ ... }:

{
  imports = [ 
    ./home/applications.nix

    ./home/fonts.nix

    ./home/wm.nix
  ];

  home.username = "nico";
  home.homeDirectory = "/home/nico";
  
  home.sessionVariables = {
    DOT_DIR = "$HOME/dotfiles";
    NIXOS_OZONE_WL = "1";
  };

  systemd.user.startServices = true;

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
