{ config, ... }:

{
  imports = [
    ./aliases
    ./starship.nix

    ./zsh
  ];


  programs.bash = {
    enable = true;
    historyFile = "${config.xdg.stateHome}";
  };

  programs.dircolors = {
    enable = true;
  };
}
