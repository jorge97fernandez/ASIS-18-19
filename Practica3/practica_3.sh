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
            exit 1
        else
            #Comprobación de si existe o no el usuario
            if id -u "$identificador" 1>/dev/null 2>/dev/null
            then
                echo "El usuario $identificador ya existe"
            else
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
    #Solo es necesario distinguir el identificador
    while IFS=, read -r identificador resto
    do
        if id -u "$identificador" 1>/dev/null 2>/dev/null
        then
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
