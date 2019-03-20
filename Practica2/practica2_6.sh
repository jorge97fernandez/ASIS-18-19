#!/bin/bash
#Jorge Fernandez (721529) y Daniel Fraile (721525)
directorios=$(find $HOME -mindepth 1 -maxdepth 1 -type d -name bin???)
if [ -z $directorios ]
	then
	path=`mktemp -d $HOME/binXXX`
	echo "Se ha creado el directorio $path"
else 
	path=`stat -c %n,%Y $directorios| sort -k 2| head -n1 | cut -f1 -d ',' `

fi

echo "Directorio destino de copia: $path"
ficherosCopiados=0
for fichero in `find ./ -mindepth 1 -maxdepth 1 -type f`; do
	if [ -x "$fichero" ]
		then
		cp "$fichero" "$path"
		echo "$fichero ha sido copiado a $path"
		ficherosCopiados=$((ficherosCopiados + 1))
	fi
done
if [ $ficherosCopiados -eq 0 ] 
	then 
	echo "No se ha copiado ningun archivo"
else
	echo "Se han copiado $ficherosCopiados archivos"
fi


