# aliases, inspired by DT: https://gitlab.com/dwt1/dotfiles/-/blob/master/.zshrc


#better flags for common tools
alias grep="grep --color=auto"
# confirm before overwriting something
alias rm="rm --interactive"
alias mv="mv --interactive"
alias cp="cp --interactive"
# create all folders on path
alias mkdir="mkdir --parents"


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
alias cat="bat"
# changing man to the modern tldr
alias man="tldr"
# changing du to the modern dust
alias du="dust --depth 1"
# changing htop to the modern btop
alias htop="btop"


# commonly used actions
# copy contents of file to clipboard
alias clip="xclip -sel clip"
# enable support for git bare repo of dotfiles
alias config="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
# update only standard pkgs
alias pacsyu="sudo pacman -Syu"
# fancier git log/config log, source: https://coderwall.com/p/euwpig/a-better-git-log
git_log_flags="log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gitl="git "$git_log_flags
alias configl="config "$git_log_flags


# misc. (frequently used) programs -> so I don't have to memorize these
alias files="pcmanfm"
alias spotify="spotify"
alias firefox="firefox"
# zsa keyboard flashing tool
alias wally="wally"
alias minecraft="LC_ALL=C ./.minecraft/launcher/minecraft-launcher"
alias bluetooth="blueman-manager"
alias volume="alsamixer"
alias photo_editor="gimp"
alias android="android-studio"
alias battery="acpi"
# local copy of arch wiki
alias ws="wiki-search"
