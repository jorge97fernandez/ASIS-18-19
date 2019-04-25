#!/bin/bash
#Jorge Fernandez (721529) y Daniel Fraile (721525)

#TODO: Revisar todos los status de salida (exit)
#TODO: Eliminar mensajes de depuración

#b) El usuario podrá emplear sudo sin password

#f) La caducidad de la contraseña será de 30 días
#j) Es necesario utilizar los comandos: useradd, userdel, usermod y chpasswd
#k) Los usuarios deberán tener un UID mayor que 1815
#l) Cada usuario tendrá como grupo por defecto uno con su mismo nombre
#m) El directorio home de cada usuario se inicializará con los ficheros de /etc/skel

#o) El borrado de usuarios será completo, incluyendo su directorio home
#p) Antes de borrar un usuario el script realizará un backup de su directorio home (mediante tar y con nombre <usuario>.tar) que será guardado en /extra/backup
#r) En caso de que el backup no pueda ser completado satisfactoriamente, no se realizará el borrado

anyadir_usuarios()
{
    while IFS=, read -r identificador contrasenya nombrecompleto
    do
        #Comprobación de si alguno es cadena vacía
        if [ -z "$identificador" ] || [ -z "$contrasenya" ] || [ -z "$nombrecompleto" ]
        then
            echo "Campo invalido"
            exit 1
	    else
            #Comprobación de si existe o no el usuario
            if id -u "$identificador" 1>/dev/null 2>/dev/null
            then
                echo "El usuario $identificador ya existe"
            else
                echo "$nombrecompleto ha sido creado"
            fi
	    fi
    done < "$1"
}


borrar_usuarios()
{
    #Solo es necesario distinguir el identificador
    while IFS=, read -r identificador resto
    do
        if id -u "$identificador" 1>/dev/null 2>/dev/null
            then
                echo "DEPURACIÓN: El usuario $identificador existe, borrar usuario"
            else
                echo "DEPURACIÓN: El usuario $identificador no existe, continuar ejecucion con normalidad"
            fi
    done < "$1"
}

#Effective uid, es decir, id con la que se ejecuta el proceso
if [ "$EUID" -ne 0 ]
then
    echo "Este script necesita privilegios de administracion"
    exit 1
fi

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
