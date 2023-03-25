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
alias exa="exa --all --long --classify --color=always --group-directories-first --sort=modified --git"
alias ls="exa"
alias tree="exa --tree"
autoload -Uz compinit
compinit
eval "$(zoxide init zsh)"
alias cd="z"
alias cat="bat --wrap=never --paging=always"
alias du="dust"

# START DISPLAY
alias pdf="llpp"
alias tql="tail -f ~/.local/share/qtile/qtile.log" # Tail Qtile Log
alias clip="wl-copy <" # clip a.cpp
alias cf="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=/" # ConFig https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git
alias catlib="bat ~/programming_team_code/library/**/*.hpp"
alias catptc="bat ~/programming_team_code/library/**/*.hpp ~/programming_team_code/tests/online_judge_tests/**/*.test.cpp"
alias minecraft="LC_ALL=C ./.minecraft/launcher/minecraft-launcher"
alias matrix="unimatrix --speed=95 --no-bold"
alias hollywood="hollywood"
alias cbonsai="cbonsai --live --infinite --message='it will be okay' --verbose"
alias rmlast="truncate --size=-1" # to remove last newline
alias gs="git status"
alias gd="git diff"
alias ga="git add"
alias gc="git commit"
alias gps="git push"
alias gpl="git pull"
# END DISPLAY

export TERM=xterm-256color
export EDITOR=nvim
# cpplint command installed to ~/.local/bin/ instead of /usr/local/bin/ . This is the fix
export PATH=$PATH:~/.local/bin/
# needed for Unexpected Keyboard
export ANDROID_HOME=~/Android/Sdk

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# starship prompt
eval "$(starship init zsh)"

# terminal bling
neofetch
