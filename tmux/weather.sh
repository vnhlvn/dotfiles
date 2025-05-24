#!/bin/bash

LAT=${1:-"50.4547"}
LON=${2:-"30.5238"}

RESPONSE=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&current=temperature_2m,weather_code")

if [ $? -ne 0 ]; then
    echo "❌ Error"
    exit 1
fi

TEMP=$(echo $RESPONSE | grep -o '"temperature_2m":[0-9.-]*' | cut -d':' -f2 | tr -d '\n\r')
WEATHER_CODE=$(echo $RESPONSE | grep -o '"weather_code":[0-9]*' | cut -d':' -f2 | tr -d '\n\r')

if [ -z "$TEMP" ]; then
    echo "❌ Error"
    exit 1
fi

HOUR=$(date +%H)
IS_NIGHT=0
if [ "$HOUR" -ge 20 ] || [ "$HOUR" -lt 6 ]; then
    IS_NIGHT=1
fi

if [ "$IS_NIGHT" -eq 1 ]; then
    case $WEATHER_CODE in
        0) ICON="🌙" ;;
        1|2|3) ICON="☁️" ;;
        45|48) ICON="🌫️" ;;
        51|53|55|56|57) ICON="🌧️" ;;
        61|63|65|66|67) ICON="🌧️" ;;
        71|73|75|77) ICON="❄️" ;;
        80|81|82) ICON="🌧️" ;;
        85|86) ICON="🌨️" ;;
        95|96|99) ICON="⛈️" ;;
        *) 
            TEMP_INT=$(echo $TEMP | cut -d'.' -f1)
            if [ "$TEMP_INT" -le 0 ]; then
                ICON="❄️"
            elif [ "$TEMP_INT" -le 15 ]; then
                ICON="☁️"
            elif [ "$TEMP_INT" -le 25 ]; then
                ICON="☁️"
            else
                ICON="🌙"
            fi
            ;;
    esac
else
    case $WEATHER_CODE in
        0) ICON="☀️" ;;
        1|2|3) ICON="⛅" ;;
        45|48) ICON="🌫️" ;;
        51|53|55|56|57) ICON="🌦️" ;;
        61|63|65|66|67) ICON="🌧️" ;;
        71|73|75|77) ICON="❄️" ;;
        80|81|82) ICON="🌦️" ;;
        85|86) ICON="🌨️" ;;
        95|96|99) ICON="⛈️" ;;
        *) 
            TEMP_INT=$(echo $TEMP | cut -d'.' -f1)
            if [ "$TEMP_INT" -le 0 ]; then
                ICON="❄️"
            elif [ "$TEMP_INT" -le 15 ]; then
                ICON="☁️"
            elif [ "$TEMP_INT" -le 25 ]; then
                ICON="⛅"
            else
                ICON="☀️"
            fi
            ;;
    esac
fi

echo -n "${ICON} ${TEMP}°C"
