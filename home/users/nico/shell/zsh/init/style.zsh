autoload -U colors &&
  colors

zstyle ':completion:*' completer _complete _match _ignored _files
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:warnings' format "${fg[red]}No matches for:${reset_color} %d"

zstyle ':fzf-tab:*' fzf-flags --border-label ' command ' --exact --height '~-2' --preview-window 'right:40%,~2'
zstyle ':fzf-tab:*' single-group color header
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
