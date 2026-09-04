#!/usr/bin/env bash
# ============================================================================
# install-lsp-fedora.sh — install LSP servers, formatters and linters on Fedora
#
# Replaces mason.nvim. dnf first wherever Fedora packages the tool; the rest
# comes from the ecosystem that publishes it:
#   dnf      jq, ShellCheck, shfmt, luacheck, lua-language-server,
#            haskell-language-server, fourmolu, rust-analyzer
#   pnpm     everything published on npm (plus tombi, which ships on npm and
#            is not in Fedora)
#   rustup   rust-analyzer when rustup manages the toolchain (see below)
#   github   marksman, tinymist, typstyle, stylua, expert (not in Fedora)
#
# Usage: ./install-lsp-fedora.sh [--upgrade]
#   --upgrade  re-download GitHub release binaries
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

# Release asset names differ per project; map once here.
case "$(uname -m)" in
    x86_64)
        ARCH_X64=x64        # marksman, tinymist
        ARCH_TRIPLE=x86_64  # typstyle, stylua
        ARCH_GO=amd64       # expert
        ;;
    aarch64)
        ARCH_X64=arm64
        ARCH_TRIPLE=aarch64
        ARCH_GO=arm64
        ;;
    *) err "Unsupported architecture: $(uname -m)"; exit 1 ;;
esac

# ============================================================================
# dnf: everything Fedora packages
# ============================================================================
DNF_PACKAGES=(
    jq
    ShellCheck
    shfmt
    luacheck
    lua-language-server
    haskell-language-server
    fourmolu
    nodejs
    unzip
)

install_dnf() {
    info "Installing via dnf: ${DNF_PACKAGES[*]}"
    # --skip-unavailable: fourmolu and haskell-language-server come and go
    # between Fedora releases; report what is missing at the end instead of
    # aborting here.
    sudo dnf install -y --skip-unavailable "${DNF_PACKAGES[@]}"
    ok "dnf packages installed"

    if ! command_exists fourmolu; then
        if command_exists cabal; then
            info "fourmolu not in dnf; installing via cabal"
            cabal install fourmolu
        else
            warn "fourmolu not in dnf and cabal not found; install via ghcup + cabal"
        fi
    fi
    if ! command_exists haskell-language-server-wrapper; then
        if command_exists ghcup; then
            info "haskell-language-server not in dnf; installing via ghcup"
            ghcup install hls
        else
            warn "haskell-language-server not in dnf and ghcup not found"
        fi
    fi
}

# ============================================================================
# rust-analyzer: dnf unless rustup manages the toolchain. A dnf rust-analyzer
# against a rustup rustc breaks proc-macro expansion (version mismatch), so
# prefer the rustup component when rustup is present.
# ============================================================================
install_rust_analyzer() {
    if command_exists rustup; then
        info "rustup found; installing rust-analyzer as a rustup component"
        rustup component add rust-analyzer rust-src
    else
        info "Installing rust-analyzer via dnf"
        sudo dnf install -y rust-analyzer
    fi
    ok "rust-analyzer installed"
}

# ============================================================================
# pnpm: everything published on npm
# ============================================================================
# html-lsp + json-lsp are one package (vscode-langservers-extracted).
# @typescript/native-preview provides tsgo, which lsp.lua enables but mason
# lists separately. tombi is on npm and not in Fedora.
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
        info "pnpm not found; installing via the official installer (respects PNPM_HOME)"
        curl -fsSL https://get.pnpm.io/install.sh | sh -
        export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
        export PATH="$PNPM_HOME:$PATH"
    fi
    info "Installing via pnpm: ${NPM_PACKAGES[*]}"
    pnpm add -g "${NPM_PACKAGES[@]}"
    ok "npm packages installed"
}

# ============================================================================
# GitHub release binaries: what Fedora does not package
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

# fetch_release_zip <repo> <asset.zip> <bin-name-inside-zip>
fetch_release_zip() {
    local repo="$1" asset="$2" name="$3"
    local dest="$BIN_DIR/$name"
    if [[ -x "$dest" && $UPGRADE -eq 0 ]]; then
        ok "Already installed: $name (use --upgrade to refresh)"
        return
    fi
    local tmp
    tmp="$(mktemp -d)"
    info "Downloading $name from $repo"
    curl -fsSL -o "$tmp/$asset" "https://github.com/$repo/releases/latest/download/$asset"
    unzip -q -o "$tmp/$asset" "$name" -d "$BIN_DIR"
    chmod +x "$dest"
    rm -rf "$tmp"
    ok "Installed $name -> $dest"
}

install_github() {
    fetch_release artempyanykh/marksman   "marksman-linux-${ARCH_X64}"                       marksman
    fetch_release Myriad-Dreamin/tinymist "tinymist-linux-${ARCH_X64}"                       tinymist
    fetch_release Enter-tainer/typstyle   "typstyle-${ARCH_TRIPLE}-unknown-linux-gnu"        typstyle
    fetch_release elixir-lang/expert      "expert_linux_${ARCH_GO}"                          expert
    fetch_release_zip johnnymorganz/stylua "stylua-linux-${ARCH_TRIPLE}.zip"                 stylua
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
    install_dnf
    install_rust_analyzer
    install_npm
    install_github
    echo
    verify
}

main "$@"
