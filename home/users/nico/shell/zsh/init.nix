{ pkgs, ... }:

/* sh */ ''
  zstyle ':completion:*' menu select
  bindkey "$terminfo[kcbt]" reverse-menu-complete
  zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
  setopt globdots

  autoload -U history-search-end
  zle -N history-beginning-search-backward-end history-search-end
  zle -N history-beginning-search-forward-end history-search-end
  bindkey "$terminfo[kcuu1]" history-beginning-search-backward-end
  bindkey "$terminfo[kcud1]" history-beginning-search-forward-end

  KEYTIMEOUT=1
  bindkey -v "$terminfo[kbs]" backward-delete-char

  autoload edit-command-line &&
  zle -N edit-command-line &&
  bindkey -a "^V" edit-command-line

  function wrap_clipboard_widgets() {
    local verb="$1"
    shift
    local widget
    local wrapped_name
    for widget in "$@"; do
      wrapped_name="_zsh-vi-''${verb}-''${widget}"
      if [ "''${verb}" = copy ]; then
        eval "
          function ''${wrapped_name}() {
            zle .''${widget}
            builtin printf %s \"\''${CUTBUFFER}\" | ${pkgs.wl-clipboard}/bin/wl-copy 2>/dev/null || true
          }
        "
      else
        eval "
          function ''${wrapped_name}() {
            CUTBUFFER=\"\$(${pkgs.wl-clipboard}/bin/wl-paste 2>/dev/null || builtin echo \$CUTBUFFER)\"
            zle .''${widget}
          }
        "
      fi
      zle -N "''${widget}" "''${wrapped_name}"
    done
  }
  wrap_clipboard_widgets copy \
      vi-yank vi-yank-eol vi-yank-whole-line \
      vi-change vi-change-eol vi-change-whole-line \
      vi-kill-line vi-kill-eol vi-backward-kill-word \
      vi-delete vi-delete-char vi-backward-delete-char
  wrap_clipboard_widgets paste \
      vi-put-{before,after} \
      put-replace-selection
  unfunction wrap_clipboard_widgets
''
