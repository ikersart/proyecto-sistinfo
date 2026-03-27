#!/bin/bash

# Variables de la lógica principal de la script.
tiempo_de_espera_entre_comprobaciones=5

# Para que de error al utilizar variables no definidas.
set -o nounset

# Variables de rutas.
ruta_directorio_de_esta_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ruta_repositorio="$ruta_directorio_de_esta_script/.."
ruta_carpeta_logs="$ruta_repositorio/logs"
ruta_ssh_conexiones_logs="/var/log/auth.log"
ruta_script_enviar_mensaje_telegram="$ruta_repositorio/enviar_mensaje_telegram.bash"
ruta_script_cargar_variables_servicios="$ruta_repositorio/scripts_cargar_variables/cargar_variables_servicios.bash"
ruta_script_cargar_variables_telegram="$ruta_repositorio/scripts_cargar_variables/cargar_variables_telegram.bash"

# Cargamos las variables de entorno necesarias.
source "$ruta_script_cargar_variables_servicios"
if [[ $? -ne 0 ]]; then
        exit 1
fi
source "$ruta_script_cargar_variables_telegram"
if [[ $? -ne 0 ]]; then
        exit 1
fi

monitorizar_conexiones_ssh() {
	# Esperar eventos de que el archivo ha cambiado e imprimir las líneas nuevas.
	# El proceso de tail nunca se cierra hasta que se cierre esta script.
	# Enviar este output al input del bucle while.
	tail -Fn0 "$ruta_ssh_conexiones_logs" | \
	while read -r line; do
		# Comprobamos que la línea contenga el log de la conexión aceptada.
		if [[ "$line" =~ "Accepted" && "$line" =~ "ssh2" ]]; then
			usuario=$(echo "$line" | sed -n 's/.*for \([^ ]\+\) from.*/\1/p')
			ip=$(echo "$line" | sed -n 's/.*from \([0-9.]*\) port.*/\1/p')
			puerto=$(echo "$line" | sed -n 's/.*port \([0-9]*\) ssh.*/\1/p')

			mensaje="🔐 Nueva conexión SSH detectada."$'\n'
			mensaje+="Usuario: $usuario"$'\n'
			mensaje+="Dirección IP: $ip"$'\n'
			mensaje+="Puerto: $puerto"$'\n'

			"$ruta_script_enviar_mensaje_telegram" "$mensaje" "$telegram_bot_token" "$telegram_chat_id"
		fi
	done
}

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

# Ejecutar en paralelo.
monitorizar_conexiones_ssh &

# Se inicializa el estado de los servicios a previamente activo para que envíe mensaje si están caídos en el momento de ejecutar la script.
servicios_activos=()
for ((i=0; i<${#array_nombres_servicios[@]}; i++)); do
	servicios_activos[$i]=1
done

while true; do
	for ((i=0; i<${#array_nombres_servicios[@]}; i++)); do
		servicio="${array_nombres_servicios[$i]}"
		previamente_activo=${servicios_activos[$i]}

		estado="$(comprobar_servicio $servicio)"
		actualmente_activo=$?

		nuevamente_activo=$actualmente_activo
		if [[ $actualmente_activo -eq 0 ]]; then
			rescatar_servicio "$servicio"
			nuevamente_activo=$?
		fi
		servicios_activos[$i]=$nuevamente_activo

		enviar_mensaje=0
		mensaje=""

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
			mkdir -p "$ruta_carpeta_logs/monitorizacion/telegram_bot"
			"$ruta_script_enviar_mensaje_telegram" "$mensaje" "$telegram_bot_token" "$telegram_chat_id"
		fi
	done
	sleep $tiempo_de_espera_entre_comprobaciones
done
