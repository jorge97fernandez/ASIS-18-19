#Jorge Fernandez (721529) y Daniel Fraile (721525)

if [ $# -gt 1 ]
then 
	VolumenBasico="$1"
	GruposExistentes=$(sudo vgscan)
	existe=$(echo "$GruposExistentes" | grep "$VolumenBasico")
	if [ -z "$existe" ]; then  
		echo "No existe el grupo volumen "$VolumenBasico""
		exit 1
	fi
	shift
	for param in "$@"; do
		sudo pvcreate "$param"
		sudo vgextend "$VolumenBasico" "$param"
	done
else 
	exit 1
fi
	
