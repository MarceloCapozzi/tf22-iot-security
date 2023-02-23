#!/bin/bash
# instalacion y configuracion de docker y docker-compose para raspberry pi os.

# elimina versiones existentes.
sudo apt-get remove docker docker-engine docker.io containerd runc

# instala y configura pre-requisitos.
sudo apt-get update
sudo apt-get -y install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# instala docker.
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# comprobacion del resultado de la instalacion.
if [ $? -ne 0 ]; then "Error: Instalando aplicacion." ; exit 1 ; fi

# instala docker-compose.
sudo curl -SL https://github.com/docker/compose/releases/download/v2.11.2/docker-compose-linux-armv7 -o /usr/local/bin/docker-compose

# comprobacion del resultado de la instalacion.
if [ $? -ne 0 ]; then "Error: Instalando aplicacion." ; exit 1 ; fi

# cambio de permisos para usuarios no root.
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose

# muestra versiones instaladas para docker y docker-compose.
docker --version
docker-compose --version

# Mensaje de finalizacion del proceso.
echo "Proceso de instalacion y configuracion finalizado."