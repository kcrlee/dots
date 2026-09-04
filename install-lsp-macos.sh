#!/usr/bin/env bash
# ============================================================================
# install-lsp-macos.sh — install LSP servers, formatters and linters on macOS
#
# Replaces mason.nvim. Split by what produces the binary:
#   pnpm     everything published on npm
#   brew     prebuilt native binaries
#   rustup   rust-analyzer (must match the active toolchain)
#   ghcup    haskell-language-server (must match the GHC version)
#   github   expert (single binary, no package anywhere)
#
# Usage: ./install-lsp-macos.sh [--upgrade]
#   --upgrade  re-download GitHub release binaries and brew upgrade
# ============================================================================
set -euo pipefail

info()  { printf '\033[1;34m[info]\033[0m  %s\n' "$*"; }
ok()    { printf '\033[1;32m[ok]\033[0m    %s\n' "$*"; }
warn()  { printf '\033[1;33m[warn]\033[0m  %s\n' "$*"; }
err()   { printf '\033[1;31m[err]\033[0m   %s\n' "$*" >&2; }

command_exists() { command -v "$1" &>/dev/null; }

UPGRADE=0
[[ "${1:-}" == "--upgrade" ]] && UPGRADE=1

BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

case "$(uname -m)" in
    arm64)  ARCH=arm64 ;;
    x86_64) ARCH=amd64 ;;
    *) err "Unsupported architecture: $(uname -m)"; exit 1 ;;
esac

# ============================================================================
# Homebrew: prebuilt native binaries
# ============================================================================
BREW_PACKAGES=(
    jq
    lua-language-server
    luacheck
    marksman
    shellcheck
    shfmt
    stylua
    tinymist
    typstyle
    pnpm
)

install_brew() {
    if ! command_exists brew; then
        err "Homebrew not found; run ./install.sh first"
        exit 1
    fi
    info "Installing via Homebrew: ${BREW_PACKAGES[*]}"
    # One at a time so a single missing formula reports instead of aborting.
    local failed=()
    for pkg in "${BREW_PACKAGES[@]}"; do
        brew install "$pkg" || failed+=("$pkg")
        if [[ $UPGRADE -eq 1 ]]; then
            brew upgrade "$pkg" 2>/dev/null || true
        fi
    done
    if [[ ${#failed[@]} -gt 0 ]]; then
        warn "brew could not install: ${failed[*]}"
    fi
    ok "Homebrew packages installed"
}

# ============================================================================
# pnpm: everything published on npm
# ============================================================================
# html-lsp + json-lsp are one package (vscode-langservers-extracted).
# @typescript/native-preview provides tsgo, which lsp.lua enables but mason
# lists separately. tombi publishes to npm; keeping it there matches Fedora.
NPM_PACKAGES=(
    bash-language-server
    @biomejs/biome
    graphql-language-service-cli
    vscode-langservers-extracted
    htmlhint
    @mistweaverco/kulala-fmt
    @shopify/cli
    svelte-language-server
    @tailwindcss/language-server
    typescript
    @typescript/native-preview
    @vue/language-server
    @wc-toolkit/language-server
    tombi
)

install_npm() {
    if ! command_exists pnpm; then
        err "pnpm not found even after brew install; check PATH"
        exit 1
    fi
    info "Installing via pnpm: ${NPM_PACKAGES[*]}"
    pnpm add -g "${NPM_PACKAGES[@]}"
    ok "npm packages installed"
}

# ============================================================================
# rust-analyzer: rustup component when rustup manages the toolchain, so the
# proc-macro server matches rustc. Falls back to brew otherwise.
# ============================================================================
install_rust_analyzer() {
    if command_exists rustup; then
        info "Installing rust-analyzer via rustup"
        rustup component add rust-analyzer rust-src
    else
        info "rustup not found; installing rust-analyzer via Homebrew"
        brew install rust-analyzer
    fi
    ok "rust-analyzer installed"
}

# ============================================================================
# Haskell: HLS via ghcup when available (it resolves the GHC pairing);
# fourmolu via brew either way.
# ============================================================================
install_haskell() {
    if command_exists ghcup; then
        info "Installing haskell-language-server via ghcup"
        ghcup install hls
    else
        info "ghcup not found; installing haskell-language-server via Homebrew"
        brew install haskell-language-server
    fi
    info "Installing fourmolu via Homebrew"
    brew install fourmolu
    ok "Haskell tools installed"
}

# ============================================================================
# GitHub release binaries: only what has no package anywhere
# ============================================================================
# fetch_release <repo> <asset> <dest-name>
fetch_release() {
    local repo="$1" asset="$2" name="$3"
    local dest="$BIN_DIR/$name"
    if [[ -x "$dest" && $UPGRADE -eq 0 ]]; then
        ok "Already installed: $name (use --upgrade to refresh)"
        return
    fi
    info "Downloading $name from $repo"
    curl -fsSL -o "$dest" "https://github.com/$repo/releases/latest/download/$asset"
    chmod +x "$dest"
    ok "Installed $name -> $dest"
}

install_github() {
    fetch_release elixir-lang/expert "expert_darwin_${ARCH}" expert
}

# ============================================================================
# Verify
# ============================================================================
EXPECTED_BINS=(
    bash-language-server biome expert fourmolu graphql-lsp
    haskell-language-server-wrapper vscode-html-language-server htmlhint jq
    vscode-json-language-server kulala-fmt lua-language-server luacheck
    marksman rust-analyzer shellcheck shfmt shopify stylua svelteserver
    tailwindcss-language-server tinymist tombi tsc tsgo typstyle
    vue-language-server wc-language-server
)

verify() {
    local missing=()
    for bin in "${EXPECTED_BINS[@]}"; do
        if command_exists "$bin"; then
            ok "$bin"
        else
            missing+=("$bin")
        fi
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
        warn "Not on PATH: ${missing[*]}"
        warn "Open a new shell and re-run to verify, or check PNPM_HOME and ~/.local/bin are on PATH"
    fi
}

main() {
    install_brew
    install_npm
    install_rust_analyzer
    install_haskell
    install_github
    echo
    verify
}

main "$@"
