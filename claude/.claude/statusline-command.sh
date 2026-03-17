#!/usr/bin/env bash
# Claude Code status line - mirrors Starship prompt style
# Receives JSON on stdin

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')

# Session length: sum of total input + output tokens across the session
session_tokens=$((total_input + total_output))

# Directory: show only last component (matches starship truncation_length=1)
dir=$(basename "$cwd")

# Git branch and status (skip locks to avoid blocking)
git_branch=""
git_status=""
if git_branch_raw=$(git -C "$cwd" -c core.checkStat=minimal symbolic-ref --short HEAD 2>/dev/null); then
  git_branch="$git_branch_raw"
  # Check for uncommitted changes
  if ! git -C "$cwd" diff --quiet 2>/dev/null || ! git -C "$cwd" diff --cached --quiet 2>/dev/null; then
    git_status="!"
  fi
  # Check for untracked files
  if [ -n "$(git -C "$cwd" ls-files --others --exclude-standard 2>/dev/null | head -1)" ]; then
    git_status="${git_status}?"
  fi
fi

# Format session token count as e.g. "12.3k" or "1.2M"
format_tokens() {
  local n=$1
  if [ "$n" -ge 1000000 ]; then
    printf "%.1fM" "$(echo "scale=1; $n / 1000000" | bc)"
  elif [ "$n" -ge 1000 ]; then
    printf "%.1fk" "$(echo "scale=1; $n / 1000" | bc)"
  else
    printf "%d" "$n"
  fi
}

# Build the status line
# Arrow (green)
printf '\033[1;32m➜\033[0m '

# Directory (bold)
printf '\033[1m%s\033[0m' "$dir"

# Git info
if [ -n "$git_branch" ]; then
  printf ' \033[1;34mgit:(\033[1;31m%s\033[1;34m)\033[0m' "$git_branch"
  if [ -n "$git_status" ]; then
    printf ' \033[1;33m%s\033[0m' "$git_status"
  fi
fi

# Model name
if [ -n "$model" ]; then
  printf ' \033[2m[%s]\033[0m' "$model"
fi

# Context usage (used %)
if [ -n "$used" ]; then
  printf ' \033[2mctx:%s%%\033[0m' "$used"
fi

# Session length (cumulative tokens)
if [ "$session_tokens" -gt 0 ]; then
  formatted=$(format_tokens "$session_tokens")
  printf ' \033[2msession:%s\033[0m' "$formatted"
fi

# % left to auto compaction (remaining %)
if [ -n "$remaining" ]; then
  printf ' \033[2mcompact:%s%%\033[0m' "$remaining"
fi

printf '\n'
