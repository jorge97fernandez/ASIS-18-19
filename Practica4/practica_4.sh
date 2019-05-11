#!/bin/bash
#Jorge Fernandez (721529) y Daniel Fraile (721525)



anyadir_usuario()
{
                #Comprobación de si alguno es cadena vacía
                if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
                then
                    echo "Campo invalido"
                    exit 2
                else
                    #Comprobación de si existe o no el usuario
                    if  ssh -n -i ~/.ssh/id_as_ed25519 user@"$4" id -u "$1" 1>/dev/null 2>/dev/null 
                    then
                        echo "El usuario $1 ya existe"
                    else
			ssh -n -i ~/.ssh/id_as_ed25519 user@$4 sudo useradd -d "/home/"$1"" -m -k /etc/skel -K UID_MIN=1815 -U "$1"
			echo ""$1":"$2"" | ssh -n -i ~/.ssh/id_as_ed25519 user@$4 sudo chpasswd
                	ssh -n -i ~/.ssh/id_as_ed25519 user@$4 sudo passwd -x 30 "$1" 1> /dev/null
                        echo "$3 ha sido creado"
                    fi
                fi
		return 0

} 
anyadir_usuarios()
{
    while read -r ip
    do
        if ssh -n -i ~/.ssh/id_as_ed25519 user@$ip pwd 1>/dev/null 2>/dev/null
        then
            while IFS=, read -r identificador contrasenya nombrecompleto
            do
		anyadir_usuario $identificador $contrasenya "$nombrecompleto" $ip
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
        if ssh -n -i ~/.ssh/id_as_ed25519 user@"$ip" pwd 1>/dev/null 2>/dev/null 
        then
            #Creamos el directorio en el que se incluiran las copias de los directorios de los usuarios eliminados del sistema
            ssh -n -i ~/.ssh/id_as_ed25519 user@"$ip" mkdir -p /extra/backup
            #Solo es necesario distinguir el identificador
            while IFS=, read -r identificador resto
            do
                #Comprobamos que se ha indicado un usuario no nulo
                if [ -z "$identificador" ];then
                    echo "Campo invalido"
                    exit 2
                fi
                #Si el identificador es correcto, se procede a comprobar si es usuario del sistema, en cuyo caso sera eliminado del sistema
                if  ssh -n -i ~/.ssh/id_as_ed25519 user@"$ip" id -u "$identificador" 1>/dev/null 2>/dev/null 	
                then
                    #Impedimos el login al usuario que va a ser eliminado del sistema, para posteriormente realizar la copia de su directorio
                    #home y, en caso de haberse realizado esta copia satisfactoriamente, se elimina al usuario del sistema
                    ssh -n -i ~/.ssh/id_as_ed25519 user@"$ip" sudo usermod -L "$identificador"
                    dir_home=`ssh -n -i ~/.ssh/id_as_ed25519 user@"$ip" cat /etc/passwd | grep "$identificador" | cut -d ':' -f 6`
                    if ssh -n -i ~/.ssh/id_as_ed25519 user@"$ip" sudo tar -cf /extra/backup/"$identificador".tar -C "$dir_home" .
                    then
                        ssh -n -i ~/.ssh/id_as_ed25519 user@"$ip" sudo userdel -r "$identificador"
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
