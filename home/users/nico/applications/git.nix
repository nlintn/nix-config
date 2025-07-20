{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Nico Lintner";
    userEmail = "118087966+nlintn@users.noreply.github.com";
    extraConfig = {
      pull.ff = "only";

      user.signingkey = "0D77816AE7FD9289E44A5405F68094C6AF089B92";
      commit.gpgsign = true;
      tag.gpgsign = true;
      push.gpgsign = "if-asked";
    };
    lfs.enable = true;
  };
}
