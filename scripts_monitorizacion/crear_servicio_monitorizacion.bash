#!/bin/bash

directorio_de_esta_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ruta_script_servicio="$directorio_de_esta_script/monitorizacion.bash"
ruta_configuracion_servicio="/etc/systemd/system/proyecto_sistinfo_monitorizacion.service"

sudo echo "" >  "$ruta_configuracion_servicio"

sudo echo "[Unit]" >> "$ruta_configuracion_servicio"

sudo echo "Description=Servicio de monitorización del servidor del proyecto de sistemas informáticos." >> "$ruta_configuracion_servicio"

sudo echo "After=network.target" >> "$ruta_configuracion_servicio"

sudo echo "" >> "$ruta_configuracion_servicio"

sudo echo "[Service]" >> "$ruta_configuracion_servicio"

sudo echo "User=root" >> "$ruta_configuracion_servicio"

sudo echo "WorkingDirectory=$ruta_repositorio" >> "$ruta_configuracion_servicio"

sudo echo "ExecStart=$ruta_script_servicio" >> "$ruta_configuracion_servicio"

sudo echo "Restart=always" >> "$ruta_configuracion_servicio"

sudo echo "" >> "$ruta_configuracion_servicio"

sudo echo "[Install]" >> "$ruta_configuracion_servicio"

sudo echo "WantedBy=multi-user.target" >> "$ruta_configuracion_servicio"

sudo echo "" >> "$ruta_configuracion_servicio"
