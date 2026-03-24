# Scripts de Administración con Bash y Zenity

## Descripción
Este proyecto contiene varios scripts en Bash diseñados para tareas básicas de administración de sistemas en Linux.  
Algunos scripts utilizan Zenity para mostrar interfaces gráficas sencillas.

## Contenido

- `alerta_ssh.sh` → Detecta conexiones SSH y muestra una alerta.
- `comprobar_red.sh` → Verifica el estado de la red.
- `comprobar_servicios.sh` → Comprueba el estado de servicios del sistema.
- `menu.sh` → Menú principal para ejecutar los demás scripts.
- `puertos.sh` → Muestra información sobre puertos abiertos.
- `usuarios.sh` → Gestiona o muestra información de usuarios.

## Requisitos

- Sistema operativo Linux
- Bash
- Zenity (para la interfaz gráfica)

Instalar Zenity en Ubuntu/Debian:
```bash
sudo apt update
sudo apt install zenity -y

## Ejecutar el menú principal
./menu.sh

## Ejecutar cada script de forma individual
./alerta_ssh.sh
./comprobar_red.sh
./comprobar_servicios.sh
./puertos.sh
./usuarios.sh

