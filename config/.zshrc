# Language
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# General (oh-my-)zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(kubectl git z)
zstyle ':omz:update' mode auto # update automatically without asking
source $ZSH/oh-my-zsh.sh

# Homebrew configuration
eval "$(/opt/homebrew/bin/brew shellenv)"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Starship prompt configuration
eval "$(starship init zsh)"
