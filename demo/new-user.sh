#!/bin/bash
USERNAME=$1 # Recibe por parametro el nombre de usuario.
PASSWORD_STR=$2 # Recibe por parametro la clave para el usuario (USERNAME).
USERNAME_LEN_MIN=4 # Cantidad minima de caracteres para el nombre de usuario.
PASSWORD_LEN_MIN=6 # Cantidad minima de caracteres para la clave del usuario.
SUDO_GROUP="sudo" # Grupo al que se hara miembro al usuario (USERNAME).

# Valida que las variables no sean null.
if [ -z $USERNAME ] || [ -z $PASSWORD_STR ]; then
        # Mensaje de error por falta de usuario y clave.
        echo "Error: se debe especificar el usuario o clave." ; exit 1
fi

# Determina la cantidad de caracteres de las variables.
USERNAME_LEN=$(echo -n "$USERNAME" | wc -c)
PASSWORD_STR_LEN=$(echo -n "$PASSWORD_STR" | wc -c)
# Evalua la cantidad minima de caracteres para las variables.
if [ $USERNAME_LEN -lt $USERNAME_LEN_MIN ] || [ $PASSWORD_STR_LEN -lt $PASSWORD_LEN_MIN ]; then
	# Mensaje de error por no cumplir requisito de longitud de variables.
	echo "Error: la cantidad minima de caracteres es incorrecta para definir el usuario ($USERNAME_LEN_MIN) o clave ($PASSWORD_LEN_MIN)."; #exit 1
fi

echo "Iniciando proceso..."
if [ $? -eq 0 ]; then
	# Determina si el usuario existe.
	IS_USER_EXISTS=$(id $USERNAME 1>/dev/null 2>/dev/null && echo true || echo false)
	# Convierte la clave recibida en un formato de clave valida para el sistema operativo.
	PASSWORD=$(python3 -c "import crypt; print(crypt.crypt('$PASSWORD_STR'))" 2>/dev/null)
	# Evalua si se genero correctamente la clave.
	if [ $? -ne 0 ]; then  echo "Error: No se pudo generar la clave." ; exit 1 ; fi
	# Evalua si existe el usuario.
	if $IS_USER_EXISTS; then
		echo "Actualizando usuario existente ..."
		usermod $USERNAME -G $SUDO_GROUP --password $PASSWORD
	else
		echo "Creando un nuevo usuario ..."
		useradd $USERNAME -G $SUDO_GROUP --password $PASSWORD
	fi
	# Muestra el cambio realizado y finaliza el proceso.
	clear ; echo "El usaurio es: $USERNAME y su clave es: $PASSWORD_STR"
	sleep 10 ; exit 0
fi