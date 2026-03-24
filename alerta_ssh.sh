#!/bin/bash

TOKEN="8795064154:AAG65GxzVVOujqrs1TPYQtqY4C1pvfaYHa0"
CHAT_ID="7236122030"

STATUS=$(systemctl is-active ssh)

if [ "$STATUS" != "active" ]; then
    MENSAJE="🚨 ALERTA: SSH está CAÍDO en $(hostname) a las $(date)"
    
    curl -s -X POST https://api.telegram.org/bot$TOKEN/sendMessage \
      -d chat_id=$CHAT_ID \
      -d text="$MENSAJE"
fi
