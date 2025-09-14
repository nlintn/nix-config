{ config, ... }:

{
  programs.git = {
    enable = true;
    userName = "Nico Lintner";
    userEmail = "118087966+nlintn@users.noreply.github.com";
    extraConfig = {
      pull.ff = "only";
      push.autoSetupRemote = true;

      merge.tool = "nvim";
      mergetool = {
        prompt = false;
        "nvim".cmd = ''${config.home.sessionVariables.NVIM} -c "DiffviewOpen"'';
      };

      user.signingkey = "620394D5D26C67A8";
      commit.gpgsign = true;
      tag.gpgsign = true;
      push.gpgsign = "if-asked";

      column.ui = "auto";
      help.autocorrect = "prompt";
      status.branch = true;

      branch.sort = "-committerdate";
      tag.sort = "-version:refname";

      maintenance.auto = true;
      maintenance.strategy = "incremental";
    };
    lfs.enable = true;
  };
}
