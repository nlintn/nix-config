{ config, lib, pkgs, ... }:

let
  seshBin = lib.getExe config.programs.sesh.package;
  seshFzf = ''
    ${seshBin} connect "$(
      ${seshBin} list --icons | fzf --tmux 80%,70% \
        --no-sort --ansi --border-label ' sesh ' --prompt '󱐋  ' \
        --header '  󰘴a all 󰘴t tmux 󰘴g configs 󰘴x zoxide 󰘴d kill 󰘴f find' \
        --bind 'tab:down,btab:up' \
        --bind 'ctrl-a:change-prompt(󱐋  )+reload(${seshBin} list --icons)' \
        --bind 'ctrl-t:change-prompt(  )+reload(${seshBin} list -t --icons)' \
        --bind 'ctrl-g:change-prompt(  )+reload(${seshBin} list -c --icons)' \
        --bind 'ctrl-x:change-prompt(󰉋  )+reload(${seshBin} list -z --icons)' \
        --bind 'ctrl-f:change-prompt(  )+reload(${lib.getExe pkgs.fd} -IL -t d . ~)' \
        --bind 'ctrl-d:execute(${lib.getExe config.programs.tmux.package} kill-session -t {2..})+change-prompt(󱐋  )+reload(${seshBin} list --icons)' \
        --preview-window 'right:60%' \
        --preview '${seshBin} preview {}'
    )"'';
in {
  programs.tmux = {
    enable = true;
    mouse = true;
    clock24 = true;
    newSession = true;
    prefix = "C-a";
    keyMode = "vi";
    escapeTime = 0;
    focusEvents = true;

    extraConfig = ''
      set -g set-titles on
      set -g set-titles-string '#{pane_title}'

      set -g status-position top
      set -g status-justify absolute-centre
      set -g status-style "bg=default"
      set -g window-status-current-style "fg=blue bold"
      set -g status-left ""
      set -g status-right " #S"

      set -g allow-passthrough all
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM

      # Set new panes to open in current directory
      bind c new-window -c "#{pane_current_path}"
      bind - split-window -c "#{pane_current_path}"
      bind | split-window -h -c "#{pane_current_path}"

      bind r source-file "${config.xdg.configHome}/tmux/tmux.conf"
      bind b set -g status
      bind ü copy-mode
      bind x kill-pane # skip "kill-pane? (y/n)" prompt

      bind a run-shell "${lib.escape [ "\"" ] seshFzf }"

      bind g display-popup -b rounded -E -xC -yC -w 90% -h 90% -d "#{pane_current_path}" ${lib.getExe config.programs.lazygit.package}

      # vim like selection keys
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';
  };

  programs.sesh = {
    enable = true;
    enableAlias = false;
    enableTmuxIntegration = false;
    fzfPackage = config.programs.fzf.package;
    zoxidePackage = config.programs.zoxide.package;
  };

  programs.fzf.tmux.enableShellIntegration = true;
  home.shellAliases.s = seshFzf;
}
