#!/bin/bash

# --- FUNCIÓN PARA CHEQUEAR UN SERVICIO ---
chequear_estado() {
    local nombre_servicio=$1
    local archivo_log=$2
    
    # Ejecutamos el comando y guardamos salida y error
    systemctl is-active "$nombre_servicio" > "logs/${archivo_log}_out.txt" 2> "logs/${archivo_log}_error.txt"
    return $?
}

# --- CUERPO PRINCIPAL DEL SCRIPT ---

# 1. Llamamos a la función para cada servicio
chequear_estado "ssh" "ssh"
estado_ssh=$?

chequear_estado "apache2" "apache"
estado_apache=$?

chequear_estado "proyecto_sistinfo_monitorizacion" "monitorizacion"
estado_monitorizacion=$?

# 2. Construimos el mensaje para Zenity
mensaje="RESULTADO DE LA MONITORIZACIÓN:\n\n"

[ $estado_ssh -eq 0 ] && mensaje+="✅ SSH activo\n" || mensaje+="❌ SSH NO activo\n"
[ $estado_apache -eq 0 ] && mensaje+="✅ Apache activo\n" || mensaje+="❌ Apache NO activo\n"
[ $estado_monitorizacion -eq 0 ] && mensaje+="✅ Monitorización activo\n" || mensaje+="❌ Monitorización NO activo\n"

# 3. Mostramos el resultado final
zenity --info --title="Estado de Servicios" --text="$mensaje" --width=400

