autoload -U colors
colors

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt "$bg[blue]$fg[black]%m %p$reset_color"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format "${fg[yellow]}%d${reset_color}"
zstyle ':completion:*:warnings' format "${fg[red]}No matches for:${reset_color} %d"

bindkey "$terminfo[kcbt]" reverse-menu-complete

bindkey "^[[1;3C" forward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;3D" backward-word
bindkey "^[[1;5D" backward-word
bindkey "^[^?" backward-delete-word
bindkey "^[^H" backward-delete-word

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

copy() {
  if [ "$#" = "0" ]; then
    local formatted="$($_cmd_base64 -w 0 /dev/stdin)"
  else
    local arg="$@"
    local formatted="$(builtin printf %s $arg | $_cmd_base64 -w 0)"
  fi
  builtin printf "\e]52;c;%s${terminfo[bel]}" "$formatted"
}

paste() {
  if which wl-paste &>/dev/null; then
    wl-paste
  else
    builtin printf "\e]52;c;?${terminfo[bel]}" > /dev/tty

    local -A result
    read -d "\\" result < /dev/tty
    if [ "${result:0:7}" != "$(printf "\e]52;c;")" ]; then
      builtin echo "paste failed" >&2
      return 1
    fi

    if [ "$1" != "widget" ]; then
      builtin printf "${terminfo[dl1]}" > /dev/tty
    fi

    $_cmd_base64 -dw 0 <<< "${result:7:-1}"
  fi
}

wrap_clipboard_widgets_copy() {
  local widget
  local wrapped_name
  for widget in "$@"; do
    wrapped_name="_zsh-vi-copy-${widget}"
    eval "
      ${wrapped_name}() {
        zle .${widget}
        copy \"\$CUTBUFFER\"
      }
    "
    zle -N "${widget}" "${wrapped_name}"
  done
}
wrap_clipboard_widgets_paste() {
  local widget
  local wrapped_name
  for widget in "$@"; do
    wrapped_name="_zsh-vi-paste-${widget}"
    eval "
      ${wrapped_name}() {
        CUTBUFFER=\"\$(paste widget 2>/dev/null || builtin echo \$CUTBUFFER)\"
        zle .${widget}
      }
    "
    zle -N "${widget}" "${wrapped_name}"
  done
}

wrap_clipboard_widgets_copy \
    vi-yank vi-yank-eol vi-yank-whole-line \
    vi-change vi-change-eol vi-change-whole-line \
    vi-kill-line vi-kill-eol vi-backward-kill-word \
    vi-delete vi-backward-delete-char
wrap_clipboard_widgets_paste \
    vi-put-{before,after} \
    put-replace-selection
unset -f wrap_clipboard_widgets_{copy,paste}
