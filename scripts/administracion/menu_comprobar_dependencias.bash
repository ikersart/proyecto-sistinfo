#!/bin/bash

ruta_directorio_de_esta_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ruta_repositorio="$ruta_directorio_de_esta_script/../.."

terminar_script_con_error() {
	mensaje_error="$1"
	zenity --error --text="$mensaje_error"
	if [[ $? -eq 0 ]]; then
		exit 1
	else
		echo "$mensaje_error"
		exit 1
	fi
}

respuesta_actualizar=$(zenity --info \
	--title="" \
	--text="¿Deseas comprobar si hay actualizaciones disponibles para las dependencias? Tardará en cargar el siguiente menú." \
	--ok-label="Sí" \
	--extra-button="No")

codigo_salida=$?

if [[ $codigo_salida -ne 0 && "$respuesta_actualizar" != "No" ]]; then
	exit 0
fi

if [ "$respuesta_actualizar" = "No" ]; then
	actualizar_paquetes=0
else
	actualizar_paquetes=1
fi

source "$ruta_directorio_de_esta_script/comprobar_dependencias.bash" "$actualizar_paquetes"
codigo_salida_comprobacion=$?
if [ $codigo_salida_comprobacion -ne 0 ]; then
	terminar_script_con_error "Error al comprobar dependencias."
fi

funcion_instalar_dependencia() {
	nombre_dependencia="$1"

	if sudo apt install -y "$nombre_dependencia"; then
		zenity --info --title="" --text="La dependencia \"${nombre_dependencia}\" se ha instalado correctamente."
		return 0
	else
		zenity --error --title="" --text="Error al instalar \"${nombre_dependencia}\"."
		return 1
	fi
}

funcion_actualizar_dependencia() {
	nombre_dependencia="$1"

	if sudo apt upgrade -y "$nombre_dependencia"; then
		zenity --info --title="" --text="La dependencia \"${nombre_dependencia}\" se ha actualizado correctamente."
		return 0
	else
		zenity --error --title="" --text="Error al actualizar \"${nombre_dependencia}\"."
		return 1
	fi
}

funcion_preguntar_instalar() {
	nombre_dependencia="$1"
	zenity --question --title="" --text="La dependencia \"${nombre_dependencia}\" no está instalada.\n¿Deseas instalarla?"
}

funcion_preguntar_actualizar() {
	nombre_dependencia="$1"
	zenity --question --title="" --text="Hay una actualización disponible para \"${nombre_dependencia}\".\n¿Deseas actualizarla?"
}

while true; do

	lista_menu=""
	indice=0
	for linea in "${array_lineas[@]}"; do
		estado="${linea%% *}"
		nombre="${linea#* }"
		lista_menu="$lista_menu $indice $estado $nombre"
		indice=$((indice + 1))
	done

	fila_seleccionada=$(zenity --list \
		--title="" \
		--text="Selecciona una dependencia para gestionar:" \
		--column="ID" --column="Estado" --column="Nombre" \
		$lista_menu \
		--height=400 --width=500 \
		--ok-label="Seleccionar" \
		--cancel-label="Salir" \
		--hide-column=1 \
		--print-column=ALL)

	if [[ $? -ne 0 ]]; then
		if [[ -z "$fila_seleccionada" ]]; then
			exit 0
		fi
		terminar_script_con_error "Error crítico en Zenity."
	fi

	# Zenity devuelve: "ID ESTADO NOMBRE"
	IFS='|' read -r indice_dependencia estado_emoji nombre_dependencia <<< "$fila_seleccionada"

	estado_dependencia="${array_estados_dependencias[$indice_dependencia]}"
	case "$estado_dependencia" in
		"0")
			if funcion_preguntar_instalar "$nombre_dependencia"; then
				if funcion_instalar_dependencia "$nombre_dependencia"; then
					array_estados_dependencias[$indice_dependencia]=1
					array_lineas[$indice_dependencia]="✅ ${nombre_dependencia}"
				fi
			fi
			;;
		"1")
			mensaje="La dependencia \"$nombre_dependencia\" está instalada y actualizada."
			zenity --info --title="" --text="$mensaje"
			;;
		"2")
			if funcion_preguntar_actualizar "$nombre_dependencia"; then
				if funcion_actualizar_dependencia "$nombre_dependencia"; then
					array_estados_dependencias[$indice_dependencia]=1
					array_lineas[$indice_dependencia]="✅ ${nombre_dependencia}"
				fi
			fi
			;;
	esac

done

