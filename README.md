# Personal Dotfiles repo + Install Script

Config files for:

- foot terminal (linux)
- ideavim plugin for Jetbrains IDEs
- keyd (linux key remaps)
- nvim
- systemd daemons
- tmux
- wezterm (macos primarily)

All dotfiles are managed with `gnu stow`.

## Usage

Clone the repo:

```bash
git clone git@github.com:KyleLee95/dots.git
```

```bash

cd path/to/dotfiles/repo
```

then from the root directory run the following to create symlinks of all of the
config files:

```bash

stow /
```

or to create a symlink of a single program's config files:

```bash

stow dirname

```

## Popos Window Management (i3-like)

https://github.com/pop-os/shell/issues/142#issuecomment-663079699

## Install Script

The install script only supports **Fedora**.
