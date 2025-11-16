{ config, lib, pkgs, ... }:

let
  seshFzf = let
    fd = lib.getExe config.programs.fd.package;
    fzf = lib.getExe config.programs.fzf.package;
    rg = lib.getExe config.programs.ripgrep.package;
    sesh = lib.getExe config.programs.sesh.package;
    tmux = lib.getExe config.programs.tmux.package;
  in pkgs.writeShellScript "sesh-fzf" ''
    ${sesh} connect "$(
      ${sesh} list --icons | (${rg} -v '_popup_.*_' || true) | ${fzf} --tmux center,80%,70% \
        --no-sort --ansi --border-label ' sesh ' --prompt '󱐋  ' \
        --header '  󰘴a all 󰘴t tmux 󰘴g configs 󰘴x zoxide 󰘴d kill 󰘴f find' \
        --bind 'tab:down,btab:up' \
        --bind 'ctrl-a:change-prompt(󱐋  )+reload(${sesh} list --icons | ${rg} -v "_popup_.*_" || true)' \
        --bind 'ctrl-t:change-prompt(  )+reload(${sesh} list -t --icons | ${rg} -v "_popup_.*_" || true)' \
        --bind 'ctrl-g:change-prompt(  )+reload(${sesh} list -c --icons)' \
        --bind 'ctrl-x:change-prompt(󰉋  )+reload(${sesh} list -z --icons)' \
        --bind 'ctrl-f:change-prompt(  )+reload(${fd} -IL -t d . ~)' \
        --bind 'ctrl-d:execute(${tmux} kill-session -t {2..})+change-prompt(󱐋  )+reload(${sesh} list --icons)' \
        --preview-window 'right:60%' \
        --preview '${sesh} preview {}'
    )"'';
in {
  programs.tmux = {
    enable = true;
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

      set -g set-titles on
      set -g set-titles-string '#{pane_title}'

      set -g base-index 1
      set -g pane-base-index 1
      set -g renumber-windows on

      set -g status-position top
      set -g status-justify absolute-centre
      set -g status-style "bg=default"
      set -g window-status-current-style fg=#${base0D},bold
      set -g status-left "#T "
      set -g status-left-length 40
      set -g status-left-style bold
      set -g status-right " #S"
      set -g status-right-style bold
      set -g status-right-length 40

      set -g default-terminal "tmux-256color"
      set -g allow-passthrough all
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM

      set -g message-style bg=#${base0E},fg=#${base01}
      set -g message-command-style bg=#${base01},fg=#${base0E}
      set -g copy-mode-match-style bg=#${base09},fg=#${base01}
      set -g copy-mode-current-match-style bg=#${base08},fg=#${base01}
      set -g mode-style bg=#${base0F},fg=#${base00}

      # Set new panes to open in current directory
      bind c new-window -c "#{pane_current_path}"
      bind - split-window -c "#{pane_current_path}"
      bind | split-window -h -c "#{pane_current_path}"

      bind r source-file "${config.xdg.configHome}/tmux/tmux.conf"
      bind b set -g status
      bind ü copy-mode
      bind x kill-pane # skip "kill-pane? (y/n)" prompt

      bind a run-shell "${seshFzf}"

      bind g display-popup -b rounded -E -xC -yC -w 90% -h 90% -d "#{pane_current_path}" ${lib.getExe config.programs.lazygit.package}

      # vim like selection keys
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      bind -n C-Enter display-popup -b rounded -xC -yC -w 65% -h 65% -E ${let
        tmux = lib.getExe config.programs.tmux.package;
      in pkgs.writeShellScript "tmux-popup" ''
        session="_popup_$(${tmux} display -p '#S')_"

        if ! ${tmux} has -t "$session" 2> /dev/null; then
          session_id="$(${tmux} new-session -dP -s "$session" -F '#{session_id}')"
          ${tmux} set-option -s -t "$session_id" key-table _popup
          ${tmux} set-option -s -t "$session_id" status off
          # ${tmux} set-option -s -t "$session_id" prefix None
          ${tmux} set-environment -t "$session_id" FZF_TMUX 1
          session="$session_id"
        fi

        builtin exec ${tmux} attach -t "$session" > /dev/null
      ''}
      bind -T _popup Enter detach
      bind -T _popup C-[ copy-mode

      bind w choose-tree -Z -f '#{?#{m:_popup_*_,#{session_name}},0,1}'
      bind s choose-tree -Zs -f '#{?#{m:_popup_*_,#{session_name}},0,1}'
    '';
  };

  programs.sesh = {
    enable = true;
    enableAlias = false;
    enableTmuxIntegration = false;
    fzfPackage = config.programs.fzf.package;
    zoxidePackage = config.programs.zoxide.package;
    settings = {
      default_session = {
        preview_command = "${lib.getExe pkgs.eza} --color=always --follow-symlinks --tree {}";
      };
      session = [
        {
          name = "󱄅 nix-config";
          path = config.home.sessionVariables.NIX_CONFIG_DIR;
          startup_command = " ${lib.getExe config.vars.nvimPackage} -c ':Telescope find_files'";
        }
      ];
    };
  };

  home.shellAliases.s = builtins.toString seshFzf;
}
