#!/bin/bash
#Jorge Fernandez (721529) y Daniel Fraile (721525)

anyadir_usuarios()
{
    while IFS=, read -r identificador contrasenya nombrecompleto
    do
        #Comprobación de si alguno es cadena vacía
        if [ -z "$identificador" ] || [ -z "$contrasenya" ] || [ -z "$nombrecompleto" ]
        then
            echo "Campo invalido"
            exit 2
        else
            #Comprobación de si existe o no el usuario
            if id -u "$identificador" 1>/dev/null 2>/dev/null
            then
                echo "El usuario $identificador ya existe"
            else
				#Realizamos la creacion del usuario, le asignamos la contraseña y le asignamos una validez de 30 dias
                useradd -d "/home/"$identificador"" -m -k /etc/skel -c "$nombrecompleto" -K UID_MIN=1815 -U "$identificador"
                echo ""$identificador":"$contrasenya"" | chpasswd
                passwd -x 30 "$identificador" 1> /dev/null
                echo "$nombrecompleto ha sido creado"
            fi
        fi
    done < "$1"
}


borrar_usuarios()
{
	#Creamos el directorio en el que se incluiran las copias de los directorios de los usuarios eliminados del sistema
	mkdir -p /extra/backup
    #Solo es necesario distinguir el identificador
    while IFS=, read -r identificador resto
    do
		#Comprobamos que se ha indicado un usuario no nulo
		if [ -z "$identificador" ];then
			echo "Campo invalido"
			exit 2
		fi
		#Si el identificador es correcto, se procede a comprobar si es usuario del sistema, en cuyo caso sera eliminado del sistema
		existe='id -u "$identificador" 2> /dev/null'
        if [ ! -z "$existe" ]
        then
			#Impedimos el login al usuario que va a ser eliminado del sistema, para posteriormente realizar la copia de su directorio
			#home y, en caso de haberse realizado esta copia satisfactoriamente, se elimina al usuario del sistema
            usermod -L "$identificador"
            dir_home= $(cat /etc/passwd | grep "$identificador" | cut -d ':' -f 5 )
            tar -cf /extra/backup/"$identificador".tar -C "$dir_home" .
            if [ -r /extra/backup/"$dir_home" ]
            then
                userdel -r "$identificador"
            fi
        fi
    done < "$1"
}

#Effective uid, es decir, id con la que se ejecuta el proceso
if [ "$EUID" -ne 0 ]
then
    echo "Este script necesita privilegios de administracion"
    exit 1
fi
#Comprobacion de que el numero de parametros con los que se ejecuta el script es el correcto
if [ "$#" -ne 2 ]
then
    echo "Numero incorrecto de parametros"
    exit 1
fi

if [ "$1" = "-a" ]
then
    anyadir_usuarios "$2"
elif [ "$1" = "-s" ]
then
    borrar_usuarios "$2"
else
    echo "Opcion invalida" >&2
    exit 1
fi
