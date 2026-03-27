#!/bin/bash

cargar_variables_servicios() {
	local directorio_de_esta_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

	# Fuera del repositorio por motivos de seguridad, para no subirlo a internet por accidente.
	local archivo_variables_servicios="$directorio_de_esta_script/../configuracion/servicios.env"
	array_variables_servicios=("nombres_servicios")

	source "$directorio_de_esta_script/cargar_variables.bash" "$archivo_variables_servicios" "${array_variables_servicios[@]}"
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
	cargar_variables_servicios
	return $?
else
	echo "Esta script debe de llamarse con \"source $0\"." 1>&2
	return 1 2>/dev/null || exit 1
fi
