#!/bin/bash

#################################################
#			  Sistemas Operativos			 	#
#		Trabajo Práctico 2 - Ejericio 2			#
#		Nombre del Script: ejercicio2.sh		#
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

#	Funcion si se ingresaro parametros incorrectos.
ErrorSintaxOHelp() { 
clear
	
	if [ $# -eq 0 ]; then
		echo 'Error! La sintaxis del script es la siguiente:'
		echo ""
	else
		echo 'Help:'
		echo "La sintaxis del script es la siguiente:"
		echo ""
	fi

echo "$0 [valor numerico > 0]"

exit 1 
}


Calcular () {
let "maxFib = $4"
CrearArchivo
if [ $2 -le $maxFib ]; then
Calcular $2 $(expr $1 + $2) $(expr $3 + 1) $4 else
echo $2
echo $2 >> salida.txt #escribo el resultaod en el archivo
fi }

CrearArchivo (){
if [ -f  salida.txt ];then #Pregunto si existe , si existe lo borro
rm salida.txt
fi
touch salida.txt #creo un archivo
}

#	Es ayuda ?
if (test $# -eq 1); then 
	if [ "$1" = "-h" ]; then
		ErrorSintaxOHelp 0
	elif [ "$1" = "-help" ]; then
		ErrorSintaxOHelp 0
	elif [ "$1" = "-?" ]; then
		ErrorSintaxOHelp 0
	fi
fi

es_numero='^-?[0-9]+([.][0-9]+)?$'
if [ $# -eq 0 ] || [ "$1" -lt 0 ] || ! [[ "$1" =~ $es_numero ]]; then
ErrorSintaxOHelp
fi


Calcular 0 1 0 $1
exit 1
