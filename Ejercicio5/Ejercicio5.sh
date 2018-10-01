#!/bin/bash

#################################################
#			  Sistemas Operativos			 	#
#		Trabajo Práctico 2 - Ejericio 5			#
#		Nombre del Script: Ejercicio5.sh		#
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
	#	Si $1 es 1, entonces es error de sintaxis
	if test $1 != 0; then
		echo 'Error! La sintaxis del script es la siguiente:'
		echo ""
	else
		echo 'Help:'
		echo "La sintaxis del script es la siguiente:"
		echo ""
	fi
	echo 'Mostrar Persona:'
	echo "$0 -d DNI"
	echo ""
	echo 'Añadir Persona:'	
	echo "$0 -a DNI Nombre Apellido Nombre_Pais (primer letra del pais en mayuscula)"
	echo ""
	echo 'Eliminar Persona:'
	echo "$0 -e DNI"
	echo 'Listar Personas de ese Pais:'
	echo "$0 -p Nombre_Pais (primer letra del pais en mayuscula)"
	echo ""
	echo 'Para ayuda:'
	echo "$0 -h"
	echo "$0 -?"
	echo "$0 -help"
	exit	
}

#	Funcion para mostrar los datos del dni ingresado.
Mostrar() { 
	clear

	numLineas=$(cat "$2" | wc -l)

	if (test $numLineas -eq 1); then
		echo "No se encuentran personas registradas."
		exit
	fi

	numLineas1=$(cat "$3" | wc -l)

	if (test $numLineas1 -eq 1); then
		echo "ERROR FATAL! Hay personas registradas pero no hay paises."
		exit
	fi

	let count=0

	person=$(awk -F ";" -v dni="$1" -v lines="$numLineas" -v c="$count" '{
		if ($2==dni){
			printf ("%d %d %s %d\n", $1, $2, $3, $4);
		}else{
			c++;
			if (lines==c){
				print "El dni no existe.";
			}	
		}
	}' "$2")

	if [ "$person" = "El dni no existe." ]; then
		echo "$person"
	else
		idPer="$(cut -d' ' -f1 <<<"$person")"
		dni="$(cut -d' ' -f2 <<<"$person")"
		ape="$(cut -d' ' -f3 <<<"$person")"
		nomb="$(cut -d' ' -f4 <<<"$person")"
		idPais="$(cut -d' ' -f5 <<<"$person")"

		awk -F ";" -v idp="$idPer" -v dni="$dni" -v ap="$ape" -v n="$nomb" -v id="$idPais" '{
			if ($1==id){
				printf ("%d %d %s %s %s\n", idp, dni, ap, n, $2);	
			}else{
				print "ERROR FATAL! No se ha encontrado el pais vinculado a la persona seleccionada."
			}
		}' "$3"
	fi

	exit	
}

#	Funcion para aniadir una persona a la db.
Aniadir() { 
	clear

	# dni nomb ap pais archivPersonas archivPaises
	numLineas=$(cat "$5" | wc -l)
	let count=0

	if (test $numLineas -eq 1); then
		numLineas=$(cat "$6" | wc -l)
		if (test $numLineas -eq 1); then
			cadena="1;$1;$3, $2;1"
			echo "$cadena" >> "$5"
			echo "1;$4" >> "$6"
		else
			let count=0
			let found=0

			idPais=$(awk -F ";" -v pais="$4" -v lines="$numLineas" -v c="$count" -v f="$found" '{
			if ((tolower($2))==tolower(pais)){
				print $1;
				f++;
			}else{
				c++;
				if (lines==c && f==0){
					print $1+1
				}
			}
			}' "$6")

			cadena="1;$1;$3, $2;$idPais"
			echo "$cadena" >> "$5"

			idPais=$(awk -F ";" -v pais="$4" -v lines="$numLineas" -v c="$count" -v f="$found" '{
			if ((tolower($2))==tolower(pais)){
				print "ok";
				f++;
			}else{
				c++;
				if (lines==c && f==0){
					print $1+1
				}
			}
			}' "$6")

			if [ "$idPais" != "ok" ]; then
				echo "$idPais;$4" >> "$6"
			fi
		fi
	else
		id=$(awk -F ";" -v dni="$1" -v lines="$numLineas" -v c="$count" '{
			if ($2==dni){
				print "El dni ya existe.";
			}else{
				c++;
				if (lines==c){
					print $1+1
				}		
			}
		}' "$5")

		if [ "$id" = "El dni ya existe." ]; then
			echo "$id"
			exit
		else
			numLineas=$(cat "$6" | wc -l)
			let count=0
			let found=0

			idPais=$(awk -F ";" -v pais="$4" -v lines="$numLineas" -v c="$count" -v f="$found" '{
			if ((tolower($2))==tolower(pais)){
				print $1;
				f++;
			}else{
				c++;
				if (lines==c && f==0){
					print $1+1
				}
			}
			}' "$6")

			cadena="$id;$1;$3, $2;$idPais"
			echo "$cadena" >> "$5"

			idPais=$(awk -F ";" -v pais="$4" -v lines="$numLineas" -v c="$count" -v f="$found" '{
			if ((tolower($2))==tolower(pais)){
				print "ok";
				f++;
			}else{
				c++;
				if (lines==c && f==0){
					print $1+1
				}
			}
			}' "$6")

			if [ "$idPais" != "ok" ]; then
				#	Normalizo la string ingresada en primera en mayus despues minus
				string="$4"
				string=$(echo "$string" | tr '[:upper:]' '[:lower:]')
				string="$(tr '[:lower:]' '[:upper:]' <<< ${string:0:1})${string:1}"
				echo "$idPais;$string" >> "$6"
			fi
		fi
	fi

	echo "Ha sido dado de alta."

	exit	
}

