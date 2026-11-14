#!/usr/bin/env bash
# ============================================================================
# install.sh — bootstrap dotfiles on Fedora Linux
# ============================================================================
set -euo pipefail

DOTS_DIR="$(cd "$(dirname "$0")" && pwd)"

# ============================================================================
# Helpers
# ============================================================================
info()  { printf '\033[1;34m[info]\033[0m  %s\n' "$*"; }
ok()    { printf '\033[1;32m[ok]\033[0m    %s\n' "$*"; }
warn()  { printf '\033[1;33m[warn]\033[0m  %s\n' "$*"; }
err()   { printf '\033[1;31m[err]\033[0m   %s\n' "$*" >&2; }

require_fedora() {
    if [[ ! -f /etc/fedora-release ]]; then
        err "Unsupported OS (only Fedora Linux is supported)"
        exit 1
    fi
}

command_exists() { command -v "$1" &>/dev/null; }

# ============================================================================
# Package installation
# ============================================================================
install_packages() {
    # tree-sitter-cli: used by nvim-treesitter (main) / tree-sitter-manager to
    # build parsers; without it parser installs fail and retry every startup.
    # gh + thefuck back their oh-my-zsh plugins.
    # gnome-shell-extension-pop-shell: tiling WM, configured by the gnome pkg.
    local packages=(stow fzf fd-find tmux direnv tree-sitter-cli zsh gh thefuck
                    gnome-shell-extension-pop-shell)

    info "Installing packages via dnf…"
    # --skip-unavailable: gh may live in a third-party repo that isn't
    # configured yet; don't let one missing package abort the bootstrap.
    # --exclude nodejs*: tree-sitter-cli recommends nodejs, which would pull
    # in a system Node + npm alongside the pnpm-managed ones (see setup_node).
    sudo dnf install -y --skip-unavailable --exclude='nodejs*' "${packages[@]}"
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

# ============================================================================
# Stow packages
# ============================================================================
stow_packages() {
    local packages=(nvim bob ssh ghostty tmux systemd gnome cosmic)

    # COSMIC saves config via atomic rename, which would replace a symlinked
    # file with a plain one. Stow only links the directory itself (so saves land
    # in the repo) if it doesn't exist yet, so drop COSMIC's empty default ones.
    local cosmic_dir
    for cosmic_dir in com.system76.CosmicSettings.Shortcuts com.system76.CosmicSettings.WindowRules \
                      com.system76.CosmicAppletBattery; do
        cosmic_dir="$HOME/.config/cosmic/$cosmic_dir"
        if [[ -d "$cosmic_dir" && ! -L "$cosmic_dir" ]] \
            && [[ -z "$(find "$cosmic_dir" -type f -print -quit)" ]]; then
            rm -r "$cosmic_dir"
        fi
    done

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
# GNOME / Pop Shell (dconf)
# ============================================================================
# Keybindings, gaps, tiling etc. live in dconf, which stow can't link; restore
# them from the committed snapshots. Snapshot changes with `gnome/sync.sh dump`.
load_gnome_settings() {
    if ! command_exists dconf || [[ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
        warn "No dconf/desktop session — run gnome/sync.sh load after logging in"
        return
    fi
    info "Loading GNOME window-management settings…"
    "$DOTS_DIR/gnome/sync.sh" load
    ok "Loaded GNOME settings"
}

# ============================================================================
# Fonts
# ============================================================================
# Berkeley Mono (TX-02) is licensed, so it can't be committed to this public
# repo. Copy it from $DOTS_FONT_DIR (default ~/fonts) if it's there; otherwise
# warn and move on — ghostty falls back to its bundled JetBrains Mono.
install_fonts() {
    local font_file="TX-02-Variable.otf"
    local src="${DOTS_FONT_DIR:-$HOME/fonts}/$font_file"
    local dest_dir="$HOME/.local/share/fonts"

    if [[ -f "$dest_dir/$font_file" ]]; then
        ok "Font already installed: $font_file"
        return
    fi

    if [[ -f "$src" ]]; then
        info "Installing $font_file…"
        mkdir -p "$dest_dir"
        cp "$src" "$dest_dir/"
        # fontconfig needs a cache refresh to pick up new fonts.
        fc-cache -f "$dest_dir" >/dev/null
        ok "Installed $font_file"
    else
        warn "$font_file not found at $src — install it manually or set DOTS_FONT_DIR"
    fi
}

# ============================================================================
# Zsh
# ============================================================================
setup_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        info "Installing oh-my-zsh…"
        # CHSH/RUNZSH: shell change is handled by set_default_shell; don't
        # drop into zsh mid-script. KEEP_ZSHRC: we link our own below.
        CHSH=no RUNZSH=no KEEP_ZSHRC=yes \
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    # zsh-vi-mode is a third-party plugin; oh-my-zsh only loads it if it has
    # been cloned into $ZSH_CUSTOM/plugins first.
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    clone_if_missing https://github.com/jeffreytse/zsh-vi-mode \
        "$zsh_custom/plugins/zsh-vi-mode"

    ln -sfn "$DOTS_DIR/.zshrc" "$HOME/.zshrc"
    ok "Linked ~/.zshrc"
}

# ============================================================================
# Node (via pnpm)
# ============================================================================
# Node is managed by pnpm, not the system package manager: standalone pnpm
# lives in $PNPM_HOME, and `pnpm runtime set --global` links a node binary into
# $PNPM_HOME/bin, which .zshrc puts on PATH. npm/npx are pnpm globals there too.
setup_node() {
    # Keep in sync with the pnpm block in .zshrc.
    export PNPM_HOME="$HOME/.local/share/pnpm"
    # pnpm expects its global bin dir on PATH when installing globally.
    export PATH="$PNPM_HOME/bin:$PATH"

    # Check the standalone binary, not `command -v pnpm`: a corepack or npm
    # shim would satisfy that but can't be relied on before node exists.
    if [[ -x "$PNPM_HOME/bin/pnpm" ]]; then
        ok "Already installed: pnpm"
    else
        info "Installing pnpm…"
        # PNPM_NO_MODIFY_PATH: .zshrc already has the PATH block. Without this
        # the installer rewrites that block through the ~/.zshrc symlink.
        curl -fsSL https://get.pnpm.io/install.sh | PNPM_NO_MODIFY_PATH=1 sh -
    fi

    # Skip when present so re-running the bootstrap never changes the Node
    # version; upgrade explicitly with `pnpm runtime set node lts -g`.
    if [[ -x "$PNPM_HOME/bin/node" ]]; then
        ok "Already installed: node $("$PNPM_HOME/bin/node" --version)"
    else
        info "Installing Node LTS via pnpm…"
        "$PNPM_HOME/bin/pnpm" runtime set node lts --global
        ok "Installed node $("$PNPM_HOME/bin/node" --version)"
    fi

    # pnpm's node runtime ships without npm/npx; install them as a pnpm global
    # so they run on the pnpm-managed node.
    if [[ -x "$PNPM_HOME/bin/npm" ]]; then
        ok "Already installed: npm $("$PNPM_HOME/bin/npm" --version)"
    else
        info "Installing npm via pnpm…"
        "$PNPM_HOME/bin/pnpm" add --global npm
        ok "Installed npm $("$PNPM_HOME/bin/npm" --version)"
    fi
}

# ============================================================================
# Set default shell
# ============================================================================
set_default_shell() {
    local zsh_path
    zsh_path="$(command -v zsh)"

    if [[ "$SHELL" == "$zsh_path" ]]; then
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
    require_fedora

    # System packages
    install_packages

    # Symlink configs
    stow_packages

    # GNOME / Pop Shell settings (dconf)
    load_gnome_settings

    # Fonts
    install_fonts

    # Zsh config + plugins
    setup_zsh

    # pnpm + Node
    setup_node

    # Shell
    set_default_shell

    echo
    ok "Done! Open a new terminal to start using your dotfiles."
}

main "$@"
