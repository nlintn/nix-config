{ pkgs }:

{
  package = pkgs.vimUtils.buildVimPlugin {
    name = "isabelle-syn-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "Treeniks";
      repo = "isabelle-syn.nvim";
      rev = "bdad5814efede6496e1c416e7154ccd5021281a2";
      sha256 = "sha256-9z/TwOPeT1zazywvzm2ajGu8jigkoUoi1gEsnSzjzgY=";
    };
  };
}