#	Funcion para eliminar una persona de la db.
Eliminar() { 
	clear

	numLineas=$(cat "$2" | wc -l)

	if (test $numLineas -eq 1); then
		echo "No se encuentran personas registradas."
	else
		string=";$1;"

		awk "!/$string/" "$2" > temp && mv temp "$2"
	fi

	exit	
}

#	Funcion para listar todas las personas pertenecientes a un pais.
Listar() { 
	clear

	numLineas=$(cat "$3" | wc -l)
	let count=0
	let found=0

	numLineas=$(cat "$2" | wc -l)

	if (test $numLineas -eq 1); then
		echo "No se encuentran personas registradas."
		exit
	fi

	idPais=$(awk -F ";" -v pais="$1" -v lines="$numLineas" -v c="$count" -v f="$found" '{
		if ((tolower($2))==tolower(pais)){
			printf ("%d", $1);
			f++;
		}else{
			c++;
			if (lines==c && f==0){
				print "El pais no existe.";
			}
		}
	}' "$3")

	if [ "$idPais" = "El pais no existe." ]; then
		echo "$idPais"
	else
		numLineas=$(cat "$2" | wc -l)
		let count=0
		awk -F ";" -v id="$idPais" -v lines="$numLineas" -v c="$count" '{
			if ($4==id){
				printf ("%d %d %s\n", $1, $2, $3);
			}else{
				c++;
				if (lines==c){
					print "No hay ninguna persona que pertenezca a ese pais.";
				}	
			}
		}' "$2"
	fi	

	exit
}

###################################################################################

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

#Compruebo si existe personas.txt
if test -e "$PWD/personas.txt"; then
	if test -s "$PWD/personas.txt"; then
	 	#	Existe el archivo
		archivoPersonas="$PWD"/personas.txt
	else
	 	#	Archivo Vacio
		archivoPersonas="$PWD"/personas.txt
		echo "IdPersona;DNI;Apellido_y_Nombre;idPais" >> "$archivoPersonas"
	fi	
else
	#	Archivo Inexistente o Vacio
	touch personas.txt
	archivoPersonas="$PWD"/personas.txt
	echo "IdPersona;DNI;Apellido_y_Nombre;idPais" >> "$archivoPersonas"
fi

#Compruebo si existe paises.txt
if test -e "$PWD/paises.txt"; then
	if test -s "$PWD/paises.txt"; then
	 	#	Existe el archivo
		archivoPaises="$PWD"/paises.txt
	else
	 	#	Archivo Vacio
		archivoPersonas="$PWD"/paises.txt
		echo "IdPais;nombre" >> "$archivoPaises"
	fi
else
	#	Archivo Inexistente
	touch paises.txt
	archivoPaises="$PWD"/paises.txt
	echo "IdPais;nombre" >> "$archivoPaises"
fi

#	Me fijo que operacion debo realizar
if [ "$1" = "-d" ]; then
	if (test $# -eq 2); then 
		Mostrar $2 "$archivoPersonas" "$archivoPaises"
	else
		ErrorSintaxOHelp 1
	fi
elif [ "$1" = "-a" ]; then
	echo "HELLO MOTO"
	if (test $# -eq 5); then 
		Aniadir $2 "$3" "$4" $5 "$archivoPersonas" "$archivoPaises"
	else
		ErrorSintaxOHelp 1
	fi
elif [ "$1" = "-e" ]; then
	if (test $# -eq 2); then 
		Eliminar $2 "$archivoPersonas"
	else
		ErrorSintaxOHelp 1
	fi
elif [ "$1" = "-p" ]; then
	if (test $# -eq 2); then 
		Listar $2 "$archivoPersonas" "$archivoPaises"
	else
		ErrorSintaxOHelp 1
	fi
else
	ErrorSintaxOHelp 1
fi
