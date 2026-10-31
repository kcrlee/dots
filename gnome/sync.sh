#!/usr/bin/env bash
# ============================================================================
# sync.sh — snapshot / restore GNOME + Pop Shell window-management settings
#
#   ./sync.sh dump   # live dconf  → gnome/dconf/*.ini  (then commit)
#   ./sync.sh load   # gnome/dconf/*.ini → live dconf   (new machine)
#
# dconf is a binary database, so it can't be symlinked like the rest of this
# repo. Instead each dconf path is exported to a text .ini file. `dconf load`
# merges: keys absent from the file are left untouched.
#
# Pop Shell's float exceptions are a real file (~/.config/pop-shell/
# config.json) and are handled by `stow gnome`, not by this script.
# ============================================================================
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)/dconf"

# file name → dconf path. Add a line here to track another settings tree.
declare -A PATHS=(
    [pop-shell]=/org/gnome/shell/extensions/pop-shell/
    [wm-keybindings]=/org/gnome/desktop/wm/keybindings/
    [wm-preferences]=/org/gnome/desktop/wm/preferences/
    [mutter]=/org/gnome/mutter/
    [shell-keybindings]=/org/gnome/shell/keybindings/
    [media-keys]=/org/gnome/settings-daemon/plugins/media-keys/
)

EXTENSIONS=(pop-shell@system76.com)

dump() {
    mkdir -p "$DIR"
    for name in "${!PATHS[@]}"; do
        dconf dump "${PATHS[$name]}" > "$DIR/$name.ini"
        echo "dumped ${PATHS[$name]} → dconf/$name.ini"
    done
}

load() {
    for name in "${!PATHS[@]}"; do
        local file="$DIR/$name.ini"
        [[ -f "$file" ]] || { echo "skip: $file missing"; continue; }
        dconf load "${PATHS[$name]}" < "$file"
        echo "loaded dconf/$name.ini → ${PATHS[$name]}"
    done

    # Needs a running GNOME Shell session (talks to it over D-Bus).
    for ext in "${EXTENSIONS[@]}"; do
        if gnome-extensions enable "$ext" 2>/dev/null; then
            echo "enabled $ext"
        else
            echo "warn: couldn't enable $ext (not installed, or no GNOME session) — log in and re-run" >&2
        fi
    done
}

case "${1:-}" in
    dump) dump ;;
    load) load ;;
    *)    echo "usage: $0 {dump|load}" >&2; exit 1 ;;
esac
