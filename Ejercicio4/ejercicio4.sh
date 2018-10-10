#!/bin/bash

#################################################
#			  Sistemas Operativos			 	#
#		Trabajo Práctico 2 - Ejericio 4			#
#		Nombre del Script: ejercicio4.sh		#
#												#
#				Integrantes:					#
#         Miller, Lucas            39353278		#
#         Ramos, Micaela           39266928		#
#         Sapaya, Nicolás Martín   38319489		#
#         Schafer, Federico        39336856		#
#         Secchi, Lucas            39267345		#
#												#
#		Instancia de Entrega: Entrega			#
#												#
#################################################

arch="$1"

function signal_SIGUSR1(){ 
	echo "********************************************************************************************" >> "$arch"
	echo -e "El usuario $(whoami) realizo el evento SIGUSR1. Ocurrio el dia: $(date +"%d-%m-%y") a las $(date +"%T")" >> "$arch"
	free -m | awk 'NR==2 {porcentaje=$4/$2 * 100; print "\nPorcentaje de memoria libre: " porcentaje"%"}' >> "$arch"
	free -m | awk 'NR==2 {porcentaje=$3/$2 * 100; print "\nPorcentaje de memoria usada: " porcentaje"%"}' >> "$arch"
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

while true; do
	sleep 1
done
