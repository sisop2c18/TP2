#!/bin/bash
arch="$1"

function signal_SIGUSR1(){ 
	echo "********************************************************************************************" >> "$arch"
	echo -e "El usuario $(whoami) realizo el evento SIGUSR1. Ocurrio el dia: $(date +"%d-%m-%y") a las $(date +"%T")" >> "$arch"
	free -m | awk 'NR==2 {porcentaje=$4/$2 * 100; print "\nPorcentaje de memoria libre: " porcentaje"%"}' >> "$arch"
	free -m | awk 'NR==2 {porcentaje=$3/$2 * 100; print "\nPorcentaje de memoria usada: " porcentaje"%"}' >> "$arch"
	grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print "\nPorcentaje de CPU en uso: " usage"%"}' >> "$arch"
}
function signal_SIGUSR2(){
	echo "********************************************************************************************" >> "$arch"
	echo -e "El usuario $(whoami) realizo el evento SIGUSR2. Ocurrio el dia: $(date +"%d-%m-%y") a las $(date +"%T")" >> "$arch"
	echo -e "\nEl estado de los filesystem: \n$(df -Th)" >> "$arch"
}
function signal_SIGTERM(){
	echo "********************************************************************************************" >> "$arch"
	echo -e "El proceso finalizo el dia: $(date +"%d-%m-%y") a las $(date +"%T")" >> "$arch"
	exit
}

echo  El numero de proceso es: $$
trap '' SIGINT 

trap signal_SIGUSR1 10

trap signal_SIGUSR2 12

trap signal_SIGTERM 15

if  [[ ! -r "$1" ]]; then
	echo "No tiene permisos para leer el log."
	exit
fi

if  [[ ! -w "$arch" ]]; then
	echo "No tiene permisos para escribir el log."
	exit
fi

while true; do
	sleep 1
done
