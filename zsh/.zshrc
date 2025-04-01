export ZSH="$HOME/.oh-my-zsh"
export PATH="$PATH:[directory]"
export PATH="$PATH:/home/kyle/.local/share/bob/nvim-bin"
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
export ANDROID_HOME="$HOME/Android/Sdk"
export SUDO_EDITOR="$HOME/.local/share/bob/nvim-bin/nvim"
export FLYCTL_INSTALL="/home/kyle/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"
ZSH_THEME="robbyrussell"
plugins=(git direnv fzf)

source $ZSH/oh-my-zsh.sh


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fzf key bindings

FZF_FD_OPTS="--hidden --follow --exclude '.git'"
export FZF_DEFAULT_COMMAND="fd ${FZF_FD_OPTS}"
export FZF_CTRL_T_COMMAND="fd ${FZF_FD_OPTS}"
export FZF_ALT_C_COMMAND="fd --type d ${FZF_FD_OPTS}"

_fzf_compgen_path() {
    fd ${FZF_FD_OPTS} . "${1}"
}

_fzf_compgen_dir() {
    fd --type d ${FZF_FD_OPTS} . "${1}"
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# pnpm
export PNPM_HOME="/home/kyle/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

function osc7-pwd() {
    emulate -L zsh # also sets localoptions for us
    setopt extendedglob
    local LC_ALL=C
    printf '\e]7;file://%s%s\e\' $HOST ${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}
}

function chpwd-osc7-pwd() {
    (( ZSH_SUBSHELL )) || osc7-pwd
}
add-zsh-hook -Uz chpwd chpwd-osc7-pwd


alias air="/home/kyle/go/bin/air"

[ -f "/home/kyle/.ghcup/env" ] && . "/home/kyle/.ghcup/env" # ghcup-env
