# ============================================================================
# .zshrc — interactive shell configuration
# ============================================================================

# ============================================================================
# Oh My Zsh
# ============================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# ============================================================================
# Completion Engine — set COMPLETION_ENGINE to switch modes:
#   "fzf"            → fzf-tab (default)
#   "inshellisense"  → Microsoft inshellisense overlay
#   "off"            → no enhanced completions
# ============================================================================
: ${COMPLETION_ENGINE:=fzf}

plugins=(git fzf direnv zsh-vi-mode zsh-syntax-highlighting)
if [[ "$COMPLETION_ENGINE" == "fzf" ]]; then
    plugins+=( fzf-tab )
fi

# ============================================================================
# zsh-vi-mode hooks  (must be defined before oh-my-zsh sources the plugin)
# ============================================================================

# Mode indicator in right prompt
function zvm_after_select_vi_mode {
    case $ZVM_MODE in
        $ZVM_MODE_NORMAL)      RPS1="Normal | $COMPLETION_ENGINE" ;;
        $ZVM_MODE_INSERT)      RPS1="Insert | $COMPLETION_ENGINE" ;;
        $ZVM_MODE_VISUAL)      RPS1="Visual | $COMPLETION_ENGINE" ;;
        $ZVM_MODE_VISUAL_LINE) RPS1="Visual Line | $COMPLETION_ENGINE" ;;
        $ZVM_MODE_REPLACE)     RPS1="Replace | $COMPLETION_ENGINE" ;;
    esac
}

# Keybindings that must be set after zsh-vi-mode initialises
function zvm_after_init {
    # Arrow-key history search (type prefix, then up/down to filter)
    autoload -U history-search-end
    zle -N history-beginning-search-backward-end history-search-end
    zle -N history-beginning-search-forward-end history-search-end
    bindkey "^[[A" history-beginning-search-backward-end
    bindkey "^[[B" history-beginning-search-forward-end
}

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
# FZF
# ============================================================================
if (( $+commands[fzf] )); then
    # Keybindings (Ctrl-R, Ctrl-T, Alt-C) come from the oh-my-zsh fzf plugin.
    # Don't run `eval "$(fzf --zsh)"` — it rebinds ^I to fzf-completion,
    # overriding fzf-tab's tab binding.

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
# Inshellisense — auto-launch when COMPLETION_ENGINE=inshellisense
# ============================================================================
if [[ "$COMPLETION_ENGINE" == "inshellisense" ]] && (( $+commands[is] )) && [[ -z "$IS_SESSION" ]]; then
    export IS_SESSION=1
    exec is
fi

# ============================================================================
# Extensibility — source user-local overrides
# ============================================================================
if [[ -d ~/.zshrc.d ]]; then
    for rc in ~/.zshrc.d/*(N); do
        [[ -f "$rc" ]] && source "$rc"
    done
    unset rc
fi
