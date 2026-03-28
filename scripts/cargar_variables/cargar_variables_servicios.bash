#!/bin/bash

cargar_variables() {
        local ruta_directorio_de_esta_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        local ruta_repositorio="$ruta_directorio_de_esta_script/../.."
        local ruta_configuracion="$ruta_repositorio/configuracion"
        local ruta_scripts="$ruta_repositorio/scripts"
        local ruta_scripts_cargar_variables="$ruta_scripts/cargar_variables"

	ruta_archivo_configuracion_servicios="$ruta_configuracion/servicios.env"

	source "$ruta_scripts_cargar_variables/cargar_variables.bash" "$ruta_archivo_configuracion_servicios" || return 1

	array_nombres_variable_servicios=("${array_nombres_variables[@]}")

	IFS=',' read -r -a array_nombres_servicios <<< "$nombres_servicios"
	if [[ $? -ne 0 ]]; then
		echo "Error al cargar variable \"array_nombres_servicios\"." 1>&2
		return 1
	fi

	return 0
}

# Ejecutar esta script solo si se llama de la manera correcta ( source ruta_script.bash ).
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
	cargar_variables
	return $?
else
	echo "Esta script debe de llamarse con \"source $0\"." 1>&2
	exit 1
fi
