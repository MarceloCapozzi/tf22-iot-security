#!/bin/bash
NESSUS_DEB="nessus-10.4.1.deb"
NESSUS_PATH="/opt/tools/nessus"
NESSUS=$NESSUS_PATH/$NESSUS_DEB
ARCH=$(dpkg --print-architecture 2>/dev/null)
URL_ARM="https://github.com/MarceloCapozzi/tf22-iot-security/raw/main/tools/nessus/nessus-10.4.1-raspberrypios_armhf.deb"
URL_AMD64="https://github.com/MarceloCapozzi/tf22-iot-security/raw/main/tools/nessus/nessus-10.4.1-ubuntu1404_amd64.deb"

# Comprobacion sobre arquitectura del sistema operativo.
# Si no supera la comprobacion no continua la ejecucion. 
if [ -z $ARCH ]; then "Error: se ha detectado un problema durante el proceso de instalacion." ; exit 1 ; fi

# Evalua la arquitectura y asigna la URL de descarga.
case $ARCH in
  armhf)
    URL=$URL_ARM ;;
  amd64)
    URL=$URL_AMD64 ;;
  *)
    # Sino es una arquitectura definida en la evaluacion muestra error.
    echo "No se ha encontrado una version de aplicacion compatible con su equipo" ; exit 1 ;;
esac

# Crear directorios para guardar la aplicacion.
sudo mkdir -p $NESSUS_PATH

# Descargar y guardar aplicacion.
sudo wget -q -O $NESSUS $URL

# Instalar aplicacion.
sudo dpkg -i $NESSUS

# Comprobacion del resultado de la operacion.
if [ $? -ne 0 ]; then "Error: Instalando aplicacion." ; exit 1 ; fi

# Mensaje de finalizacion del proceso.
echo "Proceso finalizado."