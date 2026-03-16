# Bootstrap — set ZDOTDIR for systems without /etc/zshenv (macOS).
# On Fedora this is a no-op: /etc/zshenv already sets ZDOTDIR.
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
