# Scripts de Administración con Bash y Zenity

## Descripción
Este proyecto contiene varios scripts en Bash para tareas básicas de administración en sistemas Linux.  
Incluye módulos de monitorización de red, servicios, usuarios y puertos, todo gestionado a través de una interfaz gráfica sencilla e intuitiva usando Zenity.

## 🛠️ Requisitos del Sistema
Para que todos los módulos funcionen correctamente, asegúrate de tener instalado:
* **Sistema Operativo:** Ubuntu Desktop
* **Dependencias:** Bash, Zenity, Apache2, curl, jq.

### Instalación de dependencias:
Ejecuta el siguiente comando en tu terminal para instalar todo lo necesario de una vez:
```bash
sudo apt update && sudo apt install zenity apache2 curl jq -y

## Contenido

- `menu.sh` → Menú Principal. Abre la ventana gráfica para usar todas las herramientas.
- `alerta_ssh.sh` → Detecta conexiones SSH y manda una alerta mediante un bot de Telegram.
- `comprobar_red.sh` → 	Prueba de Ping. Verifica la conexión con una dirección IP específica (pasa la IP como argumento).
- `comprobar_servicios.sh` → Comprueba el estado de servicios como Apache y SSH.
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
sudo apt install curl
sudo apt install jq

 Notas importantes
Zenity: Este proyecto no funcionará en Ubuntu Server sin entorno gráfico, ya que necesita ventanas.
Telegram: El script alerta_ssh.sh necesita que configures el Token de tu Bot y tu ID de Chat dentro del código para enviar mensajes.
