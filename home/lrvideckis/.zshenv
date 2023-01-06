# aliases, inspired by DT: https://gitlab.com/dwt1/dotfiles/-/blob/master/.zshrc

# better flags for common tools
alias grep="grep --line-number --color=auto"
# confirm before overwriting something
alias rm="rm --interactive"
alias mv="mv --interactive"
alias cp="cp --interactive"
# create all folders on path
alias mkdir="mkdir --parents"
# show entire history
alias history="history 1"

# alternatives to core utils, inspired by https://wiki.archlinux.org/title/Core_utilities#Alternatives
# changing vim to the modern neovim
alias vim="nvim"
# changing ls, tree to the modern exa
exa_flags="--all --long --classify --color=always --group-directories-first --sort=modified --git"
alias ls="exa "$exa_flags
alias tree="exa --tree "$exa_flags
# changing cd to the modern zoxide
autoload -Uz compinit
compinit
eval "$(zoxide init zsh)"
alias cd="z"
# changing cat to the modern bat
alias cat="bat --paging=always"

# changing du to the modern dust
alias du="dust"

# commonly used actions
# copy file to clipboard with `clip a.cpp`
alias clip="xclip -selection clipboard"
# enable support for git bare repo of dotfiles, source: https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git
# working tree is root so I can add my pacman config
alias cf="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=/"
# update standard pkgs (pacman/paru -Syu)
alias pacsyu="sudo pacman -Syu"
alias parusyu="paru -Syu"
# I use this to quickly view+search library code from any directory.
alias catlib="find ~/programming_team_code/library/ -type f -name '*.hpp' | xargs bat"
# display keybindings
qtile_conf="~/.config/qtile/config.py"
alias kb="sed --quiet '/KEYBINDINGS/=' $qtile_conf | paste --serial --delimiters=: | xargs bat --wrap=never --paging=always $qtile_conf --line-range"

# git
alias gs="git status"
alias gd="git diff"
alias ga="git add"
alias gc="git commit"
alias gps="git push"
alias gpl="git pull"

# misc. (frequently used) programs -> so I don't have to memorize these
alias pcmanfm="pcmanfm"
alias spotify="spotify"
alias minecraft="LC_ALL=C ./.minecraft/launcher/minecraft-launcher"
alias bluetooth="blueman-manager"
alias gimp="gimp"
alias battery="acpi"
alias coreshot="coreshot"
# modern version of man
alias tldr="tldr"
alias sensors="sensors"
alias pass="pass"
# cool terminal output
alias matrix="unimatrix --speed=95 --no-bold"
alias hollywood="hollywood"
alias cbonsai="cbonsai --live --infinite --message='it will be okay' --verbose"
