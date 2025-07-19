env_status_helper() {
    if [ -v IN_NIX_SHELL ] && [ -v VIRTUAL_ENV ]; then 
        echo -n " <$IN_NIX_SHELL - ${VIRTUAL_ENV:t}>"
    elif [ -v IN_NIX_SHELL ]; then
        echo -n " <$IN_NIX_SHELL>"
    elif [ -v VIRTUAL_ENV ]; then
        echo -n " <${VIRTUAL_ENV:t}>"
    fi
}

local user='%{$fg[magenta]%}%n@%m%{$reset_color%}%{$reset_color%}'
local pwd='%{$fg_bold[blue]%}%~%{$reset_color%}'
local env_status='%{$fg[cyan]%}$(env_status_helper)%{$reset_color%}'
local lambda='%{$fg[cyan]%}λ%{$reset_color%}'
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

MODE_INDICATOR="%{$fg[yellow]%}#%{$reset_color%}"
INSERT_MODE_INDICATOR="%{$fg[green]%}+%{$reset_color%}"

PROMPT="${user} \$(vi_mode_prompt_info) ${pwd}${env_status}
${lambda} "
RPROMPT="${return_code} ${git_branch} $(ruby_prompt_info)"
