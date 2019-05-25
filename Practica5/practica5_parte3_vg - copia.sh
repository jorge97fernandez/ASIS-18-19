#Jorge Fernandez (721529) y Daniel Fraile (721525)

if [ $# -gt 1 ]; then 
	VolumenBasico="$1"
	if sudo vgscan | grep "$VolumenBasico"; then
		shift
		for param in "$@"; do
			sudo pvcreate "$param"
			sudo vgextend "$VolumenBasico" "$param"
		done
	else
		echo "No existe el grupo volumen "$VolumenBasico""
		exit 1
	fi
else 
	echo "Numero incorrecto de parametros"
	exit 1
fi
	
