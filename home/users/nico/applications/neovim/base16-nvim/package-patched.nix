{ pkgs }:

pkgs.vimUtils.buildVimPlugin {
  name = "base16-nvim";
  src = pkgs.fetchFromGitHub {
    owner = "RRethy";
    repo = "base16-nvim";
    rev = "860f1cabe934de259c955792fca9d9a2fd8aea01";
    hash = "sha256-/Wus4s+jEhPsZfk5mmMSXkKbJhNsw7VllD0+YhrRgJA=";
  };
  patches = [ ./color-changes.patch ];
}
