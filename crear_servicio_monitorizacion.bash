#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "Se requiere un solo parámetro: Ruta de la carpeta del proyecto (el repositorio)."
	echo "Se recomienda lanzar desde dentro del repositorio con:"
	echo "sudo $0 \$(pwd)"
	exit 1
fi

ruta_repositorio=$1

ruta_script_monitorizacion="$ruta_repositorio/monitorizacion.bash"

ruta_configuracion_servicio="/etc/systemd/system/proyecto_sistinfo_monitorizacion.service"

sudo echo "" >  "$ruta_configuracion_servicio"

sudo echo "[Unit]" >> "$ruta_configuracion_servicio"

sudo echo "Description=Servicio de monitorización del servidor del proyecto de sistemas informáticos." >> "$ruta_configuracion_servicio"

sudo echo "After=network.target" >> "$ruta_configuracion_servicio"

sudo echo "" >> "$ruta_configuracion_servicio"

sudo echo "[Service]" >> "$ruta_configuracion_servicio"

sudo echo "User=root" >> "$ruta_configuracion_servicio"

sudo echo "WorkingDirectory=$ruta_repositorio" >> "$ruta_configuracion_servicio"

sudo echo "ExecStart=$ruta_script_monitorizacion" >> "$ruta_configuracion_servicio"

sudo echo "Restart=always" >> "$ruta_configuracion_servicio"

sudo echo "" >> "$ruta_configuracion_servicio"

sudo echo "[Install]" >> "$ruta_configuracion_servicio"

sudo echo "WantedBy=multi-user.target" >> "$ruta_configuracion_servicio"

sudo echo "" >> "$ruta_configuracion_servicio"
