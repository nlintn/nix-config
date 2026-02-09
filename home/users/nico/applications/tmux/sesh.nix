{ config, lib, pkgs, ... }:

{
  vars.seshFzf = let
    fd = lib.getExe config.programs.fd.package;
    fzf = lib.getExe config.programs.fzf.package;
    rg = lib.getExe config.programs.ripgrep.package;
    sesh = lib.getExe config.programs.sesh.package;
    tmux = lib.getExe config.programs.tmux.package;
  in pkgs.writeShellScript "sesh-fzf" ''
    ${sesh} connect "$(
      ${sesh} list --icons | (${rg} -v '_popup_.*_.*_' || true) | ${fzf} --tmux center,75%,65% \
        --no-sort --ansi --border-label ' sesh ' --prompt '󱐋  ' \
        --header '  󰘴a all 󰘴t tmux 󰘴g configs 󰘴z zoxide 󰘴f find 󰘴x k-sess ^󰭜  k-serv' \
        --bind 'tab:down,btab:up' \
        --bind 'ctrl-a:change-prompt(󱐋  )+reload(${sesh} list --icons | ${rg} -v "_popup_.*_.*_" || true)' \
        --bind 'ctrl-t:change-prompt(  )+reload(${sesh} list -t --icons | ${rg} -v "_popup_.*_.*_" || true)' \
        --bind 'ctrl-g:change-prompt(  )+reload(${sesh} list -c --icons)' \
        --bind 'ctrl-z:change-prompt(󰉋  )+reload(${sesh} list -z --icons)' \
        --bind 'ctrl-f:change-prompt(  )+reload(${fd} -IL -t d . ~)' \
        --bind 'ctrl-x:execute(${tmux} kill-session -t {2..})+change-prompt(󱐋  )+reload(${sesh} list --icons | ${rg} -v "_popup_.*_.*_" || true)' \
        --bind 'ctrl-backspace:execute(${tmux} kill-server)+change-prompt(󱐋  )+reload(${sesh} list --icons | ${rg} -v "_popup_.*_.*_" || true)' \
        --preview-window 'right:60%' \
        --preview '${sesh} preview {}'
    )"
  '';

  programs.sesh = {
    enable = true;
    enableAlias = false;
    enableTmuxIntegration = false;
    fzfPackage = config.programs.fzf.package;
    zoxidePackage = config.programs.zoxide.package;
    settings = let
      ls = if config.home.shellAliases ? ls then config.home.shellAliases.ls else lib.getExe' pkgs.coreutils "ls";
      scratchpadName = "scratchpad 󱞂 ";
    in {
      dir_length = 2;
      default_session = {
        preview_command = "${lib.getExe pkgs.eza} --color=always --follow-symlinks --tree {}";
        startup_command = ls;
      };
      blacklist = [ scratchpadName ];
      session = [
        {
          name = "home";
          path = config.home.homeDirectory;
          startup_command = "${pkgs.writeShellScript "test" ''
            tmp="$(${lib.getExe' pkgs.coreutils "mktemp"} -t "yazi-tmux-sesh.XXXXX")"
            ${lib.getExe config.programs.yazi.package} "${config.home.homeDirectory}" --cwd-file="$tmp"
            if cwd="$(<"$tmp")"  && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]
            then
              ${lib.getExe config.programs.sesh.package} connect -- "$cwd"
            fi
            rm -f -- "$tmp"
          ''}";
        }
        {
          name = "nix-config 󱄅 ";
          path = config.home.sessionVariables.NIX_CONFIG_DIR;
          startup_command = " ${lib.getExe config.vars.nvimPackage} -c ':Telescope find_files'";
          preview_command = "${lib.getExe pkgs.eza} --color=always --follow-symlinks --tree {}";
          windows = [ "empty" ];
        }
        {
          name = scratchpadName;
          path = config.home.homeDirectory;
          startup_command = " ${lib.getExe config.vars.nvimPackage} -- ${config.xdg.userDirs.documents}/scratch.md";
          preview_command = "${lib.getExe config.programs.bat.package} --paging=never --color=always {}";
          windows = [ "empty" ];
        }
      ];
      window = [
        {
          name = "empty";
          startup_script = ls;
        }
      ];
    };
  };

  home.shellAliases.s = builtins.toString config.vars.seshFzf;
}
