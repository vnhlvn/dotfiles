#!/bin/bash

# Background daemon that updates tmux status bar user options
# Started via session-created hook in .tmux.conf

INTERVAL=1800 # 30 minutes

update_weather() {
    local city="${1:-Kyiv}"
    local result
    result=$(curl -s --max-time 10 "https://wttr.in/${city}?format=%t" 2>/dev/null)
    if [ $? -eq 0 ] && [ -n "$result" ] && ! echo "$result" | grep -q "Unknown"; then
        result=$(echo -n "$result" | sed 's/[[:space:]][[:space:]]*/ /g; s/^ *//; s/ *$//')
        tmux set -g @weather "wx:${result}"
    fi
}

update_btc() {
    local result
    result=$(curl -s --max-time 5 rate.sx/1btc 2>/dev/null | head -1 | cut -d "." -f 1)
    if [ $? -eq 0 ] && [ -n "$result" ]; then
        tmux set -g @btc "$result"
    fi
}

# Initial fetch
update_weather
update_btc

while true; do
    sleep "$INTERVAL"
    update_weather
    update_btc
done
