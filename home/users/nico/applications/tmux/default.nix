{
  config,
  lib,
  pkgs,
  ...
}:

let
  tmux = lib.getExe config.programs.tmux.package;
  tmux-popup =
    name: exec:
    pkgs.writeShellScript "tmux-popup" ''
      session="_popup_${name}_$(${tmux} display -p '#S')_"

      if ! ${tmux} has -t "$session" 2> /dev/null; then
        session_id="$(${tmux} new-session -dP -s "$session" -F '#{session_id}' "${exec}; ${tmux} detach")"
        ${tmux} set-option -s -t "$session_id" key-table _popup_pre
        ${tmux} set-option -s -t "$session_id" status off
        ${tmux} set-option -s -t "$session_id" prefix None
        ${tmux} set-environment -t "$session_id" FZF_TMUX 1
        session="$session_id"
      fi

      ${tmux} attach -t "$session"
    '';
in
{
  imports = [
    ./sesh.nix
  ];

  programs.tmux = {
    enable = true;
    package = pkgs.tmux.overrideAttrs (prev: {
      patches = prev.patches or [ ] ++ [ ./get-clipboard.patch ];
    });
    extraConfig = with config.colorScheme.palette; ''
      unbind C-b
      set -g prefix C-a
      bind -n C-a send-prefix
      set -g status-keys vi
      set -g mode-keys vi
      set -g mouse on

      set -g focus-events on
      set -g aggressive-resize off
      set -g clock-mode-style 24
      set -g escape-time 0
      set -g history-limit 50000
      set -g detach-on-destroy off

      set -g set-titles on
      set -g set-titles-string '#{pane_title}'

      set -g base-index 1
      set -g pane-base-index 1
      set -g renumber-windows on

      set -g status-position top
      set -g status-justify absolute-centre
      set -g status-style "bg=default"
      set -g window-status-current-style fg=#${base0D},bold
      set -g status-left "#S "
      set -g status-left-style bold
      set -g status-left-length 40
      set -g status-right " #T"
      set -g status-right-style bold
      set -g status-right-length 40

      set -g default-terminal "tmux-256color"
      set -g allow-passthrough all
      set -g set-clipboard on
      set -g get-clipboard both
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM
      set -g extended-keys on

      set -g cursor-color '#${base06}'
      set -g prompt-cursor-color '#${base06}'

      set -g message-style bg=#${base0B},fg=#${base01}
      set -g message-command-style bg=#${base0A},fg=#${base01}
      set -g copy-mode-match-style bg=#${base09},fg=#${base01}
      set -g copy-mode-current-match-style bg=#${base08},fg=#${base01}
      set -g copy-mode-position-style bg=#${base0E},fg=#${base01},bold
      set -g copy-mode-selection-style bg=#${base06},fg=#${base01}
      set -g mode-style bg=#${base0E},fg=#${base01}

      # Set new panes to open in current directory
      bind -N "Create new window " c new-window -c "#{pane_current_path}"
      bind -N "Split window vertically " - split-window -c "#{pane_current_path}"
      bind -N "Split window horizontally " | split-window -h -c "#{pane_current_path}"

      bind -N "Reload config " r source-file "${config.xdg.configHome}/tmux/tmux.conf"
      bind -N "Toggle status " b set -g status
      bind -N "Enter copy mode " ü copy-mode
      bind -N "Kill current pane " x kill-pane # skip "kill-pane? (y/n)" prompt
      bind -N "Switch to last session " L run-shell "sesh last"
      bind -N "Switch to root session " 0 run-shell 'sesh connect --root "$(pwd)"'

      bind -N "Open sesh popup " a run-shell "${config.vars.seshFzf}"

      # vim like selection keys
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      bind -N "Open lazygit popup " g display-popup -b rounded -E -xC -yC -w 90% -h 90% -d "#{pane_current_path}" '${tmux-popup "lazygit" (lib.getExe config.programs.lazygit.package)}'

      bind -N "Open shell popup " Enter display-popup -b rounded -xC -yC -w 65% -h 65% -E '${tmux-popup "shell" "$SHELL"}'

      # set prefix in popup
      bind -T _popup_pre C-a switch-client -T _popup
      bind -T _popup d detach
      bind -T _popup a detach
      bind -T _popup g detach
      bind -T _popup Enter detach
      bind -T _popup [ copy-mode
      bind -T _popup ü copy-mode
      bind -T _popup x kill-pane

      bind -N "List windows " w choose-tree -Zw -f '#{?#{m:_popup_*_*_,#{session_name}},0,1}'
      bind -N "List sessions " s choose-tree -Zs -f '#{?#{m:_popup_*_*_,#{session_name}},0,1}'
    '';
  };
}
