#!/bin/bash
#Jorge Fernandez (721529) y Daniel Fraile (721525)
echo -n "Introduzca el nombre de un directorio: "
read respuesta
if [ -d "$respuesta" ]
	then
	numDirectorios=$(find "$respuesta" -mindepth 1 -type d | wc -l)
	numFicheros=$(find "$respuesta" -type f | wc -l)
	echo "El numero de ficheros y directorios en $respuesta es de $numFicheros y $numDirectorios, respectivamente"
else
	echo "$respuesta no es un directorio"
fi
