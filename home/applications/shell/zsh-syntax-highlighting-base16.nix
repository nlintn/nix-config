{ config }:

# source: https://github.com/catppuccin/zsh-syntax-highlighting

with config.colorScheme.palette;
if config.programs.zsh.syntaxHighlighting.enable == true then ''
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
  typeset -gA ZSH_HIGHLIGHT_STYLES
  
  # Main highlighter styling: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
  #
  ## General
  ### Diffs
  ### Markup
  ## Classes
  ## Comments
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#${base04}'
  ## Constants
  ## Entitites
  ## Functions/methods
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#${base0B}'
  ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#${base0B}'
  ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#${base0B}'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#${base0B}'
  ZSH_HIGHLIGHT_STYLES[command]='fg=#${base0B}'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#${base0B},italic'
  ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#${base09},italic'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#${base09}'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#${base09}'
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#${base0E}'
  ## Keywords
  ## Built ins
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#${base0B}'
  ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#${base0B}'
  ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#${base0B}'
  ## Punctuation
  ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#${base0F}'
  ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#${base05}'
  ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#${base05}'
  ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#${base05}'
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#${base0F}'
  ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#${base0F}'
  ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#${base0F}'
  ## Serializable / Configuration Languages
  ## Storage
  ## Strings
  ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#${base0A}'
  ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#${base0A}'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#${base0A}'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#${base08}'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#${base0A}'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#${base08}'
  ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#${base0A}'
  ## Variables
  ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#${base05}'
  ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#${base08}'
  ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#${base05}'
  ZSH_HIGHLIGHT_STYLES[assign]='fg=#${base05}'
  ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#${base05}'
  ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#${base05}'
  ## No category relevant in spec
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#${base08}'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#${base05},underline'
  ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#${base0F},underline'
  ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#${base05},underline'
  ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#${base0F},underline'
  ZSH_HIGHLIGHT_STYLES[globbing]='fg=#${base05}'
  ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#${base0E}'
  #ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=?'
  #ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=?'
  #ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=?'
  #ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=?'
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#${base08}'
  ZSH_HIGHLIGHT_STYLES[redirection]='fg=#${base05}'
  ZSH_HIGHLIGHT_STYLES[arg0]='fg=#${base05}'
  ZSH_HIGHLIGHT_STYLES[default]='fg=#${base05}'
  ZSH_HIGHLIGHT_STYLES[cursor]=' '
''
else ""
