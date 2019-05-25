# Jorge Fernandez (721529) y Daniel Fraile (721525)

read nombreGrupo nombreVolumen tam tipoSis directorio sobra
while [ $(echo "$nombreGrupo" | wc -w)  -gt 0 ];do
	GruposExistentes=$(sudo vgscan)
	existe=$(echo "$GruposExistentes" | grep "$nombreGrupo")
	if [ -z "$existe" ]; then  
		echo "No existe el grupo volumen "$nombreGrupo""
		exit 1
	fi
	GruposExistentes=$(sudo lvscan)
	existe=$(echo "$GruposExistentes" | grep "$nombreVolumen")
	if [ -z "$existe" ]
	then  
		sudo lvcreate -L "$tam" --name "$nombreVolumen" "$nombreGrupo"
		sudo mkfs -F -t "$tipoSis" /dev/"$nombreGrupo"/"$nombreVolumen"
		sudo mount -t "$tipoSis" /dev/"$nombreGrupo"/"$nombreVolumen" "$directorio"
		echo "/dev/"$nombreGrupo"/"$nombreVolumen" "$directorio" "$tipoSis" defaults 0 1\n" | sudo tee -a /etc/fstab
	else 
		sudo lvextend -L+"$tam" /dev/"$nombreGrupo"/"$nombreVolumen"
		sudo e2fsck -f /dev/"$nombreGrupo"/"$nombreVolumen"
		sudo resize2fs /dev/"$nombreGrupo"/"$nombreVolumen"
		
	fi
	read nombreGrupo nombreVolumen tam tipoSis directorio sobra
done
