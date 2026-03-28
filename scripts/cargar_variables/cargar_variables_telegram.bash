#!/bin/bash

cargar_variables() {
        local ruta_directorio_de_esta_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        local ruta_repositorio="$ruta_directorio_de_esta_script/../.."
        local ruta_configuracion_privada="$ruta_repositorio/../configuracion"
        local ruta_scripts="$ruta_repositorio/scripts"
        local ruta_scripts_cargar_variables="$ruta_scripts/cargar_variables"

        local ruta_archivo_configuracion="$ruta_configuracion_privada/telegram.env"
        array_nombres_variables=("telegram_bot_token" "telegram_chat_id")

        source "$ruta_scripts_cargar_variables/cargar_variables.bash" "$ruta_archivo_configuracion" "${array_nombres_variables[@]}" || return 1

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
