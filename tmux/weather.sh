#!/usr/bin/env bash
set -euo pipefail

CITY="${1:-${WEATHER_CITY:-Kyiv}}"
LAT="${WEATHER_LAT:-50.4501}"
LON="${WEATHER_LON:-30.5234}"
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

fetch_weather() {
  local json temperature weather_code icon
  json="$(curl -s --max-time 6 "https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&current=temperature_2m,weather_code&temperature_unit=celsius&timezone=auto" 2>/dev/null || true)"
  temperature="$(
    printf '%s\n' "$json" \
      | tr ',{}' '\n' \
      | awk -F: '/"temperature_2m"/ {
          gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2);
          gsub(/"/, "", $2);
          if ($2 ~ /^-?[0-9]+(\.[0-9]+)?$/) { print $2; exit }
        }'
  )"
  weather_code="$(
    printf '%s\n' "$json" \
      | tr ',{}' '\n' \
      | awk -F: '/"weather_code"/ {
          gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2);
          gsub(/"/, "", $2);
          if ($2 ~ /^[0-9]+$/) { print $2; exit }
        }'
  )"
  [[ -n "$temperature" ]] || return 1
  temperature="$(printf '%s\n' "$temperature" | awk '{printf("%+.0f", $1)}')"
  case "${weather_code:-}" in
    0) icon="☀️" ;;
    1|2|3) icon="⛅" ;;
    45|48) icon="🌫️" ;;
    51|53|55|56|57) icon="🌦️" ;;
    61|63|65|66|67|80|81|82) icon="🌧️" ;;
    71|73|75|77|85|86) icon="❄️" ;;
    95|96|99) icon="⛈️" ;;
    *) icon="🌡️" ;;
  esac
  printf '%s %s°C\n' "$icon" "$temperature"
}

prepare_cache() {
  local preferred="${CACHE_DIR}"
  if mkdir -p "$preferred" >/dev/null 2>&1; then
    CACHE_DIR="$preferred"
  else
    CACHE_DIR="/tmp/tmux-cache"
    mkdir -p "$CACHE_DIR"
  fi
  CACHE_FILE="${CACHE_DIR}/weather-${CITY}-${LAT}-${LON}.txt"
}

prepare_cache

if read_cache; then
  exit 0
fi

if output="$(fetch_weather)"; then
  printf '%s\n' "$output" > "$CACHE_FILE"
  printf '%s\n' "$output"
else
  if [[ -f "$CACHE_FILE" ]]; then
    cat "$CACHE_FILE"
  else
    printf '🌡️ n/a\n'
  fi
fi
