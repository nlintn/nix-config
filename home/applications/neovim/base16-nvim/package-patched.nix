{ pkgs }:

pkgs.vimUtils.buildVimPlugin {
  name = "base16-nvim";
  src = pkgs.fetchFromGitHub {
    owner = "RRethy";
    repo = "base16-nvim";
    rev = "eec6882101dd189117f79c5d18d389d20cfc0415";
    hash = "sha256-p3HWYasmi0gVUM5l9jLWL4Iy37Uxnvbj3SO/cMCpDBg=";
  };
  patches = [ ./color-changes.patch ];
}
