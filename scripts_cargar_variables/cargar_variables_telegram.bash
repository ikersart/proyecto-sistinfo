#!/bin/bash

cargar_variables_telegram() {

	local directorio_de_esta_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

	# Fuera del repositorio por motivos de seguridad, para no subirlo a internet por accidente.
	local archivo_variables_telegram="$directorio_de_esta_script/../../configuracion/telegram.env"
	array_variables_telegram=("telegram_bot_token" "telegram_chat_id")

	source "$directorio_de_esta_script/cargar_variables.bash" "$archivo_variables_telegram" "${array_variables_telegram[@]}"

        if [[ $? -ne 0 ]]; then

                return 1
        fi

        return 0

}

# Ejecutar esta script solo si se llama de la manera correcta ( source ruta_script.bash ).
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then

	cargar_variables_telegram
	return $?
else
	echo "Esta script debe de llamarse con \"source $0\"." 1>&2
	return 1 2>/dev/null || exit 1
fi
