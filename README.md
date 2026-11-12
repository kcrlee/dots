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
└── scripts/      (not a stow package — standalone setup scripts, see below)
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

`cosmic/` holds COSMIC desktop keyboard shortcuts. These override the system defaults in `/usr/share/cosmic/com.system76.CosmicSettings.Shortcuts/v1/defaults`:

- `Super+Shift+Q` closes the focused window.
- `Super+Shift+H/J/K/L` moves focus to the window left/down/up/right. This replaces COSMIC's default of moving the window itself; `Super+Shift+arrows` still do that.
- `Super+Shift+1`–`9` moves the focused window to that workspace and switches you there with it. Use `SendToWorkspace(n)` instead to stay on the current workspace.

Stow links the whole `com.system76.CosmicSettings.Shortcuts/` directory rather than the `custom` file inside it. cosmic-settings saves by atomic rename, which would replace a symlinked file with a plain copy. With the directory linked, shortcuts you change in Settings → Keyboard are written straight into the repo. `install.sh` removes COSMIC's empty default directory before stowing so stow can link the directory.

## Steam Deck

`scripts/steamdeck-setup.sh` sets up a Steam Deck to SSH into ajax-iii over Tailscale. It installs Tailscale with [deck-tailscale](https://github.com/tailscale-dev/deck-tailscale), logs in to the tailnet, creates an SSH key, authorizes it on ajax-iii, and adds an `ajax` host to `~/.ssh/config`. Run it on the Deck in Desktop Mode (Konsole), as the `deck` user, after setting a password with `passwd`:

```sh
curl -fsSLO https://raw.githubusercontent.com/kcrlee/dots/main/scripts/steamdeck-setup.sh
bash steamdeck-setup.sh
```

It's safe to re-run, for example if Tailscale stops working after a SteamOS update.

## Dependencies

All handled by `install.sh`, but for reference:

- [GNU Stow](https://www.gnu.org/software/stow/) — symlink manager
- [fzf](https://github.com/junegunn/fzf) + [fd](https://github.com/sharkdp/fd) — fuzzy finder
- [direnv](https://direnv.net/) — per-directory environment variables
- [pnpm](https://pnpm.io/) — package manager; also manages Node. Change the global version with `pnpm runtime set node <version> -g`
