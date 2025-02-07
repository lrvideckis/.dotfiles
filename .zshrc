# inspired by DT: https://gitlab.com/dwt1/dotfiles/-/blob/master/.zshrc
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# Enable Vi key bindings
#bindkey -v

# vi mode, and change cursor depending on mode
bindkey -v
bindkey 'kj' vi-cmd-mode
function zle-keymap-select {
  case $KEYMAP in
    vicmd) echo -ne '\e[1 q';; # block
    viins|main) echo -ne '\e[5 q';; # beam
  esac
}
zle -N zle-keymap-select
zle-line-init() { echo -ne "\e[5 q" }
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# better flags for common tools
alias grep="grep --line-number --color=auto"
alias rm="rm --interactive" # confirm before overwriting
alias mv="mv --interactive"
alias cp="cp --interactive"
alias mkdir="mkdir --parents" # create all folders on path

# alternatives to core utils https://wiki.archlinux.org/title/Core_utilities#Alternatives
alias vim="nvim"
alias eza="eza --all --long --classify --color=always --group-directories-first --git"
alias ls="eza --sort=name"
alias lsm="eza --sort=modified"
alias tree="eza --tree"
autoload -Uz compinit
compinit
eval "$(zoxide init zsh)"
alias cd="z"
alias cat="bat --wrap=never"
alias du="dust"

# START DISPLAY
alias clip="wl-copy <" # clip a.cpp
alias cf="/usr/bin/git --git-dir=$HOME/github_repos/.dotfiles --work-tree=$HOME" # ConFig https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git
alias ac="nvim ~/.config/alacritty/alacritty.toml"
alias minecraft="LC_ALL=C ./.minecraft/launcher/minecraft-launcher"
alias rmlast="truncate --size=-1" # to remove last newline
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gch="git checkout"
alias gd="git diff"
alias gs="git status"
alias gps="git push"
alias gpl="git pull"
# END DISPLAY

export TERM=xterm-256color
export EDITOR=nvim
# cpplint command installed to ~/.local/bin/ instead of /usr/local/bin/ . This is the fix
export PATH=$PATH:~/.local/bin/
# needed for Unexpected Keyboard
export ANDROID_HOME=/home/lrvideckis/android_sdk

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# to show git branch in prompt
# https://stackoverflow.com/a/67628932
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT='%F{green}%~ %F{red}${vcs_info_msg_0_}%F{green}%# %F{white}'

cbonsai -p -m ' it will be okay'
#ctree --no-refresh
