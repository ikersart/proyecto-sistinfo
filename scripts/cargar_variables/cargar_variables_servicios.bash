#!/bin/bash

cargar_variables() {
        local ruta_directorio_de_esta_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        local ruta_repositorio="$ruta_directorio_de_esta_script/../.."
        local ruta_configuracion="$ruta_repositorio/configuracion"
        local ruta_scripts="$ruta_repositorio/scripts"
        local ruta_scripts_cargar_variables="$ruta_scripts/cargar_variables"

	local ruta_archivo_configuracion="$ruta_configuracion/servicios.env"
	array_nombres_variables=("nombres_servicios")

	source "$ruta_scripts_cargar_variables/cargar_variables.bash" "$ruta_archivo_configuracion" "${array_nombres_variables[@]}"
	if [[ $? -ne 0 ]]; then

		return 1
	fi

	IFS=',' read -r -a array_nombres_servicios <<< "$nombres_servicios"
	if [[ $? -ne 0 ]]; then

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
	return 1 2>/dev/null || exit 1
fi
