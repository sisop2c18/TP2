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

inotifywait -e modify,create,delete -r $1 -q -m |

while read path action file; do
        if [[ "$file" =~ $2$ ]] | [[ "*" == $2 ]]; then
		if [[ "$action" =~ "CREATE" ]]; then accion="CREADO"; fi
		if [[ "$action" =~ "MODIFY" ]]; then accion="MODIFICADO"; fi
		if [[ "$action" =~ "DELETE" ]]; then accion="ELIMINADO"; fi
            	echo "El archivo $file fue $accion"
        fi
done

