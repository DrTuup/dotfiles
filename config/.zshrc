# Language
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Homebrew configuration (first, so plugins and tools below can find brew binaries)
eval "$(/opt/homebrew/bin/brew shellenv)"

# General (oh-my-)zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(kubectl git zoxide fzf fzf-tab nvm starship you-should-use)
zstyle ':omz:update' mode auto # update automatically without asking
source $ZSH/oh-my-zsh.sh

# zsh-autosuggestions (Homebrew-installed, so sourced after Oh My Zsh)
[[ -f $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# LiteLLM API Key
# Load LiteLLM key from 1Password on first use only (avoids a Touch ID prompt per shell).
# Usage: litellm_key && <command that needs $LITELLM_API_KEY>
litellm_key() {
  if [[ -z $LITELLM_API_KEY ]]; then
    LITELLM_API_KEY="$(op read 'op://Private/LiteLLM/Virtual Key')" || return 1
    export LITELLM_API_KEY
  fi
}
