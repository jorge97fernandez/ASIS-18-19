#!/bin/bash
#Jorge Fernandez (721529) y Daniel Fraile (721525)
echo -n "Introduzca una tecla: "
read -n1 -r tecla
read resto
case $tecla in
	[[:alpha:]])
		echo "$tecla es una letra";;
	[[:digit:]])
		echo "$tecla es un numero";;
	*)
		echo "$tecla es un caracter especial";;
esac
