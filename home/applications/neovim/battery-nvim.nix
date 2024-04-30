{ pkgs }:

{
  package = pkgs.vimUtils.buildVimPlugin {
    name = "battery-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "justinhj";
      repo = "battery.nvim";
      rev = "007d7943e28d1fc8c49a46c3a9c3b3f34975a0c2";
      sha256 = "sha256-i0MqxcnMtmA7dM47/NbHKkFpIjKki5Q2Dg6OHjazUD4=";
    };
  };
}
