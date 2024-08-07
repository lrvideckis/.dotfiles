# inspired by DT: https://gitlab.com/dwt1/dotfiles/-/blob/master/.zshrc
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# Enable Vi key bindings
bindkey -v
bindkey 'kj' vi-cmd-mode

# better flags for common tools
alias grep="grep --line-number --color=auto"
alias rm="rm --interactive" # confirm before overwriting
alias mv="mv --interactive"
alias cp="cp --interactive"
alias mkdir="mkdir --parents" # create all folders on path

# alternatives to core utils https://wiki.archlinux.org/title/Core_utilities#Alternatives
alias vim="nvim"
alias eza="eza --all --long --classify --color=always --group-directories-first --sort=name --git"
alias ls="eza"
alias tree="eza --tree"
autoload -Uz compinit
compinit
eval "$(zoxide init zsh)"
alias cd="z"
alias cat="bat --wrap=never"
alias du="dust"

# START DISPLAY
alias clip="wl-copy <" # clip a.cpp
alias cf="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME" # ConFig https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git
alias ac="nvim ~/.config/alacritty/alacritty.toml"
alias minecraft="LC_ALL=C ./.minecraft/launcher/minecraft-launcher"
alias matrix="unimatrix --speed=95 --no-bold"
alias hollywood="hollywood"
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

# enter python environment; needed for oj-verify and pip
# https://wiki.archlinux.org/title/Python/Virtual_environment
source my_python_env/bin/activate

# starship prompt
eval "$(starship init zsh)"

cbonsai -p -m ' it will be okay'
