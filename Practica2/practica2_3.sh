#!/bin/bash
#Jorge Fernandez (721529) y Daniel Fraile (721525)
if [ "$#" -ne 1 ]
	then
	echo "Sintaxis: practica2_3.sh <nombre_archivo>"
else
	if [ -f "$1" ]
		then 
		chmod ug+x "$1"
 		stat --printf="%A\n" "$1"
	else
		echo "$1 no existe"
	fi
fi 
