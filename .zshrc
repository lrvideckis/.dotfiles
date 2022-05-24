HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# Enable Vi key bindings
bindkey -v
bindkey 'kj' vi-cmd-mode

# prompt as: date, time, directory
PS1='%n@%m %~ %# '

export TERM=xterm-256color
export EDITOR=nvim
#cpplint command installed to ~/.local/bin/ instead of /usr/local/bin/ . This is the fix
export PATH=$PATH:~/.local/bin/

# all aliases
. ~/.zsh_aliases

# enhancements
source /usr/share/zsh/share/antigen.zsh

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

# terminal bling
neofetch
