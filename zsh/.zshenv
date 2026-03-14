# ============================================================================
# .zshenv — loaded for ALL zsh sessions (interactive, scripts, login)
# Keep this file lean: PATH and environment variables only.
# ============================================================================

# XDG Base Directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Deduplicate PATH entries
typeset -U path

# Homebrew (macOS only)
if [[ "$OSTYPE" == darwin* && -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# User paths
path=(
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.local/share/bob/nvim-bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/share/pnpm"
    $path
)

# Rust/Cargo env (sets other vars besides PATH)
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# NVM directory (lazy-loaded in .zshrc)
export NVM_DIR="${XDG_CONFIG_HOME}/nvm"
[[ -d "$HOME/.nvm" && ! -d "$NVM_DIR" ]] && export NVM_DIR="$HOME/.nvm"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
