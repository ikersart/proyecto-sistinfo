#!/bin/bash

ss -tuln > puertos.txt 2> error_puertos.txt

if [ $? -eq 0 ]; then
    zenity --text-info \
    --title="Puertos abiertos" \
    --filename=puertos.txt \
    --width=600 --height=400
else
    zenity --error --text="Error al obtener puertos"
fi
