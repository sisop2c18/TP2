#!/bin/bash

#################################################
#			  Sistemas Operativos			 	#
#		Trabajo Práctico 2 - Ejericio 3			#
#		Nombre del Script: Ejercicio3.sh		#
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

cartaModelo=$1
bd=$2 
DATE=`date '+%Y%m%d%H%M'`
i=0
bothFiles='false'

ErrorSintaxOHelp() { 
	clear
	if test $1 != 0; then
		echo 'Error! La sintaxis del script es la siguiente:'
		echo ""
	else
		echo 'Help:'
		echo "La sintaxis del script es la siguiente:"
		echo ""
	fi
	
	echo "$0" '"Archivo carta modelo" "Informacion clientes"'
	echo ""
	echo 'Para ayuda:'
	echo "$0 -h"
	echo "$0 -?"
	echo "$0 -help"
	exit	
}

if (test $# != 2 ); then 
	if [ "$1" = "-h" ]; then
		ErrorSintaxOHelp 0
	elif [ "$1" = "-help" ]; then
		ErrorSintaxOHelp 0
	elif [ "$1" = "-?" ]; then
		ErrorSintaxOHelp 0
	else 
		ErrorSintaxOHelp 1
	fi
fi

#Compruebo si existe el archivo con la carta
if test -e './'"$cartaModelo"; then
	if test -s './'"$cartaModelo"; then
	 	#Compruebo si existe el archivo con la base de datos
		if test -e "./$bd"; then
			if test -s "./$bd"; then
			 	#	Existe el archivo de la carta y el de la base de datos
			 	if  [[ -r "$cartaModelo" ]]; then ## Chequeo los permisos de lectura de ambos archivos
   	 				if  [[ -r "$bd" ]]; then
						bothFiles='true'
					else
						echo "No tiene permisos para leer ""$bd"
   	 				fi
   	 			else
   	 				echo "No tiene permisos para leer ""$cartaModelo"
				fi
			 	
			else
			 	#	Archivo Vacio
				echo "No hay destinatarios cargados."
			fi	
		else
			echo "No existe el archivo de destinatarios."
			exec $ScriptLoc
		fi
	else
		echo "La carta modelo esta vacia."
	fi	
else
	echo "No existe el archivo de carta modelo."
	exec $ScriptLoc
fi

if [ "$bothFiles" == "true" ]; then
	mkdir -p "$PWD/Cartas_$DATE"

	while IFS=";" read -r NOMBRE APELLIDO DEUDA FECHA INTERES SEGUNDA; do

		if [ "$i" != "0" ]; then
			fileRout=$PWD/Cartas_$DATE/aviso_"$APELLIDO"_"$NOMBRE"_$DATE.txt
			dos=2
			fecha=$FECHA$dos

			cp "$cartaModelo" "$PWD/Cartas_$DATE"
			mv "$PWD/Cartas_$DATE/""$cartaModelo" "$fileRout"

			sed -i 's/@NOMBRE/'"$NOMBRE"'/g' "$fileRout"
			sed -i 's/@APELLIDO/'"$APELLIDO"'/g' "$fileRout"
			sed -i 's/@DEUDA/'"$DEUDA"'/g' "$fileRout"
			sed -i 's/@INTERES/'"$INTERES"'/g' "$fileRout"
			sed -i 's!@FECHA!'"$FECHA"'!' "$fileRout"
			sed -i 's!'"$fecha"'!'"$SEGUNDA"'!' "$fileRout"

		fi

		i=$i+1
	done < "$bd"
	echo ""
	echo "Combinacion completa"
fi 

