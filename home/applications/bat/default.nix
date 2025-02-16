{ config, ... }:

{
  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
    };
    themes = {
      "base16".src = import ./theme.nix { inherit config; };
    };
  };
}
