```text
Scripts de Administración con Bash y Zenity

Descripción:
Scripts para administración básica en Linux con interfaz gráfica usando Zenity.

Incluye:
- alerta_ssh.sh
- comprobar_red.sh
- comprobar_servicios.sh (Apache, SSH)
- menu.sh
- puertos.sh
- usuarios.sh

Requisitos:
- Linux
- Bash
- Zenity
- Apache

Instalación:
sudo apt update
sudo apt install zenity apache2 -y

Uso:
./menu.sh
./alerta_ssh.sh
./comprobar_red.sh
./comprobar_servicios.sh
./puertos.sh
./usuarios.sh

Notas:
- Puede requerir sudo
- Necesita entorno gráfico
