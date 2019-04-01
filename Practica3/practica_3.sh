#!/bin/bash

anyadir_usuarios()
{
    while IFS=, read -r identificador contrasenya username
    do
        if [ -z "$identificador" ] || [ -z "$contrasenya" ] || [ -z "$username" ]
        then
	    echo "Campo invalido"
	else
            echo -e "$username ha sido creado\n"
	fi
    done < "$1"
}


borrar_usuarios()
{
    echo "Borrando usr"
    echo "$1"
}


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
