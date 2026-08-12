{
  config,
  lib,
  pkgs,
  ...
}:

let
  fzf = lib.getExe config.programs.fzf.package;
  rg = lib.getExe config.programs.ripgrep.package;
  tmux = lib.getExe config.programs.tmux.package;
  xdg-open = lib.getExe' pkgs.xdg-utils "xdg-open";

  genTmuxPopup =
    name: exec:
    pkgs.writeShellScript "tmux-popup" ''
      session="_popup_${name}_$(${tmux} display -p '#S')_"

      if ! ${tmux} has -t "$session" 2> /dev/null; then
        session_id="$(${tmux} new-session -dP -s "$session" -F '#{session_id}' "${exec}; ${tmux} detach")"
        ${tmux} set-option -s -t "$session_id" key-table _popup_root
        ${tmux} set-option -s -t "$session_id" status off
        ${tmux} set-option -s -t "$session_id" prefix None
        ${tmux} set-environment -t "$session_id" FZF_TMUX 1
        session="$session_id"
      fi

      ${tmux} attach -t "$session"
    '';

  searchUrls = pkgs.writeShellScript "tmux-search-urls" /* sh */ ''
    tmux capture-pane -Jp \
      | ${rg} -o --color=never '.*?((?:\w+:\/|~)?\/[\w()@:%\+-.~#?&\/=]+)' -r '$1' \
      | ${fzf} --ansi --border-label ' url ' --header '  ^y copy ^o open' --bind 'ctrl-o:execute(${xdg-open} {})' --bind 'ctrl-y:execute(${tmux} set-buffer -w {})' \
      || :
  '';
