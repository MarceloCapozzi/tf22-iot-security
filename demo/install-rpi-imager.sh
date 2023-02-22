#!/bin/bash
sudo apt-get update
sudo apt-get -y install rpi-imager
if [ $? -ne 0 ]; then
    echo "Error: se ha detectado un problema durante el proceso de instalacion."
    exit 1
fi
echo "Proceso finalizado correctamente."