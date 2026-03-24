# Scripts de Administración con Bash y Zenity

## Descripción
Este proyecto contiene varios scripts en Bash para tareas básicas de administración en sistemas Linux.  
Incluye comprobaciones de red, servicios, usuarios y puertos, además de una interfaz gráfica sencilla usando Zenity.

## Requisitos
- Linux
- Bash
- Zenity
- Apache 

## Contenido

- `alerta_ssh.sh` → Detecta conexiones SSH y manda una alerta mediante un bot de Telegram.
- `comprobar_red.sh` → Verifica el estado de la red.
- `comprobar_servicios.sh` → Comprueba el estado de servicios como Apache y SSH.
- `menu.sh` → Menú principal con interfaz gráfica.
- `puertos.sh` → Muestra puertos abiertos del sistema.
- `usuarios.sh` → Información sobre usuarios del sistema.

## Ejecutar el menú principal
./menu.sh

## Ejecutar scripts individuales
./alerta_ssh.sh

./comprobar_red.sh

./comprobar_servicios.sh

./puertos.sh

./usuarios.sh

## Instalación de los servicios
Instalación de dependencias en Ubuntu/Debian:

```bash
sudo apt update
sudo apt install zenity apache2 -y
