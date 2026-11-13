# dots

Dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Targets Fedora Linux.

## Structure

Each top-level directory is a **stow package** — its contents mirror your home directory:

```
dots/
├── bob/          → ~/.config/bob/
├── cosmic/       → ~/.config/cosmic/  (COSMIC keyboard shortcuts)
├── ghostty/      → ~/.config/ghostty/
├── gnome/        → ~/.config/pop-shell/  (+ dconf snapshots, see below)
├── nvim/         → ~/.config/nvim/
├── ssh/          → ~/.ssh/config
├── systemd/      → ~/.config/systemd/user/
├── tmux/         → ~/.config/tmux/
├── wezterm/      → ~/.config/wezterm/  (optional, not stowed by install.sh)
└── scripts/      (not a stow package — standalone scripts for other machines, see below)
```

`.zshrc` lives at the repo root and isn't managed by stow; `install.sh` symlinks it to `~/.zshrc`.

## Quick Start

```sh
git clone https://github.com/kyle/dots ~/dots
cd ~/dots
./install.sh
```

The install script targets **Fedora Linux**. It will:

1. Install system packages (`stow`, `fzf`, `fd`, `tmux`, `direnv`)
2. Stow config packages (everything except `wezterm` — run `stow wezterm` if you use it)
3. Install [pnpm](https://pnpm.io/), then Node LTS and npm through it (no system Node)
4. Set zsh as your default shell

## Manual Usage

### Install a package

```sh
cd ~/dots
stow nvim       # creates ~/.config/nvim/ → dots/nvim/.config/nvim/
stow ghostty tmux wezterm   # multiple at once
```

### Remove a package

```sh
stow -D nvim    # removes the symlinks, leaves the files in dots/ intact
```

### Preview changes

```sh
stow -n -v nvim # dry run — shows what would be linked without doing it
```

## Adding new configs

### XDG configs (`~/.config/...`)

Most modern tools use `~/.config/<tool>/`. Create a matching structure inside a new package directory:

```sh
# Example: adding Alacritty
mkdir -p alacritty/.config/alacritty
cp ~/.config/alacritty/alacritty.toml alacritty/.config/alacritty/
stow alacritty
```

The key idea: the path inside the package directory, relative to the package root, must match the path relative to `$HOME`.

### Dotfiles in `$HOME` root

For tools that use `~/.<file>` (no `.config` directory):

```sh
# Example: adding .gitconfig
mkdir git
cp ~/.gitconfig git/.gitconfig
stow git
```

### Multiple files in one package

A single package can manage as many files as you want:

```sh
wezterm/
└── .config/
    └── wezterm/
        ├── wezterm.lua
        ├── fonts.lua
        ├── keybinds.lua
        └── utils.lua
```

`stow wezterm` symlinks the entire `wezterm/` directory under `~/.config/`.

## GNOME / Pop Shell

The `gnome` package covers the Pop Shell tiling setup on Fedora:

- `gnome/.config/pop-shell/config.json` holds the float exceptions. It's stowed like any other config, so exceptions you add from the Pop Shell menu are written straight into the repo.
- `gnome/dconf/*.ini` holds the gaps, tiling options and keybindings (Pop Shell, `wm`, `mutter` and shell keybindings). These live in dconf, which can't be symlinked, so they're kept as text snapshots.

```sh
gnome/sync.sh dump   # after changing settings: snapshot live dconf → repo, then commit
gnome/sync.sh load   # on a new machine: apply snapshots (install.sh does this)
```

To track another dconf tree, add a line to `PATHS` in `gnome/sync.sh` and run `dump`. `.stow-local-ignore` stops stow from linking `dconf/` and `sync.sh` into `$HOME`.

## COSMIC

`cosmic/` holds COSMIC desktop keyboard shortcuts and window rules, set up to match the Pop Shell config in `gnome/`. The shortcuts override the system defaults in `/usr/share/cosmic/com.system76.CosmicSettings.Shortcuts/v1/defaults`:

- `Super+Shift+Q` closes the focused window.
- `Super+Shift+Left/Right` (or `H/L`) sends the focused window to the monitor on that side, like Pop Shell. `Super+Shift+Ctrl+Up/Down` (or `K/J`) does the same for monitors stacked vertically. COSMIC's own `Super+Shift+Alt+direction` shortcut for this still works.
- `Super+Shift+Up/Down` (or `K/J`) moves the focused window to the previous/next workspace and switches you there with it, like Pop Shell.
- `Super+Shift+1`–`9` moves the focused window to that workspace and switches you there with it. Use `SendToWorkspace(n)` instead to stay on the current workspace.
- The terminal shortcut opens Ghostty (`system_actions` sets `Terminal`).

`com.system76.CosmicSettings.WindowRules/v1/tiling_exception_custom` lists windows that always float instead of tiling. Each entry is `(appid: "<regex>", title: "<regex>", enabled: true)`, and both regexes must match. This is a different format from the defaults file, which uses `titles: [...]`. An entry in the defaults format makes the whole custom file fail to parse, and COSMIC drops it without logging anything. It adds to the system list in `/usr/share/cosmic/com.system76.CosmicSettings.WindowRules/v1/tiling_exception_defaults`:

- Firefox's Picture-in-Picture window, for both the RPM (`firefox`) and Flatpak (`org.mozilla.firefox`) app IDs.
- The rest of Pop Shell's float list: Chrome's welcome window and `wl-clipboard`.
- An entry with the same app ID and title as a default overrides that default's `enabled`. The `enabled: false` entries switch off the defaults that were switched off in Pop Shell (JetBrains Toolbox and WebStorm dialogs, krunner, Mozilla VPN, Telegram's media viewer), so those windows tile.

