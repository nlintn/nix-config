CURSOR_NORMAL='\e[2 q'
CURSOR_INSERT='\e[6 q'

__cursor_zle-keymap-select() {
  if [[ ${KEYMAP} == vicmd ]]; then
    echo -ne "${CURSOR_NORMAL}"
  elif [[ ${KEYMAP} == main ]] ||
    [[ ${KEYMAP} == viins ]] ||
    [[ ${KEYMAP} = '' ]]; then
    echo -ne "${CURSOR_INSERT}"
  fi
}
__index='zle-keymap-select'
if [[ -v widgets[${__index}] ]]; then
  __cursor_preserved_zle_keymap_select="${widgets[${__index}]#user:}"
fi

if [[ -z ${__cursor_preserved_zle_keymap_select:-} ]]; then
  zle -N zle-keymap-select __cursor_zle-keymap-select
else
  __cursor_zle-keymap-select-wrapped() {
    $__cursor_preserved_zle_keymap_select "$@"
    __cursor_zle-keymap-select "$@"
  }
  zle -N zle-keymap-select __cursor_zle-keymap-select-wrapped
fi

__cursor_zle-line-init() {
  echo -ne "${CURSOR_INSERT}"
}
__index='zle-line-init'
if [[ -v widgets[${__index}] ]]; then
  __cursor_preserved_zle_line_init="${widgets[${__index}]#user:}"
fi

if [[ -z ${__cursor_preserved_zle_line_init:-} ]]; then
  zle -N zle-line-init __cursor_zle-line-init
else
  __cursor_zle-line-init-wrapped() {
    $__cursor_preserved_zle_line_init "$@"
    __cursor_zle-line-init "$@"
  }
  zle -N zle-line-init __cursor_zle-line-init-wrapped
fi

unset __index

__cursor_preexec() {
  echo -ne "${CURSOR_NORMAL}"
}
preexec_functions+=(__cursor_preexec)
