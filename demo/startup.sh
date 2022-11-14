#!/bin/bash
clear
USERNAME="user1234" # Nombre de usuario - Cantidad minima de caracteres: 4.
PASSWORD="pass1234" # Clave para el usuario (USERNAME) - Cantidad minima de caracteres: 6.
TRY=1 # Contador para ciclo iterativo.
MAX_TRY=120 # Maxima cantidad de intentos.
TIMEOUT=2 # Tiempo de espera en segundos.
CMD="new-user.sh" # Script para cambio de clave.
DEVICE_ROOTFS="/dev/mmcblk0p2" # Dispositivo para buscar.
FOLDER_ROOTFS="/tmp/rootfs" # Carpeta temporal para punto de montaje.
FOLDER_TOOLS="/opt/tools" # Carpeta donde se almacenan herramientas del proceso.

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

# Ciclo iterativo para evaluar si existe el dispositivo definido (DEVICE_ROOTFS)
# Salida: crea usuario (USERNAME) con determinada clave (PASSWORD) en el sistema de archivos del dispositivo (DEVICE_ROOTFS). Si el usuario existe, cambia su clave (PASSWORD).
IS_DEVICE_EXISTS=false # Determina si existe el dispositivo.
while ! $IS_DEVICE_EXISTS && [ $TRY -le $MAX_TRY ];
do
	# Evalua si existe el dispositivo.
	if [ -e $DEVICE_ROOTFS ]; then
		# Inicio el proceso.
		echo "Iniciando proceso de configuracion ..."
		# Copia el script en la nueva ubicacion.
		SCRIPT="$FOLDER_TOOLS/$CMD"
		# Crea carpeta temporal para montar "rootfs"
		sudo mkdir -p $FOLDER_ROOTFS
		# Monta la partition "rootfs"
		mountPartitionToFolder $DEVICE_ROOTFS $FOLDER_ROOTFS
		# Crea carpeta para almacenar herramientas del proceso.
		sudo mkdir -p $FOLDER_ROOTFS/$FOLDER_TOOLS
		# Copia el script para cambio de clave.
		sudo cp $SCRIPT $FOLDER_ROOTFS/$FOLDER_TOOLS
		# Crea el usuario o cambia la clave de un usuario existente en el sistema operativo externo.
		sudo chroot $FOLDER_ROOTFS /bin/bash -c "$SCRIPT $USERNAME $PASSWORD"
		# Desmonta la carpeta utilizada y libera el dispositivo.
		sudo umount $FOLDER_ROOTFS
		# Define el estado del dispositivo.
		IS_DEVICE_EXISTS=true
		echo "Proceso finalizado."
	else
		# Muestra el numero de intento y solicita insertar el dispositivo.
		echo "[$TRY/$MAX_TRY] Por favor inserte el dispositivo de almacenamiento ... "
	fi
	# Incremento en 1 el contador de iteraciones.
	let $((TRY=TRY+1))
	# Tiempo de espera antes de iterar nuevamente.
	sleep $TIMEOUT ; clear
done

# Evalua el resultado y si no encuentra el dispositivo muestra error.
if [ $TRY -eq $MAX_TRY ] && [ ! -e $IS_DEVICE_EXISTS ];then
	clear; 	echo "Atencion: No fue posible detectar el dispositivo de almacenamiento." ; exit 1
fi