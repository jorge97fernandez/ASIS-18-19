#!/bin/bash
#Jorge Fernandez (721529) y Daniel Fraile (721525)
# Diferencia entre $fichero y "$fichero" en  evaluacion?
for fichero in "$@"
do
	if [ -f "$fichero" ] 
	then
		more "$fichero"
	else
		echo "$fichero no es un fichero"
	fi
done
