#!/bin/bash

# SSH
systemctl is-active ssh > ssh_out.txt 2> ssh_error.txt
estado_ssh=$?

# Apache
systemctl is-active apache2 > apache_out.txt 2> apache_error.txt
estado_apache=$?

mensaje="RESULTADO:\n\n"

if [ $estado_ssh -eq 0 ]; then
    mensaje+="✅ SSH activo\n"
else
    mensaje+="❌ SSH NO activo\n"
    ./alerta_ssh.sh
fi

if [ $estado_apache -eq 0 ]; then
    mensaje+="✅ Apache activo\n"
else
    mensaje+="❌ Apache NO activo\n"
fi

zenity --info --title="Servicios" --text="$mensaje"
