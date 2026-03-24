#!/bin/bash

while true
do
opcion=$(zenity --list \
--title="Administrador del Sistema" \
--column="Opciones" \
"Comprobar estado de los programas necesarios" \
"Comprobar conexión" \
"Usuarios conectados" \
"Ver puertos abiertos" \
"Salir")

case $opcion in
    "Comprobar estado de los programas necesarios")
        ./comprobar_servicios.sh
        ;;
    "Comprobar conexión")
        IP=$(zenity --entry --text="Introduce la IP")
        ./comprobar_red.sh $IP
        ;;
    "Usuarios conectados")
        ./usuarios.sh
        ;;
    "Ver puertos abiertos")
        ./puertos.sh
        ;;
    "Salir")
        exit 0
        ;;
esac

done
