bindkey -v "^[[1;3C" forward-word
bindkey -v "^[[1;5C" forward-word
bindkey -v "^[[1;3D" backward-word
bindkey -v "^[[1;5D" backward-word
bindkey -v "^[^?" backward-delete-word
bindkey -v "^[^H" backward-delete-word
bindkey -v "^[[3;3~" delete-word
bindkey -v "^[[3;6~" delete-word

autoload -U history-search-end &&
  zle -N history-beginning-search-backward-end history-search-end &&
  zle -N history-beginning-search-forward-end history-search-end &&
  bindkey -v "${terminfo[kcuu1]}" history-beginning-search-backward-end &&
  bindkey -v "${terminfo[kcud1]}" history-beginning-search-forward-end

KEYTIMEOUT=1
bindkey -v "${terminfo[kbs]}" backward-delete-char

autoload edit-command-line &&
  zle -N edit-command-line &&
  bindkey -a "^V" edit-command-line
