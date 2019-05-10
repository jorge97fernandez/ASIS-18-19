#!/bin/bash
#Jorge Fernandez (721529) y Daniel Fraile (721525)


anyadir_usuarios()
{
    while read ip
    do
        if -i ~/.ssh/id_as_ed25519 as@"$ip"
        then
            while IFS=, read -r identificador contrasenya nombrecompleto resto
            do
                #Comprobación de si alguno es cadena vacía
                if [ -z "$identificador" ] || [ -z "$contrasenya" ] || [ -z "$nombrecompleto" ]
                then
                    echo "Campo invalido"
                    exit 2
                else
                    #Comprobación de si existe o no el usuario
                    if ssh -i ~/.ssh/id_as_ed25519 as@"$ip" id -u "$identificador" 1>/dev/null 2>/dev/null
                    then
                        echo "El usuario $identificador ya existe"
                    else
                        #Realizamos la creacion del usuario, le asignamos la contraseña y le asignamos una validez de 30 dias
                        ssh -i ~/.ssh/id_as_ed25519 as@"$ip" useradd -d "/home/"$identificador"" -m -k /etc/skel -c "$nombrecompleto" -K UID_MIN=1815 -U "$identificador"
                        echo ""$identificador":"$contrasenya"" | ssh -i ~/.ssh/id_as_ed25519 as@"$ip" chpasswd
                        ssh -i ~/.ssh/id_as_ed25519 as@"$ip" passwd -x 30 "$identificador" 1> /dev/null
                        echo "$nombrecompleto ha sido creado"
                    fi
                fi
            done < "$1"
        else
            echo "$ip no es accesible"
        fi
    done < "$2"
}


borrar_usuarios()
{
    while read ip
    do
        if -i ~/.ssh/id_as_ed25519 as@"$ip"
        then
            #Creamos el directorio en el que se incluiran las copias de los directorios de los usuarios eliminados del sistema
            ssh -i ~/.ssh/id_as_ed25519 as@"$ip" mkdir -p /extra/backup
            #Solo es necesario distinguir el identificador
            while IFS=, read -r identificador resto
            do
                #Comprobamos que se ha indicado un usuario no nulo
                if [ -z "$identificador" ];then
                    echo "Campo invalido"
                    exit 2
                fi
                #Si el identificador es correcto, se procede a comprobar si es usuario del sistema, en cuyo caso sera eliminado del sistema
                if [ ssh -i ~/.ssh/id_as_ed25519 as@"$ip" id -u "$identificador" 1>/dev/null 2>/dev/null ]
                then
                    #Impedimos el login al usuario que va a ser eliminado del sistema, para posteriormente realizar la copia de su directorio
                    #home y, en caso de haberse realizado esta copia satisfactoriamente, se elimina al usuario del sistema
                    ssh -i ~/.ssh/id_as_ed25519 as@"$ip" usermod -L "$identificador"
                    dir_home= $(ssh -i ~/.ssh/id_as_ed25519 as@"$ip" cat /etc/passwd | grep "$identificador" | cut -d ':' -f 5 )
                    ssh -i ~/.ssh/id_as_ed25519 as@"$ip" tar -cf /extra/backup/"$identificador".tar -C "$dir_home" .
                    if ssh -i ~/.ssh/id_as_ed25519 as@"$ip" test-r /extra/backup/"$dir_home"
                    then
                        ssh -i ~/.ssh/id_as_ed25519 as@"$ip" userdel -r "$identificador"
                    fi
                fi
            done < "$1"
        else
            echo "$ip no es accesible"
        fi
    done < "$2"
}


#Effective uid, es decir, id con la que se ejecuta el proceso
if [ "$EUID" -ne 0 ]
then
    echo "Este script necesita privilegios de administracion"
    exit 1
fi
#Comprobacion de que el numero de parametros con los que se ejecuta el script es el correcto
if [ "$#" -ne 3 ]
then
    echo "Numero incorrecto de parametros"
    exit 1
fi

if [ "$1" = "-a" ]
then
    anyadir_usuarios "$2" "$3"
elif [ "$1" = "-s" ]
then
    borrar_usuarios "$2" "$3"
else
    echo "Opcion invalida" >&2
    exit 1
fi
