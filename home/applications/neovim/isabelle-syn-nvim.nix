{ pkgs }:

{
  package = pkgs.vimUtils.buildVimPlugin {
    name = "isabelle-syn-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "Treeniks";
      repo = "isabelle-syn.nvim";
      rev = "114b06dc34edf1707be7249b5a3815733e68d4c9";
      sha256 = "sha256-f04jyExUwos9w89IeKbRdRMtWIsQYe0McAUoijq7mCA=";
    };
  };
}
