#!/bin/bash

cargar_variables() {
	if [[ $# -ne 1 ]]; then
		echo "Esperado un único parámetro: La ruta del archivo de las variables de entorno." 1>&2
		return 1
	fi

	archivo_variables="$1"

	# Comprobar que el archivo de las variables de entorno existe.
	if [[ ! -f "$archivo_variables" ]]; then
	        echo "Falta el archivo de variables de entorno \"$archivo_variables\"." 1>&2
	        return 1
	fi

	# Cargar variables de entorno.
	source "$archivo_variables"

	IFS=',' read -r -a array_nombres_variables <<< "$nombres_variables"
	if [[ $? -ne 0 ]]; then
		echo "Error al cargar la primera variable de entorno: Una lista separada por comas de los nombres del resto de variables de entorno en el archivo de configuración." 1>&2
		return 1
	fi

	# Comprobar que las variables de entorno están definidas.
	for nombre_variable in "${array_nombres_variables[@]}"; do
	        if [[ -z "${!nombre_variable}" ]]; then
	                echo "Falta la variable de entorno \"$nombre_variable\" en el archivo \"$archivo_variables\"." 1>&2
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
	exit 1
fi
