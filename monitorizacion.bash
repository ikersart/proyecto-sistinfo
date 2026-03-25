
#!/bin/bash

# Variables de la lógica principal de la script.
servicios=("ssh" "apache2" "proyecto_sistinfo_monitorizacion")
tiempo_de_espera_entre_comprobaciones=5

# Variables de entorno necesarias.
archivo_de_variables_de_entorno_privadas="../telegram.env" # Fuera del repositorio por motivos de seguridad. No queremos subirlo a internet por accidente.
variables_de_entorno_privadas=("telegram_bot_token" "telegram_chat_id")

if [[ ! -f "$archivo_de_variables_de_entorno_privadas" ]]; then

	echo "Falta el archivo de variables de entorno privadas \"$archivo_de_variables_de_entorno_privadas\"." 1>&2
	exit 1
fi

# Cargar variables de entorno.
source "$archivo_de_variables_de_entorno_privadas"

for variable_de_entorno_privada in "${variables_de_entorno_privadas[@]}"; do

	if [[ -z "${!variable_de_entorno_privada}" ]]; then

		echo "Falta la variable de entorno privada \"$variable_de_entorno_privada\" en el archivo \"$archivo_de_variables_de_entorno_privadas\"."
		exit 1
	fi
done

comprobar_servicio() {

	local servicio="$1"

	systemctl is-active --quiet "$servicio"
	local codigo=$?

	local activo=1
	local estado=""

	if [[ $codigo -ne 0 ]]; then

		activo=0
		estado="$(systemctl status $servicio 2>&1)"
	fi

	echo "$estado"

	return $activo
}

rescatar_servicio() {

	local servicio="$1"

	systemctl daemon-reload --quiet
	systemctl enable --quiet "$servicio"
	systemctl restart "$servicio"

	systemctl is-active --quiet "$servicio"
	local codigo=$?

	local activo=0

	if [[ $codigo -eq 0 ]]; then

		activo=1
	fi

	return $activo
}

primera_iteracion=1
servicios_activos=()

for ((i=0; i<${#servicios[@]}; i++)); do
	servicios_activos[$i]=0
done

while true; do

	for ((i=0; i<${#servicios[@]}; i++)); do

		servicio="${servicios[$i]}"
		previamente_activo=${servicios_activos[$i]}

		estado="$(comprobar_servicio $servicio)"
		actualmente_activo=$?

		enviar_mensaje=0
		mensaje=""

		nuevamente_activo=$actualmente_activo

		if [[ $actualmente_activo -eq 0 ]]; then

			rescatar_servicio "$servicio"
			nuevamente_activo=$?
		fi

		servicios_activos[$i]=$nuevamente_activo

		# No enviar mensajes en la primera iteración. Complica la lógica y no es necesario.
		if [[ $primera_iteracion -eq 1 ]]; then

			primera_iteracion=0
			continue
		fi

		# Sólo avisa una vez se ha conseguido rescatar, después de que llevase un tiempo caído.
		if [[ $previamente_activo -eq 0 && $nuevamente_activo -eq 1 ]]; then

				enviar_mensaje=1
				mensaje+="✅ Se ha rescatado el servicio \"$servicio\" que estaba caído."
		fi

		# Avisa si se ha caido ahora mismo, pero no avisa si ya estaba caído.
		if [[ $previamente_activo -eq 1 && $actualmente_activo -eq 0 ]]; then

			enviar_mensaje=1
			mensaje+="El servicio \"$servicio\" se ha caído."$'\n'$'\n'

			if [[ $nuevamente_activo -eq 1 ]]; then

				mensaje+="✅ Se ha podido rescatar el servicio."
			else
				mensaje+="❌ No se ha podido rescatar el servicio."$'\n'$'\n'"$estado"
			fi
		fi

		if [[ $enviar_mensaje -eq 1 ]]; then

			mkdir -p ./logs/monitorizacion/telegram_bot

			payload=$(jq -n \
				--arg chat_id "$telegram_chat_id" \
				--arg text "$mensaje" \
				'{ chat_id: $chat_id, text: $text }')

			curl -v \
				-X POST "https://api.telegram.org/bot$telegram_bot_token/sendMessage" \
				-H "Content-Type: application/json" \
				-d "$payload" \
				1> ./logs/monitorizacion/telegram_bot/curl_stdout.txt 2> ./logs/monitorizacion/telegram_bot/curl_stderr.txt
		fi
	done

	sleep $tiempo_de_espera_entre_comprobaciones
done
