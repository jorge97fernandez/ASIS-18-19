#!/bin/bash
#Jorge Fernandez (721529) y Daniel Fraile (721556)

echo -n "Usuarios y carga media de trabajo: "
uptime | sed 's/,  /;/g' | cut -d ';' -f 2,3
echo -n "Memoria ocupada y libre: "
free -h  |sed 's/ \{1,\}/ /g' |grep "Mem"| cut -d ' ' -f 3,4
echo -n "Swap utilizado: "
free -h  |sed 's/ \{1,\}/ /g' |grep "Swap"| cut -d ' ' -f 3
echo -n "Espacio ocupado y libre: "
df -h --total | grep "total" | sed 's/ \{1,\}/ /g' | cut -d ' ' -f 3,4
echo -n "Num. de puertos abiertos: "
netstat -l | grep "LISTEN" | wc -l 
echo -n "Num. de conexiones establecidas: "
netstat |grep "CONNECTED" | wc -l
echo -n "Num. de procesos en ejecución: "
ps -N | grep [[:digit:]] | wc -l
