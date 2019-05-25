#Jorge Fernandez (721529) y Daniel Fraile(721525)

if [ $# -eq 1 ]
then 
	ssh -i /home/as/.ssh/id_as_ed25519 as@"$1" 'sudo sfdisk -s'
	ssh -i /home/as/.ssh/id_as_ed25519 as@"$1" 'sudo sfdisk -l'
	ssh -i /home/as/.ssh/id_as_ed25519 as@"$1" 'sudo df -hT | grep -v "^tmpfs"'
else 
	exit 1
fi
