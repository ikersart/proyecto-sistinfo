#!/bin/bash

opcion_comprobar_servicios="Comprobar estado de los programas necesarios"
opcion_comprobar_conexion="Comprobar conexión"
opcion_ver_usuarios_conectados="Usuarios conectados"
opcion_ver_puertos_abiertos="Ver puertos abiertos"

while true
do
opcion=$(zenity --list \
--title="Administrador del Sistema" \
--column="Opciones" \
"$opcion_comprobar_servicios" \
"$opcion_comprobar_conexion" \
"$opcion_ver_usuarios_conectados" \
"$opcion_ver_puertos_abiertos")

case $opcion in
	"$opcion_comprobar_servicios")
		./comprobar_servicios.sh
	;;
	"$opcion_comprobar_conexion")
		IP=$(zenity --entry --text="Introduce la IP")
		./comprobar_red.sh $IP
	;;
	"$opcion_ver_usuarios_conectados")
		./usuarios.sh
	;;
	"$opcion_ver_puertos_abiertos")
		./puertos.sh
        ;;
	"")
		exit 0
	;;
esac

done
