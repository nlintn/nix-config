local user='%{$fg[cyan]%}[%{$fg[green]%}%n@%m%{$reset_color%}%{$fg[cyan]%}]'
local pwd='%{$fg_bold[blue]%}%~%{$reset_color%}'
local arrow_top='%{$fg[cyan]%}╭─%{$reset_color%}'
local arrow_bot='%{$fg[cyan]%}╰─➤%{$reset_color%}'
local return_code='%(?.%{$fg[green]%}.%{$fg[red]%}%? )↵%{$reset_color%}'
local git_branch='$(git_prompt_status)%{$reset_color%}$(git_prompt_info)%{$reset_color%}'

ZSH_THEME_RVM_PROMPT_OPTIONS="i v g"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"

ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg[green]%}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"

PROMPT="${arrow_top}${user} ${pwd}
${arrow_bot}$ "
RPROMPT="${return_code} ${git_branch} $(ruby_prompt_info)"