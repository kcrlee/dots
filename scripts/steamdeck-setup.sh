#!/usr/bin/env bash
# ============================================================================
# steamdeck-setup.sh — run ON THE STEAM DECK (Desktop Mode → Konsole) as `deck`
#
#   1. Installs Tailscale with Tailscale's own SteamOS installer
#      (github.com/tailscale-dev/deck-tailscale → /opt/tailscale)
#   2. Logs the Deck into your tailnet (prints a login URL + QR code)
#   3. Creates an SSH key for the Deck and authorizes it on ajax-iii
#      (asks for kyle's password on ajax-iii once)
#   4. Adds an `ajax` entry to ~/.ssh/config, so afterwards: `ssh ajax`
#
# Safe to re-run — e.g. if Tailscale stops working after a SteamOS update.
# ============================================================================
set -euo pipefail

# ---- The machine the Deck should SSH into (ajax-iii, kyle's Fedora desktop) --
TARGET_USER=kyle
TARGET_NAME=ajax-iii.tail0d952d.ts.net
TARGET_IP=100.121.233.116            # ajax-iii's Tailscale IP (stable per device)
# ajax-iii's SSH host key, so the Deck trusts it without a first-connect prompt.
# Fingerprint: SHA256:7c3XjVkcMB96LyOnMIucu3YcPVTUGFk4bgr3vYrzodA
TARGET_HOSTKEY='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPb/DY1Agwvf4x2JY7qlearlmVkkI8TKv4fJJOWDC52L'

TS=/opt/tailscale/tailscale          # not on sudo's PATH, so always use full path
REPO_URL=https://github.com/tailscale-dev/deck-tailscale.git
REPO_DIR="$HOME/deck-tailscale"
KEY="$HOME/.ssh/id_ed25519"

info() { printf '\033[1;34m[info]\033[0m  %s\n' "$*"; }
ok()   { printf '\033[1;32m[ok]\033[0m    %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m  %s\n' "$*"; }
die()  { printf '\033[1;31m[err]\033[0m   %s\n' "$*" >&2; exit 1; }

# ---- Preflight ---------------------------------------------------------------
[[ $EUID -ne 0 ]] || die "Run this as the deck user, not with sudo — it calls sudo itself."

for cmd in git curl wget jq ssh ssh-keygen ssh-copy-id; do
    command -v "$cmd" >/dev/null || die "Missing '$cmd' (needed by the installer)."
done

info "sudo will ask for the deck user's password."
info "Never set one? Press Ctrl+C, run 'passwd', then run this script again."
sudo -v || die "sudo failed — set a password with 'passwd' and retry."

# ---- 1. Install Tailscale ----------------------------------------------------
if [[ -x $TS ]] && systemctl is-active --quiet tailscaled; then
    ok "Tailscale already installed and running"
else
    info "Installing Tailscale…"
    if [[ -d $REPO_DIR/.git ]]; then
        git -C "$REPO_DIR" pull --ff-only
    else
        git clone --depth 1 "$REPO_URL" "$REPO_DIR"
    fi
    # The installer uses paths relative to the repo, so run it from there.
    (cd "$REPO_DIR" && sudo bash tailscale.sh)
    ok "Tailscale installed (binaries in /opt/tailscale)"
fi

# ---- 2. Log in to the tailnet ------------------------------------------------
ts_state() { "$TS" status --json 2>/dev/null | jq -r '.BackendState // empty'; }

if [[ $(ts_state) == Running ]]; then
    ok "Already logged in to Tailscale"
else
    info "Logging in: open the URL (or scan the QR code) and sign in as kyle@."
    # --operator=deck lets the deck user run `tailscale set/status` without sudo.
    sudo "$TS" up --operator=deck --qr
    [[ $(ts_state) == Running ]] || die "Tailscale login didn't complete."
    ok "Logged in to Tailscale"
fi

# ---- 3. Check ajax-iii is reachable -----------------------------------------
info "Checking ajax-iii is reachable over Tailscale…"
if ! timeout 8 bash -c "exec 3<>/dev/tcp/$TARGET_IP/22" 2>/dev/null; then
    die "Can't reach ajax-iii on port 22 ($TARGET_IP). Is it on and connected to Tailscale?"
fi
ok "ajax-iii is reachable"

# ---- 4. SSH key, known_hosts, config ----------------------------------------
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"

if [[ -f $KEY ]]; then
    ok "Using existing key $KEY"
else
    info "Creating an SSH key for the Deck (press Enter twice for no passphrase)…"
    ssh-keygen -t ed25519 -C "deck@$(hostname)" -f "$KEY"
fi

KH="$HOME/.ssh/known_hosts"
touch "$KH" && chmod 600 "$KH"
if ! grep -qF "${TARGET_HOSTKEY#ssh-ed25519 }" "$KH"; then
    echo "$TARGET_NAME,$TARGET_IP $TARGET_HOSTKEY" >> "$KH"
    ok "Trusted ajax-iii's host key"
fi

CONF="$HOME/.ssh/config"
touch "$CONF" && chmod 600 "$CONF"
if ! grep -qE '^[[:space:]]*Host[[:space:]].*\bajax\b' "$CONF"; then
    cat >> "$CONF" <<EOF

# ajax-iii (kyle's Fedora desktop) over Tailscale
Host ajax ajax-iii
    HostName $TARGET_IP
    User $TARGET_USER
    IdentityFile ~/.ssh/id_ed25519
EOF
    ok "Added 'ajax' to ~/.ssh/config"
fi

# ---- 5. Authorize the Deck's key on ajax-iii ---------------------------------
if ssh -o BatchMode=yes -o ConnectTimeout=8 ajax true 2>/dev/null; then
    ok "Deck's key is already authorized on ajax-iii"
else
    info "Enter kyle's password on ajax-iii (one time only) to install the Deck's key:"
    if ! ssh-copy-id -i "$KEY.pub" ajax; then
        warn "Couldn't install the key with a password (ajax-iii may refuse passwords)."
        warn "Add this line to ~/.ssh/authorized_keys on ajax-iii, then re-run this script:"
        echo
        cat "$KEY.pub"
        echo
        exit 1
    fi
fi

# ---- 6. Verify ---------------------------------------------------------------
ssh -o BatchMode=yes -o ConnectTimeout=8 ajax 'echo "Connected to $(hostname) as $(whoami)"' \
    || die "Key login to ajax-iii failed."
ok "Done! From the Deck, run:  ssh ajax"
