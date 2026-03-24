#!/bin/bash

cantidad_parametros_requeridos=2

if [[ $# -ne $cantidad_parametros_requeridos ]]; then
	echo "Se requieren $cantidad_parametros_requeridos parámetros."
	echo "Parámetro 1: Nombre de usuario."
	echo "Parámetro 2: Ruta de la carpeta del proyecto (el repositorio)."
	echo "Se recomienda lanzar desde dentro del repositorio con:"
	echo "sudo ./crear_servicio_monitorizacion.sh \$(whoami) \$(pwd)"
	exit 1
fi

user_name=$1

ruta_repositorio=$2

ruta_configuracion_servicio="/etc/systemd/system/proyecto_sistinfo_monitorizacion.service"

sudo echo "" >  "$ruta_configuracion_servicio"

sudo echo "[Unit]" >> "$ruta_configuracion_servicio"

sudo echo "Description=Servicio de monitorización del servidor del proyecto de sistemas informáticos." >> "$ruta_configuracion_servicio"

sudo echo "After=network.target" >> "$ruta_configuracion_servicio"

sudo echo "" >> "$ruta_configuracion_servicio"

sudo echo "[Service]" >> "$ruta_configuracion_servicio"

sudo echo "User=root" >> "$ruta_configuracion_servicio"

sudo echo "WorkingDirectory=$ruta_repositorio" >> "$ruta_configuracion_servicio"

sudo echo "ExecStart=$ruta_repositorio/monitorizacion.sh" >> "$ruta_configuracion_servicio"

sudo echo "Restart=always" >> "$ruta_configuracion_servicio"

sudo echo "" >> "$ruta_configuracion_servicio"

sudo echo "[Install]" >> "$ruta_configuracion_servicio"

sudo echo "WantedBy=multi-user.target" >> "$ruta_configuracion_servicio"

sudo echo "" >> "$ruta_configuracion_servicio"
