# dots

Dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Works on macOS and Fedora Linux.

## Structure

Each top-level directory is a **stow package** — its contents mirror your home directory:

```
dots/
├── bob/          → ~/.config/bob/
├── ghostty/      → ~/.config/ghostty/
├── gnome/        → ~/.config/pop-shell/  (+ dconf snapshots, see below)
├── nvim/         → ~/.config/nvim/
├── systemd/      → ~/.config/systemd/user/
├── tmux/         → ~/.config/tmux/
├── wezterm/      → ~/.config/wezterm/
```

A few bash files (`.bashrc`, `.bash_profile`, `.blerc`, `.fzf.bash`) live at the repo root and aren't managed by stow.

## Quick Start

```sh
git clone https://github.com/kyle/dots ~/dots
cd ~/dots
./install.sh
```

The install script works on **macOS** and **Fedora Linux**. It will:

1. Install system packages (`stow`, `fzf`, `fd`, `tmux`, `direnv`)
2. Stow config packages (OS-appropriate selection)
3. Install [pnpm](https://pnpm.io/), then Node LTS and npm through it (no system Node)
4. Set bash as your default shell

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

## Dependencies

All handled by `install.sh`, but for reference:

- [GNU Stow](https://www.gnu.org/software/stow/) — symlink manager
- [fzf](https://github.com/junegunn/fzf) + [fd](https://github.com/sharkdp/fd) — fuzzy finder
- [direnv](https://direnv.net/) — per-directory environment variables
- [pnpm](https://pnpm.io/) — package manager; also manages Node. Change the global version with `pnpm runtime set node <version> -g`
