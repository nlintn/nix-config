{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Nico Lintner";
    userEmail = "118087966+nlintn@users.noreply.github.com";
    extraConfig = {
      pull.ff = "only";
      # commit.gpgsign = true;
    };
  };
}
