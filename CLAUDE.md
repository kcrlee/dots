# dots

Dotfiles managed with GNU Stow. Default shell is bash (Homebrew).

## Structure
- Stow packages: `nvim/`, `ghostty/`, `tmux/`, `wezterm/`, `bob/`, `systemd/`
- Root-level configs (NOT stow-managed, must be manually copied to `~/`): `.bashrc`, `.bash_profile`, `.blerc`, `.fzf.bash`

## Key details
- fzf uses `fd` for file finding (FZF_DEFAULT_COMMAND, FZF_CTRL_T_COMMAND, FZF_ALT_C_COMMAND)
- `install.sh` handles package installation, stowing, and setting default shell
- A pre-stop hook (`~/.claude/hooks/check-uncommitted.sh`) prompts for commit on uncommitted changes
