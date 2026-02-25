#!/bin/bash

CITY=${1:-"Kyiv"}

RESULT=$(curl -s --max-time 5 "wttr.in/${CITY}?format=%c+%t" 2>/dev/null)

if [ $? -ne 0 ] || [ -z "$RESULT" ] || echo "$RESULT" | grep -q "Unknown"; then
    echo "❌ Error"
    exit 1
fi

echo -n "$RESULT" | sed 's/  */ /g'