in
{
  imports = [
    ./sesh.nix
  ];

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    extraConfig = with config.colorScheme.palette; ''
      unbind C-b
      set -g prefix C-a
      bind -n C-a send-prefix
      set -g status-keys emacs
      set -g mode-keys vi
      set -g mouse on

      set -g focus-events on
      set -g aggressive-resize off
      set -g clock-mode-style 24
      set -g escape-time 0
      set -g history-limit 50000
      set -g detach-on-destroy off
      set -g copy-mode-line-numbers hybrid

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

      set -g allow-passthrough on
      set -g set-clipboard on
      set -g get-clipboard request
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM
      set -ga update-environment HYPRLAND_INSTANCE_SIGNATURE
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

      bind -N "Open lazygit popup " g display-popup -b rounded -E -xC -yC -w 90% -h 90% -d "#{pane_current_path}" '${genTmuxPopup "lazygit" (lib.getExe config.programs.lazygit.package)}'

      bind -N "Open shell popup " Enter display-popup -b rounded -xC -yC -w 65% -h 65% -E '${genTmuxPopup "shell" "$SHELL"}'

      # set prefix in popup
      bind -T _popup_root MouseDown1Pane            select-pane -t = \; send-keys -M
      bind -T _popup_root MouseDown1Status          switch-client -t =
      bind -T _popup_root MouseDown1ScrollbarUp     copy-mode -u
      bind -T _popup_root MouseDown1ScrollbarDown   copy-mode -d
      bind -T _popup_root MouseDown2Pane            select-pane -t = \; if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" { send-keys -M } { paste-buffer -p }
      bind -T _popup_root MouseDrag1Pane            if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" { send-keys -M } { copy-mode -M }
      bind -T _popup_root MouseDrag1ScrollbarSlider copy-mode -S
      bind -T _popup_root MouseDrag1Border          resize-pane -M
      bind -T _popup_root WheelUpPane               if-shell -F "#{||:#{alternate_on},#{pane_in_mode},#{mouse_any_flag}}" { send-keys -M } { copy-mode -e }
      bind -T _popup_root WheelUpStatus             previous-window
      bind -T _popup_root WheelDownStatus           next-window
      bind -T _popup_root DoubleClick1Pane          select-pane -t = \; if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" { send-keys -M } { copy-mode -H ; send-keys -X select-word ; run-shell -d 0.3 ; send-keys -X copy-pipe-and-cancel }
      bind -T _popup_root TripleClick1Pane          select-pane -t = \; if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" { send-keys -M } { copy-mode -H ; send-keys -X select-line ; run-shell -d 0.3 ; send-keys -X copy-pipe-and-cancel }

      bind -T _popup_root C-a switch-client -T _popup

      bind -T _popup d detach
      bind -T _popup a detach
      bind -T _popup g detach
      bind -T _popup Enter detach
      bind -T _popup [ copy-mode
      bind -T _popup ü copy-mode
      bind -T _popup x kill-pane

      bind -N "List windows " w choose-tree -Zw -f '#{?#{m:_popup_*_*_,#{session_name}},0,1}'
      bind -N "List sessions " s choose-tree -Zs -f '#{?#{m:_popup_*_*_,#{session_name}},0,1}'

      bind -T copy-mode-vi i switch-client -T copy-mode-vi-seq-i
      bind -T copy-mode-vi-seq-i w send-keys -X select-word
      bind -T copy-mode-vi-seq-i W send-keys -X clear-selection \; send-keys -X previous-space \; send-keys -X begin-selection \; send-keys -X next-space-end
      bind -T copy-mode-vi-seq-i b send-keys -X clear-selection \; send-keys -X jump-to-backward '(' \; send-keys -X begin-selection \; send-keys -X jump-to-forward ')'
      bind -T copy-mode-vi-seq-i ( send-keys -X clear-selection \; send-keys -X jump-to-backward '(' \; send-keys -X begin-selection \; send-keys -X jump-to-forward ')'
      bind -T copy-mode-vi-seq-i ) send-keys -X clear-selection \; send-keys -X jump-to-backward '(' \; send-keys -X begin-selection \; send-keys -X jump-to-forward ')'
      bind -T copy-mode-vi-seq-i B send-keys -X clear-selection \; send-keys -X jump-to-backward '{' \; send-keys -X begin-selection \; send-keys -X jump-to-forward '}'
      bind -T copy-mode-vi-seq-i \{ send-keys -X clear-selection \; send-keys -X jump-to-backward '{' \; send-keys -X begin-selection \; send-keys -X jump-to-forward '}'
      bind -T copy-mode-vi-seq-i \} send-keys -X clear-selection \; send-keys -X jump-to-backward '{' \; send-keys -X begin-selection \; send-keys -X jump-to-forward '}'
      bind -T copy-mode-vi-seq-i [ send-keys -X clear-selection \; send-keys -X jump-to-backward '[' \; send-keys -X begin-selection \; send-keys -X jump-to-forward ']'
      bind -T copy-mode-vi-seq-i ] send-keys -X clear-selection \; send-keys -X jump-to-backward '[' \; send-keys -X begin-selection \; send-keys -X jump-to-forward ']'
      bind -T copy-mode-vi-seq-i < send-keys -X clear-selection \; send-keys -X jump-to-backward '<' \; send-keys -X begin-selection \; send-keys -X jump-to-forward '>'
      bind -T copy-mode-vi-seq-i > send-keys -X clear-selection \; send-keys -X jump-to-backward '<' \; send-keys -X begin-selection \; send-keys -X jump-to-forward '>'
      bind -T copy-mode-vi-seq-i ` send-keys -X clear-selection \; send-keys -X jump-to-backward '`' \; send-keys -X begin-selection \; send-keys -X jump-to-forward '`'
      bind -T copy-mode-vi-seq-i \' send-keys -X clear-selection \; send-keys -X jump-to-backward "'" \; send-keys -X begin-selection \; send-keys -X jump-to-forward "'"
      bind -T copy-mode-vi-seq-i \" send-keys -X clear-selection \; send-keys -X jump-to-backward '"' \; send-keys -X begin-selection \; send-keys -X jump-to-forward '"'
      bind -T copy-mode-vi-seq-i l send-keys -X clear-selection \; send-keys -X back-to-indentation \; send-keys -X begin-selection \; send-keys -X end-of-line \; send-keys -X cursor-left \; send-keys -X other-end

      bind -N "Search pane for URLs " f run-shell -b ${searchUrls}
    '';
  };
}
