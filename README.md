# dots

Dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Works on macOS and Fedora Linux.

## Structure

Each top-level directory is a **stow package** — its contents mirror your home directory:

```
dots/
├── bob/          → ~/.config/bob/
├── ghostty/      → ~/.config/ghostty/
├── nvim/         → ~/.config/nvim/
├── systemd/      → ~/.config/systemd/user/
├── tmux/         → ~/.config/tmux/
├── wezterm/      → ~/.config/wezterm/
└── zsh/          → ~/.zshrc, ~/.zshenv
```

A few legacy bash files (`.bashrc`, `.bash_profile`, `.blerc`, `.fzf.bash`) live at the repo root and aren't managed by stow.

## Quick Start

```sh
git clone https://github.com/kyle/dots ~/dots
cd ~/dots
./install.sh
```

The install script works on **macOS** and **Fedora Linux**. It will:

1. Install system packages (`stow`, `zsh`, `fzf`, `fd`, `tmux`, `direnv`)
2. Install Oh My Zsh and third-party zsh plugins
3. Stow config packages (OS-appropriate selection)
4. Set zsh as your default shell

## Manual Usage

### Install a package

```sh
cd ~/dots
stow zsh        # creates ~/.zshrc → dots/zsh/.zshrc, ~/.zshenv → dots/zsh/.zshenv
stow nvim       # creates ~/.config/nvim/ → dots/nvim/.config/nvim/
stow ghostty tmux wezterm   # multiple at once
```

### Remove a package

```sh
stow -D zsh     # removes the symlinks, leaves the files in dots/ intact
```

### Preview changes

```sh
stow -n -v zsh  # dry run — shows what would be linked without doing it
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

## Dependencies

All handled by `install.sh`, but for reference:

- [GNU Stow](https://www.gnu.org/software/stow/) — symlink manager
- [Oh My Zsh](https://ohmyz.sh/) — zsh framework
- [fzf](https://github.com/junegunn/fzf) + [fd](https://github.com/sharkdp/fd) — fuzzy finder
- [direnv](https://direnv.net/) — per-directory environment variables
- Zsh plugins (cloned into `$ZSH_CUSTOM/plugins/`):
  - [zsh-autocomplete](https://github.com/marlonrichert/zsh-autocomplete)
  - [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
  - [fzf-tab](https://github.com/Aloxaf/fzf-tab)
