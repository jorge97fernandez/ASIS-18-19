#!/bin/bash
#Jorge Fernandez (721529) y Daniel Fraile (721525)
echo -n "Introduzca el nombre del fichero: "
read fichero
if [ -e "$fichero" ] 
then 
	echo -n "Los permisos del archivo $fichero son: "
	find "$fichero" -printf "%M\n"| cut -c 2-4
else 
	echo "$fichero no existe"
fi

