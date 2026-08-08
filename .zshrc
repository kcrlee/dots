# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Homebrew (macOS only)
if [[ -x /opt/homebrew/bin/brew ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export PATH="$PATH:$HOME/.local/bin"

# rust/cargo tools (bob, starship, uv, ...)
if [[ -f "$HOME/.cargo/env" ]]; then
	source "$HOME/.cargo/env"
fi

# bob-managed neovim
if [[ -d "$HOME/.local/share/bob/nvim-bin" ]]; then
	export PATH="$PATH:$HOME/.local/share/bob/nvim-bin"
fi

ZSH_THEME="robbyrussell"
zvm_after_init_commands+=('source <(fzf --zsh)')

plugins=(
	git
	zsh-vi-mode
	fzf
	gh
)

# thefuck's plugin prints an install nag on every startup if the command is missing
if command -v thefuck &>/dev/null; then
	plugins+=(thefuck)
fi

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
if [[ "$OSTYPE" == darwin* ]]; then
	export PNPM_HOME="$HOME/Library/pnpm"
else
	export PNPM_HOME="$HOME/.local/share/pnpm"
fi
case ":$PATH:" in
*":$PNPM_HOME/bin:"*) ;;
*) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
