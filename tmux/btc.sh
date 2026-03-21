#!/usr/bin/env bash
set -euo pipefail

TTL_SECONDS=600
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/tmux"
CACHE_FILE=""

file_mtime() {
  local path="$1"
  if stat -f %m "$path" >/dev/null 2>&1; then
    stat -f %m "$path"
  else
    stat -c %Y "$path"
  fi
}

is_cache_fresh() {
  local now mtime age
  now="$(date +%s)"
  mtime="$(file_mtime "$CACHE_FILE")"
  age=$((now - mtime))
  [[ "$age" -lt "$TTL_SECONDS" ]]
}

read_cache() {
  [[ -f "$CACHE_FILE" ]] || return 1
  is_cache_fresh || return 1
  cat "$CACHE_FILE"
}

fetch_btc() {
  local result
  result="$(curl -s --max-time 5 https://rate.sx/1btc 2>/dev/null | head -1 | cut -d '.' -f 1 || true)"
  result="$(echo -n "$result" | tr -cd '0-9')"
  [[ -n "$result" ]] || return 1
  printf '%s\n' "$result"
}

prepare_cache() {
  local preferred="${CACHE_DIR}"
  if mkdir -p "$preferred" >/dev/null 2>&1; then
    CACHE_DIR="$preferred"
  else
    CACHE_DIR="/tmp/tmux-cache"
    mkdir -p "$CACHE_DIR"
  fi
  CACHE_FILE="${CACHE_DIR}/btc-usd.txt"
}

prepare_cache

if read_cache; then
  exit 0
fi

if output="$(fetch_btc)"; then
  printf '%s\n' "$output" > "$CACHE_FILE"
  printf '%s\n' "$output"
else
  if [[ -f "$CACHE_FILE" ]]; then
    cat "$CACHE_FILE"
  else
    printf 'n/a\n'
  fi
fi
