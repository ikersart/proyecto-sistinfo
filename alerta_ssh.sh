#!/bin/bash

TOKEN="TU_TOKEN_AQUI"
CHAT_ID="TU_CHAT_ID_AQUI"

mensaje="⚠️ ALERTA: SSH caído en $(hostname)"

curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
-d chat_id=$CHAT_ID \
-d text="$mensaje" > telegram_out.txt 2> telegram_error.txt

if [ $? -ne 0 ]; then
    echo "Error al enviar alerta" >> telegram_error.txt
fi