Not every Pop Shell setting has a COSMIC equivalent. Pop Shell's tile management mode (`Super+Return`) has none. COSMIC has `Super+X` to swap windows and `Super+R` to resize from the keyboard instead. Snap-to-grid and max window width have no equivalents either. Focus on `Super+arrows/HJKL`, the `Super+O/S/Y/G` toggles, autotiling and cursor-follows-focus already match COSMIC's defaults. The active-window hint (off in Pop Shell) and gaps belong to `com.system76.CosmicComp` and the theme, which aren't tracked here. Set those in Settings.

Stow links the whole `com.system76.CosmicSettings.Shortcuts/` and `com.system76.CosmicSettings.WindowRules/` directories rather than the files inside them. cosmic-settings saves by atomic rename, which would replace a symlinked file with a plain copy. With the directories linked, changes you make in Settings are written straight into the repo. `install.sh` removes COSMIC's empty default directories before stowing so stow can link them.

## Steam Deck

`scripts/steamdeck-setup.sh` sets up a Steam Deck to SSH into ajax-iii over Tailscale. It installs Tailscale with [deck-tailscale](https://github.com/tailscale-dev/deck-tailscale), logs in to the tailnet, creates an SSH key, authorizes it on ajax-iii, and adds an `ajax` host to `~/.ssh/config`. Run it on the Deck in Desktop Mode (Konsole), as the `deck` user, after setting a password with `passwd`:

```sh
curl -fsSLO https://raw.githubusercontent.com/kcrlee/dots/main/scripts/steamdeck-setup.sh
bash steamdeck-setup.sh
```

It's safe to re-run, for example if Tailscale stops working after a SteamOS update.

## Raspberry Pi wake server

`scripts/wake_on_lan_server.py` runs on the Raspberry Pi wired directly to ajax-iii's `enp69s0` port. It wakes ajax-iii with Wake-on-LAN and waits for it to answer ping. Then it unlocks the COSMIC lock screen over SSH, so you can start Steam Remote Play without typing the password. The Pi doesn't have this repo cloned, so copy the script over by hand:

```sh
scp scripts/wake_on_lan_server.py kyle@pi:
ssh kyle@pi sudo python3 wake_on_lan_server.py   # --no-unlock to only wake
```

It exits with 0 if ajax-iii is awake and unlocked, 1 if it didn't wake, and 2 if it woke but the unlock failed.

The unlock needs some one-time setup. The Pi has its own key, `~/.ssh/ajax_unlock_ed25519`, and pins ajax-iii's host key in `~/.ssh/ajax_known_hosts`. To pin it, write `ajax-iii ` followed by the contents of ajax-iii's `/etc/ssh/ssh_host_ed25519_key.pub`. On ajax-iii, `~/.ssh/authorized_keys` accepts the Pi's key only with a forced command, so the key can't do anything except unlock the desktop:

```
restrict,command="loginctl unlock-session $(loginctl show-user kyle -p Display --value)" ssh-ed25519 AAAA… pi: unlock ajax-iii desktop
```

The forced command uses `unlock-session <id>` rather than `unlock-sessions`. Logind allows a user to unlock their own session without asking polkit, but the plural form always checks polkit, and polkit wants an admin password from SSH callers. `show-user … -p Display` looks up the ID of the graphical session, which changes at every login. `cosmic-greeter` drops the lock screen when logind sends the unlock signal.

## Dependencies

All handled by `install.sh`, but for reference:

- [GNU Stow](https://www.gnu.org/software/stow/) — symlink manager
- [fzf](https://github.com/junegunn/fzf) + [fd](https://github.com/sharkdp/fd) — fuzzy finder
- [direnv](https://direnv.net/) — per-directory environment variables
- [pnpm](https://pnpm.io/) — package manager; also manages Node. Change the global version with `pnpm runtime set node <version> -g`
