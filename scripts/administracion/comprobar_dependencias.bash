#!/bin/bash

comprobar_dependencias() {
	if [[ $# -ne 1 ]]; then
		echo "Requiere un parámetro \"actualizar_paquetes\"." 1>&2
		return 1
	fi

	actualizar_paquetes=$1
	if [[ "$actualizar_paquetes" != "0" && "$actualizar_paquetes" != "1" ]]; then
		echo "El parámetro \"actualizar_paquetes\" debe de ser 0 or 1." 1>&2
		return 1
	fi

	local ruta_directorio_de_esta_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	local ruta_repositorio="$ruta_directorio_de_esta_script/../.."

	# Cargar nombres de dependencias
	array_nombres_dependencias=()
	source "$ruta_repositorio/scripts/cargar_variables/cargar_variables_dependencias.bash"
	if [[ $? -ne 0 ]]; then
		echo "Error al llamar a la script de cargar las variables de las dependencias" 1>&2
		return 1
	fi

	# Obtener lista de paquetes actualizables UNA sola vez
	local lista_actualizables=
	if [[ $actualizar_paquetes -eq 1 ]]; then
		apt update > "/dev/null"
		if [[ $? -ne 0 ]]; then
			echo "Error al llamar apt update." 1>&2
			return 1
		fi 
		lista_actualizables="$(apt list --upgradable)"
		if [[ $? -ne 0 ]]; then
			echo "Error al llamar apt list." 1>&2
			return 1
		fi 
	fi

	array_estados_dependencias=()
	for nombre_dependencia in "${array_nombres_dependencias[@]}"; do
		if command -v "$nombre_dependencia" > "/dev/null" 2> "/dev/null"; then
			linea=""
			if [[ $actualizar_paquetes -eq 1 ]]; then
				if grep -q "^$nombre_dependencia/" <<< "$lista_actualizables"; then
					array_estados_dependencias+=(2)
					linea+="🔄 "
				else
					array_estados_dependencias+=(1)
					linea+="✅ "
				fi
			else
				array_estados_dependencias+=(1)
				linea+="✅ "
			fi
			linea+="$nombre_dependencia"
			echo "$linea"
		else
			array_estados_dependencias+=(0)
			echo "❌ $nombre_dependencia"
		fi
	done

	return 0
}

if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
	archivo_temporal=$(mktemp) || return 1
	if ! comprobar_dependencias $@ > "$archivo_temporal"; then
		rm -f "$archivo_temporal"
		return 1
	fi
	if ! mapfile -t array_lineas < "$archivo_temporal"; then
		rm -f "$archivo_temporal"
		return 1
	fi
	rm -f "$archivo_temporal"
	return 0
else
	comprobar_dependencias $@
	exit $?
fi
