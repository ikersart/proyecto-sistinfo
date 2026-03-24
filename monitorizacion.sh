
#!/bin/bash

mensaje_timeout=5
iteration_timeout=5

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

telegram_bot_token="8795064154:AAG65GxzVVOujqrs1TPYQtqY4C1pvfaYHa0"
telegram_chat_id="7236122030"

servicios=("ssh" "apache2" "proyecto_sistinfo_monitorizacion")
servicios_mensajes_timeouts=()

for ((i=0; i<${#servicios[@]}; i++)); do
	servicios_mensajes_timeouts[$i]=$mensaje_timeout
done

while true; do

	for ((i=0; i<${#servicios[@]}; i++)); do

		servicio="${servicios[$i]}"

		estado="$(comprobar_servicio $servicio)"
		activo=$?

		if [[ $activo -eq 0 ]]; then

			mensaje="El servicio \"$servicio\" está caído."$'\n'$'\n'"$estado"$'\n'

			rescatar_servicio "$servicio"
			activo=$?

			if [[ $activo -eq 1 ]]; then

				mensaje="$mensaje✅ Se ha podido rescatar el servicio."
			else
				mensaje="$mensaje❌ No se ha podido rescatar el servicio."
			fi

			if [[ ${servicios_mensajes_timeouts[$i]} -le 0 ]]; then

				# Añadir sobrante porque en esta misma iteración se va a decrementar.
				servicios_mensajes_timeouts[$i]=$(( $mensaje_timeout + $iteration_timeout ))

				echo "probando"
				curl -s -o /dev/null \
					-X POST "https://api.telegram.org/bot$telegram_bot_token/sendMessage" \
					-d chat_id=$telegram_chat_id \
					-d text="$mensaje"
			fi
		fi

		if [[ ${servicios_mensajes_timeouts[$i]} -gt 0 ]]; then

			servicios_mensajes_timeouts[$i]=$(( servicios_mensajes_timeouts[$i] - $iteration_timeout ))
		fi
	done

	sleep $iteration_timeout
done
