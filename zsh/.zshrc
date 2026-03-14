# ============================================================================
# .zshrc — interactive shell configuration
# ============================================================================

# ============================================================================
# Oh My Zsh
# ============================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Plugins (zsh-syntax-highlighting & zsh-autosuggestions installed in $ZSH_CUSTOM/plugins/)
plugins=(fzf-tab git fzf direnv zsh-syntax-highlighting zsh-autosuggestions)

source "$ZSH/oh-my-zsh.sh"

# ============================================================================
# History
# ============================================================================
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
[[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}"

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# ============================================================================
# Shell Options
# ============================================================================
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP

# ============================================================================
# Key Bindings
# ============================================================================
bindkey -v  # vi mode
KEYTIMEOUT=1

# Vi mode indicator + cursor shape
function zle-keymap-select zle-line-init {
    case $KEYMAP in
        vicmd)      VI_MODE="Normal";  print -n '\e[1 q' ;;
        viins|main) VI_MODE="Insert";  print -n '\e[5 q' ;;
        visual)     VI_MODE="Visual";  print -n '\e[1 q' ;;
        viopp)      VI_MODE="Pending"; print -n '\e[1 q' ;;
    esac
    RPS1="$VI_MODE"
    zle reset-prompt
}
zle -N zle-keymap-select
zle -N zle-line-init

# Arrow-key history search (type prefix, then up/down to filter)
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# Tab accepts autosuggestion if visible, otherwise does normal completion
function tab-accept-or-complete() {
    if [[ -n "$POSTDISPLAY" ]]; then
        zle autosuggest-accept
    else
        zle expand-or-complete
    fi
}
zle -N tab-accept-or-complete
bindkey '^I' tab-accept-or-complete

# ============================================================================
# FZF
# ============================================================================
if (( $+commands[fzf] )); then
    eval "$(fzf --zsh)"

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
fi

# ============================================================================
# NVM (lazy-loaded to avoid ~400ms startup penalty)
# ============================================================================
_nvm_lazy_load() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
}
nvm()  { _nvm_lazy_load; nvm  "$@"; }
node() { _nvm_lazy_load; node "$@"; }
npm()  { _nvm_lazy_load; npm  "$@"; }
npx()  { _nvm_lazy_load; npx  "$@"; }

# ============================================================================
# Aliases
# ============================================================================
alias h2='$(npm prefix -s)/node_modules/.bin/shopify hydrogen'

# ============================================================================
# OSC 7 — terminal CWD tracking (Ghostty, WezTerm)
# ============================================================================
function osc7-pwd() {
    emulate -L zsh
    setopt extendedglob
    local LC_ALL=C
    printf '\e]7;file://%s%s\e\\' "$HOST" "${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}"
}

function chpwd-osc7-pwd() {
    (( ZSH_SUBSHELL )) || osc7-pwd
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd chpwd-osc7-pwd

# ============================================================================
# Extensibility — source user-local overrides
# ============================================================================
if [[ -d ~/.zshrc.d ]]; then
    for rc in ~/.zshrc.d/*(N); do
        [[ -f "$rc" ]] && source "$rc"
    done
    unset rc
fi
