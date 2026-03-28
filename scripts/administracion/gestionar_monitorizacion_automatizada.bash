#!/bin/bash

ruta_directorio_de_esta_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ruta_repositorio="$ruta_directorio_de_esta_script/../.."
ruta_scripts="$ruta_repositorio/scripts"

opcion_crear_servicio="Crear servicio de monitorización automatizada"
opcion_iniciar_servicio="Iniciar servicio de monitorización automatizada"

while true
do
	opcion=$(zenity --list \
		--title="Administrador del Sistema" \
		--column="Opciones" \
		"$opcion_crear_servicio" \
		"$opcion_iniciar_servicio" \
		--width="$(xdpyinfo | awk '/dimensions/{print $2}' | cut -d'x' -f1)" \
		--height="$(xdpyinfo | awk '/dimensions/{print $2}' | cut -d'x' -f2)")

	case $opcion in "$opcion_crear_servicio")
			"$ruta_scripts/monitorizacion/crear_servicio_monitorizacion.bash"
		;;
		"$opcion_iniciar_servicio")
			"$ruta_scripts/monitorizacion/iniciar_servicio_monitorizacion.bash"
		;;
		"")
			exit 0
		;;
esac

done
