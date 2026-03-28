#!/bin/bash

ruta_directorio_de_esta_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ruta_repositorio="$ruta_directorio_de_esta_script/../.."
ruta_plantilla_servicio="$ruta_repositorio/configuracion/plantilla_monitorizacion.service.in"
ruta_configuracion_servicio="/etc/systemd/system/proyecto_sistinfo_monitorizacion.service"
export ruta_directorio_script_monitorizacion="$ruta_directorio_de_esta_script"
export ruta_script_monitorizacion="$ruta_directorio_de_esta_script/monitorizacion.bash"

envsubst < "$ruta_plantilla_servicio" > "$ruta_configuracion_servicio"
