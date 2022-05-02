# .bashrc

# Source other files, if any
[[ -f "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"
[[ -f "$HOME/.bash_environment" ]] && source "$HOME/.bash_environment"
[[ -f "/etc/bash_completion" ]] && source "/etc/bash_completion"
[[ -f "/usr/share/git/completion/git-prompt.sh" ]] && source "/usr/share/git/completion/git-prompt.sh"

# Keep history
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export HISTCONTROL=ignoreboth
shopt -s histappend

# Windows size
shopt -s checkwinsize

# Extended globbing
shopt -s extglob

# Enable completion for sudo
complete -cf sudo

# Enable completion for man
complete -cf man

# Enable cd correction
shopt -s cdspell

# Use vi like shortcuts
set -o vi

# Color Prompt
set_prompt () {
    # Retrieve last command, need to be first
    local last_cmd="$?"

    # Initiliazing variables
    local prompt_type="$1"
    local def_char="\[\017\]"
    local alt_char="\[\016\]"
    # local def_char="\[\033(B\]"
    # local alt_char="\[\033(0\]"

    # Foreground colors
    local fg_black_dark="\[\e[00;30m\]"
    local fg_red_dark="\[\e[00;31m\]"
    local fg_green_dark="\[\e[00;32m\]"
    local fg_yellow_dark="\[\e[00;33m\]"
    local fg_blue_dark="\[\e[00;34m\]"
    local fg_magenta_dark="\[\e[00;35m\]"
    local fg_cyan_dark="\[\e[00;36m\]"
    local fg_white_dark="\[\e[00;37m\]"
    local fg_black_bright="\[\e[01;30m\]"
    local fg_red_bright="\[\e[01;31m\]"
    local fg_green_bright="\[\e[01;32m\]"
    local fg_yellow_bright="\[\e[01;33m\]"
    local fg_blue_bright="\[\e[01;34m\]"
    local fg_magenta_bright="\[\e[01;35m\]"
    local fg_cyan_bright="\[\e[01;36m\]"
    local fg_white_bright="\[\e[01;37m\]"

    # Background colors
    local bg_black="\[\e[40m\]"
    local bg_red="\[\e[41m\]"
    local bg_green="\[\e[42m\]"
    local bg_yellow="\[\e[43m\]"
    local bg_blue="\[\e[44m\]"
    local bg_magenta="\[\e[45m\]"
    local bg_cyan="\[\e[46m\]"
    local bg_white="\[\e[47m\]"

    # Reset colors
    local reset="\[\e[m\]"

    # Unicode characters
    local bad_result="${fg_red_bright}\342\234\227"
    local good_result="${fg_green_bright}\342\234\223"
    local end_line="\342\225\274"
    # local sep_right=""
    # local sep_right=$'\uE0B0'
    local sep_right="\356\202\260"
    local sep_left="\356\202\262"
    # local sep_left=""
    # local sept_left=$'\uE0B2'

    # Root?
    [[ $(id -u) -eq 0 ]] && local user_color=("$fg_red_bright" "$fg_red_dark" "$bg_red") || local user_color=("$fg_green_bright" "$fg_green_dark" "$bg_green")

    # Last return
    [[ $last_cmd -eq 0 ]] && local last_result=("$good_result" "${fg_green_bright}V" "$fg_green_dark" "$bg_green") || local last_result=("$bad_result" "${fg_red_bright}X" "$fg_red_dark" "$bg_red")

    # Git
    [[ -z "$(__git_ps1 '%s')" ]] && local git_color=("" "" "") || local git_color=("$fg_red_bright" "$fg_red_dark" "$bg_red")

    # Setting PS1
    # Foreground color must come before background color
    case "$prompt_type" in
        "-1a")
            local git_branch="$(__git_ps1 ' %s')"
            PS1=" ${reset}${fg_white_bright}${last_cmd} ${last_result[1]} ${reset}${user_color[0]}\u@\h${reset}:${fg_blue_bright}\w${git_color[0]}${git_branch}${reset}\$ "
            ;;
        "-1b")
            local git_branch="$(__git_ps1 ' %s')"
            PS1=" ${reset}${fg_white_bright}${last_cmd} ${last_result[0]} ${reset}${user_color[0]}\u@\h${reset}:${fg_blue_bright}\w${git_color[0]}${git_branch}${reset}\$ "
            ;;
        "-2a")
            local git_branch="$(__git_ps1 ' [%s]')"
            PS1="\n${alt_char}l${def_char}[${fg_white_bright}${last_cmd}${reset}]${alt_char}q${def_char}[${last_result[0]}${reset}]${alt_char}q${def_char}[${user_color[0]}\u@\h${reset}]:[${fg_blue_bright}\w${git_color[0]}${git_branch}${reset}]\n${alt_char}mq${def_char}${end_line}${reset} "
            ;;
        "-2b")
            local git_branch="$(__git_ps1 ' %s')"
            PS1="\n${alt_char}lu${def_char}${fg_white_bright}${last_cmd}${reset}${alt_char}tqu${def_char}${last_result[0]}${reset}${alt_char}tqu${def_char}${user_color[0]}\u@\h${reset}${alt_char}t${def_char}${end_line}${fg_blue_bright} \w${git_color[0]}${git_branch}${reset}\n${alt_char}mq${def_char}${end_line}${reset} "
            ;;
        "-p")
            local git_branch="$(__git_ps1 ' %s')"
            [[ -z "$git_branch" ]] && local git_powerline="" || local git_powerline="${fg_white_bright}${git_branch} ${git_color[1]}${sep_right}"
            PS1="${reset}${fg_white_bright}${last_result[3]} ${last_cmd} ${last_result[2]}${user_color[2]}${sep_right}${fg_white_bright} \u ${user_color[1]}${bg_yellow}${sep_right}${fg_white_bright} \h ${fg_yellow_dark}${bg_blue}${sep_right}${fg_white_bright} \w ${fg_blue_dark}${git_color[2]}${sep_right}${git_powerline}${reset} "
            ;;
        *)
            PS1="${reset}${user_color[0]}\u@\h${reset}:${fg_blue_bright}\w${reset}\$ "
            ;;
    esac
}
if [[ "$TERM" == "linux" ]]; then
    PROMPT_COMMAND='set_prompt -1a'
else
    PROMPT_COMMAND='set_prompt -1b'
fi

# Enable color
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ls aliases
alias ll='ls -lAh'
alias la='ls -A'

# cd aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Avoid headaches
alias exxit='exit'
alias quit='exit'
alias :q='exit'
alias fu='sudo $(fc -n -l -1)'
alias ffs='sudo $(fc -n -l -1)'
alias pls='sudo $(fc -n -l -1)'
alias please='sudo $(fc -n -l -1)'
alias vmi='vim'

# Shutdown aliases
alias bye='sudo shutdown -h now'
alias cya='sudo shutdown -r now'

# Sudo vim
alias svim="HOME=/home/$(who | cut -d ' ' -f 1 | uniq | sed '/root/d') && sudo vim -u $HOME/.vimrc"

# Editors
export EDITOR="/usr/bin/vim"
export VISUAL="/usr/bin/vim"

