#!/bin/bash

cargar_variables() {

	# Ejemplo (hay que poner cada parámetro entre comillas):
	# cargar_variables.bash configuracion/variables.env primera_variable segunda_variable

	if [[ ! $# -gt 0 ]]; then

		echo "Falta el primer parámetro, la ruta del archivo de las variables de entorno." 1>&2
		return 1
	fi
	local archivo_variables="$1"
	shift

	if [[ ! $# -gt 0 ]]; then

		echo "Falta el segundo parámetro, una array con los nombres de las variables de entorno." 1>&2
		return 1
	fi
	local array_variables=("$@")

	# Comprobar que el archivo de las variables de entorno existe.
	if [[ ! -f "$archivo_variables" ]]; then

	        echo "Falta el archivo de variables de entorno \"$archivo_variables\"." 1>&2
	        return 1
	fi

	# Cargar variables de entorno.
	source "$archivo_variables"

	# Comprobar que las variables de entorno están definidas.
	for variable in "${array_variables[@]}"; do

	        if [[ -z "${!variable}" ]]; then

	                echo "Falta la variable de entorno privada \"$variable\" en el archivo \"$archivo_variables\"." 1>&2
	                return 1
	        fi
	done
}

# Ejecutar esta script solo si se llama de la manera correcta ( source ruta_script.bash ).
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then

	cargar_variables "$@"
	return $?
else
	echo "Esta script debe de llamarse con \"source $0\"." 1>&2
	return 1 2>/dev/null || exit 1
fi
