#!/bin/bash
BOOT_STR="boot"
ROOTFS_STR="rootfs"
BASEDIR_PATH="/tmp"
BOOT_PARTITION=$(sudo blkid | grep /dev/sd | grep $BOOT_STR | awk '{print $1}' | tr -d ':','')
ROOTFS_PARTITION=$(sudo blkid | grep /dev/sd | grep $ROOTFS_STR | awk '{print $1}' | tr -d ':','')

# Funcion para registrar eventos de errores.
# Entrada: recibe codigo de error y un mensaje sobre el evento.
# Salida: muestra en pantalla fecha, codigo de error y mesnaje del evento.
function logger (){
	EXIT_CODE=$1; MESSAGE=$2; DATE=$(date "+%Y-%m-%d %H:%M:%S")
	echo "$DATE - exit:$EXIT_CODE - $MESSAGE"
	exit $EXIT_CODE
}

# Funcion para montar particiones en determinada carpeta.
# Entrada: recibe la partition para montar y la carpeta de destino del punto de montaje.
function mountPartitionToFolder (){
	PARTITION=$1 ; FOLDER=$2
	# Si existiese desmonta el punto de montaje.
	sudo umount $FOLDER &>/dev/null
	# Monta en una determinada carpeta el punto de montaje.
	echo "Montando particion $PARTITION en $FOLDER"
	sudo mount $PARTITION $FOLDER
	# Comprobacion del resultado de la operacion.
	if [ $? -ne 0 ]; then logger 1 "Error: Montando particion \"$PARTITION\" en \"$FOLDER\""; fi
}

# Comprobacion de la particion de "boot"
# Si no supera la comprobacion no continua la ejecucion.
echo "Comprobando particion: $BOOT_STR"
if [ -z $BOOT_PARTITION ]; then	logger 1 "Error: Particion \"$BOOT_STR\" no encontrada."; fi

# Comprobacion de la particion de "rootfs"
# Si no supera la comprobacion no continua la ejecucion.
echo "Comprobando particion: $ROOTFS_STR"
if [ -z $ROOTFS_PARTITION ]; then logger 1 "Error: Particion \"$ROOTFS_STR\" no encontrada."; fi

# Crear directorios para montar particiones
echo "Creando carpetas para puntos de montajes"
mkdir -p $BASEDIR_PATH/{$BOOT_STR,$ROOTFS_STR}

# Monta la particion de "boot"
mountPartitionToFolder $BOOT_PARTITION $BASEDIR_PATH/$BOOT_STR

# Monta la particion de "rootfs"
mountPartitionToFolder $ROOTFS_PARTITION $BASEDIR_PATH/$ROOTFS_STR

# Abre el navegador de archivos mostrando el contenido de los puntos de montaje.
nautilus {$BASEDIR_PATH/$BOOT_STR,$BASEDIR_PATH/$ROOTFS_STR}

echo "Finalizo el proceso de configuracion."
