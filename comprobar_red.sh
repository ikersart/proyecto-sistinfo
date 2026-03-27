#!/bin/bash

IP=$1

if [ -z "$IP" ]; then
    zenity --error --text="No se ha introducido IP"
    exit 1
fi

ping -c 2 $IP > logs/ping_out.txt 2> logs/ping_error.txt

if [ $? -eq 0 ]; then
    zenity --info --text="✅ Conexión correcta con $IP"
else
    zenity --error --text="❌ No hay conexión con $IP"
fi
