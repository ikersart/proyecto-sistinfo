#!/bin/bash

ruta_directorio_de_esta_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ruta_repositorio="$ruta_directorio_de_esta_script/../.."

# Cargar la lista de nombres de dependencias.
source "$ruta_repositorio/scripts/cargar_variables/cargar_variables_dependencias.bash"
if [[ $? -ne 0 ]]; then
    exit 1
fi

# Comprobar dependencias.
for nombre_dependencia in "${array_nombres_dependencias[@]}"; do
    if command -v "$nombre_dependencia" > "/dev/null" 2>&1; then
        echo "✅ $nombre_dependencia"
    else
        echo "❌ $nombre_dependencia"
    fi
done
