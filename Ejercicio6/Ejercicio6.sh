#!/bin/bash


#################################################
#			  Sistemas Operativos		#
#		Trabajo Práctico 2 - Ejericio 6		#
#		Nombre del Script: Ejercicio6.sh	#
#							#
#				Integrantes:		#
#         Miller, Lucas            39353278		#
#         Ramos, Micaela           39266928		#
#         Sapaya, Nicolás Martín   38319489		#
#         Schafer, Federico        39336856		#
#         Secchi, Lucas            39267345		#
#							#
#		Instancia de Entrega: Entrega		#
#							#
#################################################

#	Funcion si se ingresaro parametros incorrectos.
ErrorSintaxOHelp() { 
	clear
	#	Si $1 es 1, entonces es error de sintaxis
	if test $1 != 0; then
		echo 'Error! La sintaxis del script es la siguiente:'
		echo ""
	else
		echo 'Help:'
		echo "La sintaxis del script es la siguiente:"
		echo ""
	fi
	echo "Ejemplo:"
	echo "$0" '"path" ".txt"'
	echo ""
	echo 'Para ayuda:'
	echo "$0 -h"
	echo "$0 -?"
	echo "$0 -help"
	exit	
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

inotifywait -e modify,create,delete -r $1 -q -m |

while read path action file; do
        if [[ "$file" =~ $2$ ]] | [[ "*" == $2 ]]; then
		if [[ "$action" =~ "CREATE" ]]; then accion="CREADO"; fi
		if [[ "$action" =~ "MODIFY" ]]; then accion="MODIFICADO"; fi
		if [[ "$action" =~ "DELETE" ]]; then accion="ELIMINADO"; fi
            	echo "El archivo $file fue $accion"
        fi
done

