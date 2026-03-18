# Blesh (Bash Line Editor) — early init, deferred attach
# Must load before starship/fzf so ble.sh can properly measure the final prompt
_dots_want_blesh=0
if [ -f ~/.local/share/blesh/ble.sh ] && [[ $- == *i* ]]; then
	if [ -z "$TMUX" ] || [ "${DOTS_FORCE_BLESH:-0}" = "1" ]; then
		_dots_want_blesh=1
		source ~/.local/share/blesh/ble.sh --attach=none
	fi
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# ============================================================================
# PATH Configuration
# ============================================================================

# User specific paths
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
	PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# Rust/Cargo
if [ -f "$HOME/.cargo/env" ]; then
	. "$HOME/.cargo/env"
fi

# Neovim (bob version manager)
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export EDITOR="nvim"
export VISUAL="nvim"

# NVM (Node Version Manager)
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac

if [[ "$OSTYPE" == "darwin"* ]]; then
	export HOMEBREW_PREFIX="/opt/homebrew/bin:$PATH"
fi

function load_bash_completion() {
	if [[ "$OSTYPE" == "linux-gnu"* ]]; then
		source /etc/profile.d/bash_completion.sh
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		# Mac OSX
		[[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
	fi
}

export PATH

# ============================================================================
# Prompt Configuration
# ============================================================================
eval "$(starship init bash)"

# ============================================================================
# Tool Configuration
# ============================================================================

# Vim Mode

# if [[ $- == *i* ]]; then # in interactive session
# set -o vi
# fi

# Load bash completions (blesh integrations are deferred via .blerc)
if [ "$_dots_want_blesh" = "1" ]; then
	load_bash_completion
	ble-import -d integration/fzf-completion
	ble-import -d integration/fzf-key-bindings
else
	if [[ $- == *i* ]]; then
		load_bash_completion
	fi
fi

# Override .inputrc vi mode inside tmux to avoid scrollback/escape conflicts
if [ -n "$TMUX" ] && [ "${DOTS_FORCE_BLESH:-0}" != "1" ] && [[ $- == *i* ]]; then
	set -o emacs
fi

# FZF (Fuzzy Finder)
if [ -f ~/.fzf.bash ]; then
	source ~/.fzf.bash
	eval "$(fzf --bash)"

	# FZF configuration
	FZF_FD_OPTS="--hidden --follow --exclude '.gitignore'"
	export FZF_DEFAULT_COMMAND="fd ${FZF_FD_OPTS}"
	export FZF_CTRL_T_COMMAND="fd ${FZF_FD_OPTS}"
	export FZF_ALT_C_COMMAND="fd --type d ${FZF_FD_OPTS}"

	# FZF completion helpers
	_fzf_compgen_path() {
		fd ${FZF_FD_OPTS} . "${1}"
	}

	_fzf_compgen_dir() {
		fd --type d ${FZF_FD_OPTS} . "${1}"
	}
fi

# ============================================================================
# Aliases
# ============================================================================

# Shopify Hydrogen - use local project's CLI
alias h2='$(npm prefix -s)/node_modules/.bin/shopify hydrogen'

# ============================================================================
# User Specific Configurations
# ============================================================================

# Source additional user configurations
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
	unset rc
fi

# Uncomment if you don't like systemctl's auto-paging:
# export SYSTEMD_PAGER=
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# ============================================================================
# Blesh Attach (must be last — after starship, fzf, and all completions)
# ============================================================================
if [ "$_dots_want_blesh" = "1" ]; then
	ble-attach
fi
unset _dots_want_blesh
