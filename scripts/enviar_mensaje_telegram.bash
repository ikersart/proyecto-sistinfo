#!/bin/bash

ruta_carpeta_logs_telegram="$1"
mensaje="$2"
telegram_bot_token="$3"
telegram_chat_id="$4"

mkdir -p "$ruta_carpeta_logs_telegram"

payload=$(jq -n \
        --arg chat_id "$telegram_chat_id" \
        --arg text "$mensaje" \
        '{ chat_id: $chat_id, text: $text }')

curl -v \
        -X POST "https://api.telegram.org/bot$telegram_bot_token/sendMessage" \
        -H "Content-Type: application/json" \
        -d "$payload" \
        1> "$ruta_carpeta_logs_telegram/curl_stdout.txt" 2> "$ruta_carpeta_logs_telegram/curl_stderr.txt"

exit 0
