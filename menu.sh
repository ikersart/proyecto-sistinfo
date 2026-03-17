#!/bin/bash

while true
do
opcion=$(zenity --list \
--title="Administrador del Sistema" \
--column="Opciones" \
"Comprobar servicios" \
"Comprobar red" \
"Usuarios conectados" \
"Puertos abiertos" \
"Salir")

case $opcion in
    "Comprobar servicios")
        ./comprobar_servicios.sh
        ;;
    "Comprobar red")
        IP=$(zenity --entry --text="Introduce la IP")
        ./comprobar_red.sh $IP
        ;;
    "Usuarios conectados")
        ./usuarios.sh
        ;;
    "Puertos abiertos")
        ./puertos.sh
        ;;
    "Salir")
        exit 0
        ;;
esac

done
