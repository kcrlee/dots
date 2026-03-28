#!/usr/bin/env bash
# Claude Code status line - mirrors Starship prompt style
# Receives JSON on stdin

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model_id=$(echo "$input" | jq -r '.model.id // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
cache_write=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
rate_5h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rate_7d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# Session length: sum of total input + output tokens across the session
session_tokens=$((total_input + total_output))

# Estimate session cost in USD based on model pricing (per million tokens)
# Prices: input / output / cache_write / cache_read (per 1M tokens)
estimate_cost() {
  local mid="$1"
  local in_tok="$2"
  local out_tok="$3"
  local cw_tok="$4"
  local cr_tok="$5"

  # Default to claude-sonnet-4 pricing if model unknown
  local price_in price_out price_cw price_cr
  case "$mid" in
    *claude-opus-4*|*claude-opus-4-5*)
      price_in=15.00; price_out=75.00; price_cw=18.75; price_cr=1.50 ;;
    *claude-sonnet-4*|*claude-sonnet-4-5*|*claude-sonnet-4-6*)
      price_in=3.00; price_out=15.00; price_cw=3.75; price_cr=0.30 ;;
    *claude-haiku-3-5*)
      price_in=0.80; price_out=4.00; price_cw=1.00; price_cr=0.08 ;;
    *claude-3-5-sonnet*|*claude-3-5-haiku*)
      price_in=3.00; price_out=15.00; price_cw=3.75; price_cr=0.30 ;;
    *claude-3-opus*)
      price_in=15.00; price_out=75.00; price_cw=18.75; price_cr=1.50 ;;
    *)
      price_in=3.00; price_out=15.00; price_cw=3.75; price_cr=0.30 ;;
  esac

  # Cost = (tokens / 1,000,000) * price
  awk -v i="$in_tok" -v o="$out_tok" -v cw="$cw_tok" -v cr="$cr_tok" \
      -v pi="$price_in" -v po="$price_out" -v pcw="$price_cw" -v pcr="$price_cr" \
    'BEGIN {
      cost = (i/1000000)*pi + (o/1000000)*po + (cw/1000000)*pcw + (cr/1000000)*pcr
      if (cost >= 1.00)      printf "$%.2f", cost
      else if (cost >= 0.01) printf "$%.3f", cost
      else if (cost > 0)     printf "$%.4f", cost
      else                   print ""
    }'
}

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

# Format token count as e.g. "12.3k" or "1.2M"
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

# Model name (overall usage label)
if [ -n "$model" ]; then
  printf ' \033[2m[%s]\033[0m' "$model"
fi

# Session usage: token count + estimated cost
if [ "$session_tokens" -gt 0 ]; then
  formatted=$(format_tokens "$session_tokens")
  cost=$(estimate_cost "$model_id" "$total_input" "$total_output" "$cache_write" "$cache_read")
  if [ -n "$cost" ]; then
    printf ' \033[2msession:%s (%s)\033[0m' "$formatted" "$cost"
  else
    printf ' \033[2msession:%s\033[0m' "$formatted"
  fi
fi

# Context window: used % and remaining %
if [ -n "$used" ]; then
  printf ' \033[2mctx:%s%%\033[0m' "$used"
fi
if [ -n "$remaining" ]; then
  printf ' \033[2mcompact:%s%%\033[0m' "$remaining"
fi

# Claude.ai subscription rate limits (5-hour session and 7-day weekly)
if [ -n "$rate_5h" ]; then
  printf ' \033[2m5h:%s%%\033[0m' "$(printf '%.0f' "$rate_5h")"
fi
if [ -n "$rate_7d" ]; then
  printf ' \033[2m7d:%s%%\033[0m' "$(printf '%.0f' "$rate_7d")"
fi

printf '\n'
