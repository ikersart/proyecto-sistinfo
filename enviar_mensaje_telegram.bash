#!/bin/bash

mensaje=$1
telegram_bot_token=$2
telegram_chat_id=$3

ruta_directorio_de_esta_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ruta_carpeta_logs="$ruta_directorio_de_esta_script/logs"

mkdir -p "$ruta_carpeta_logs/monitorizacion/telegram_bot"

payload=$(jq -n \
        --arg chat_id "$telegram_chat_id" \
        --arg text "$mensaje" \
        '{ chat_id: $chat_id, text: $text }')

curl -v \
        -X POST "https://api.telegram.org/bot$telegram_bot_token/sendMessage" \
        -H "Content-Type: application/json" \
        -d "$payload" \
        1> "$ruta_carpeta_logs/monitorizacion/telegram_bot/curl_stdout.txt" 2> "$ruta_carpeta_logs/monitorizacion/telegram_bot/curl_stderr.txt"

exit 0
