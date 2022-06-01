HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# Enable Vi key bindings
bindkey -v
bindkey 'kj' vi-cmd-mode

# prompt as: user, machine, path
PS1='%n@%m %~ %# '

export TERM=xterm-256color
export EDITOR=nvim
# cpplint command installed to ~/.local/bin/ instead of /usr/local/bin/ . This is the fix
export PATH=$PATH:~/.local/bin/

# all aliases
. ~/.zshenv

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# terminal bling
neofetch
