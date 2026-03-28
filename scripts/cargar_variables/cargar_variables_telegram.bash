#!/bin/bash

cargar_variables() {
        local ruta_directorio_de_esta_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        local ruta_repositorio="$ruta_directorio_de_esta_script/../.."
        local ruta_configuracion_privada="$ruta_repositorio/../configuracion"
        local ruta_scripts="$ruta_repositorio/scripts"
        local ruta_scripts_cargar_variables="$ruta_scripts/cargar_variables"

	ruta_archivo_configuracion_telegram="$ruta_repositorio/../configuracion/telegram.env"

        source "$ruta_scripts_cargar_variables/cargar_variables.bash" "$ruta_archivo_configuracion_telegram" || return 1

        array_nombres_variable_dependencias=("${array_nombres_variables[@]}")

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
