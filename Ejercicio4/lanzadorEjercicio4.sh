#!/bin/bash

function ayuda(){
	echo "NAME"
	echo "   Ejercicio4.sh"
	echo " "
	echo "SYNOPSIS"
	echo "  ./LanzadorEjercicio4.sh ./archivo.log "
	echo "	kill -s SIGUSR1 nroProceso"
	echo "	kill -s SIGUSR2 nroProceso"
	echo "	kill -s SIGTERM nroProceso"
	echo " "
	echo "DESCRIPTION"
	echo "El script al recibir una seañal SIGURS1 muestra por pantalla Nombre del usuario, fecha y hora del evento (timestamp), porcentaje de uso de la CPU, memoria utilizada y disponible; al recibir una señal SIGURS2 muestra Nombre del usuario, fecha y hora del evento (timestamp), información sobre el estado de utilización de todos los file systems que tenga el equipo. El script termina su ejecucion con una señal SIGTERM y registra la hora de finalización del proceso y termina." 

}

if [ $# == 0 ];then
	echo "La cantidad de parametros ingresados es incorrecto."
	exit
fi

if [ $# == 1 ];then
	if test "$1" = "-h" -o "$1" = "-?" -o "$1" = "-help";then
		ayuda
		exit
	fi
fi

if [ $# -ge 2 ];then
	echo "La cantidad de parametros ingresados es incorrecto."
	exit
fi

if [ ! -f "$1" ];then
	echo "El archivo de log no existe, por lo tanto se creo"
	touch "$1"
fi

if  [[ ! -r "$1" ]]; then
	echo "No tiene permisos para leer el log"
	exit
fi

echo "********************************************************************************************" >> "$1"
echo "El proceso comienza el $(date +"%d-%m-%y") a las $(date +"%T")" >> "$1"
bash "$PWD"/ejercicio4.sh "$1" &
