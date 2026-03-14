#!/usr/bin/env bash
# ============================================================================
# install.sh — bootstrap dotfiles on macOS or Fedora Linux
# ============================================================================
set -euo pipefail

DOTS_DIR="$(cd "$(dirname "$0")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"

# ============================================================================
# Helpers
# ============================================================================
info()  { printf '\033[1;34m[info]\033[0m  %s\n' "$*"; }
ok()    { printf '\033[1;32m[ok]\033[0m    %s\n' "$*"; }
warn()  { printf '\033[1;33m[warn]\033[0m  %s\n' "$*"; }
err()   { printf '\033[1;31m[err]\033[0m   %s\n' "$*" >&2; }

detect_os() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux)
            if [[ -f /etc/fedora-release ]]; then
                echo "fedora"
            else
                err "Unsupported Linux distro (only Fedora is supported)"
                exit 1
            fi
            ;;
        *)
            err "Unsupported OS: $(uname -s)"
            exit 1
            ;;
    esac
}

command_exists() { command -v "$1" &>/dev/null; }

# ============================================================================
# Package installation
# ============================================================================
install_packages_macos() {
    if ! command_exists brew; then
        info "Installing Homebrew…"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    local packages=(stow zsh fzf fd tmux direnv)

    info "Installing packages via Homebrew…"
    brew install "${packages[@]}"
}

install_packages_fedora() {
    local packages=(stow zsh fzf fd-find tmux direnv util-linux-user)

    info "Installing packages via dnf…"
    sudo dnf install -y "${packages[@]}"
}

# ============================================================================
# Zsh ecosystem
# ============================================================================
install_oh_my_zsh() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        ok "Oh My Zsh already installed"
        return
    fi
    info "Installing Oh My Zsh…"
    RUNZSH=no KEEP_ZSHRC=yes \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

clone_if_missing() {
    local repo="$1" dest="$2"
    if [[ -d "$dest" ]]; then
        ok "Already installed: $(basename "$dest")"
    else
        info "Cloning $(basename "$dest")…"
        git clone --depth 1 "$repo" "$dest"
    fi
}

install_zsh_plugins() {
    local plugin_dir="${ZSH_CUSTOM}/plugins"
    clone_if_missing https://github.com/marlonrichert/zsh-autocomplete  "${plugin_dir}/zsh-autocomplete"
    clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting "${plugin_dir}/zsh-syntax-highlighting"
    clone_if_missing https://github.com/Aloxaf/fzf-tab                  "${plugin_dir}/fzf-tab"
    clone_if_missing https://github.com/jeffreytse/zsh-vi-mode          "${plugin_dir}/zsh-vi-mode"
}

# ============================================================================
# Stow packages
# ============================================================================
stow_packages() {
    local os="$1"

    # Packages to stow on all platforms
    local packages=(zsh nvim bob)

    # OS-specific packages
    case "$os" in
        macos)  packages+=(ghostty wezterm tmux) ;;
        fedora) packages+=(ghostty tmux systemd) ;;
    esac

    info "Stowing packages: ${packages[*]}"
    cd "$DOTS_DIR"
    for pkg in "${packages[@]}"; do
        if [[ -d "$pkg" ]]; then
            stow --restow "$pkg"
            ok "Stowed $pkg"
        else
            warn "Skipping $pkg (directory not found)"
        fi
    done
}

# ============================================================================
# Set default shell
# ============================================================================
set_default_shell() {
    local zsh_path
    zsh_path="$(command -v zsh)"

    if [[ "$SHELL" == *zsh ]]; then
        ok "Default shell is already zsh"
        return
    fi

    # Ensure zsh is in /etc/shells
    if ! grep -qx "$zsh_path" /etc/shells 2>/dev/null; then
        info "Adding $zsh_path to /etc/shells…"
        echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
    fi

    info "Changing default shell to zsh…"
    chsh -s "$zsh_path"
    ok "Default shell set to zsh (restart your terminal)"
}

# ============================================================================
# Main
# ============================================================================
main() {
    local os
    os="$(detect_os)"
    info "Detected OS: $os"

    # System packages
    "install_packages_${os}"

    # Zsh ecosystem
    install_oh_my_zsh
    install_zsh_plugins

    # Symlink configs
    stow_packages "$os"

    # Shell
    set_default_shell

    echo
    ok "Done! Open a new terminal to start using your dotfiles."
}

main "$@"
