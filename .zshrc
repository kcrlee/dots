# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$PATH:/Users/kyle/.local/bin"
ZSH_THEME="robbyrussell"
zvm_after_init_commands+=('source <(fzf --zsh)')

plugins=(
	git
	zsh-vi-mode
	fzf
	gh
	thefuck
)

export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='vim'
else
	export EDITOR='nvim'
fi

source $ZSH/oh-my-zsh.sh

# pnpm
export PNPM_HOME="/Users/kyle/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
