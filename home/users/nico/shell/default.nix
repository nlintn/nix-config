{ config, ... }:

{
  imports = [
    ./aliases.nix
    ./starship.nix

    ./zsh
  ];

  programs.bash = {
    enable = true;
    historyFile = "${config.xdg.stateHome}/.bash_history";
  };

  programs.dircolors = {
    enable = true;
  };

  home.sessionVariables = {
    GROFF_NO_SGR = "1";
  };
}
