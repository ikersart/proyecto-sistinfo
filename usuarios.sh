#!/bin/bash

who > logs/usuarios.txt 2> logs/error_usuarios.txt

if [ $? -eq 0 ]; then
    zenity --text-info \
    --title="Usuarios conectados" \
    --filename=usuarios.txt \
    --width=500 --height=400
else
    zenity --error --text="Error al obtener usuarios"
fi
