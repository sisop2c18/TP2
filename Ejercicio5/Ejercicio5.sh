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

	if (test $2 -eq 1 || test $3 -eq 1 ); then
		echo "Uno o ambos archivos se encuentran vacios."
		exit
	fi

	numLineas=$(cat "$4" | wc -l)
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
	}' "$4")

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
			}
		}' "$5"
	fi

	exit	
}

#	Funcion para aniadir una persona a la db.
Aniadir() { 
	clear

	if (test $5 -eq 1 || test $6 -eq 1 ); then
		echo "Uno o ambos archivos se encuentran vacios."
		exit
	fi

	# dni nomb ap pais vacio vacio archivPersonas archivPaises
	numLineas=$(cat "$7" | wc -l)
	let count=0

	id=$(awk -F ";" -v dni="$1" -v lines="$numLineas" -v c="$count" '{
		if ($2==dni){
			print "El dni ya existe.";
		}else{
			c++;
			if (lines==c){
				print $1+1
			}		
		}
	}' "$7")

	if [ "$id" = "El dni ya existe." ]; then
		echo "$id"
	else
		numLineas=$(cat "$8" | wc -l)
		let count=0
		let found=0

		idPais=$(awk -F ";" -v pais="$4" -v lines="$numLineas" -v c="$count" -v f="$found" '{
		if ($2==pais){
			print $1;
			f++;
		}else{
			c++;
			if (lines==c && f==0){
				print $1+1
			}
		}
		}' "$8")

		cadena="$id;$1;$3, $2;$idPais"
		echo "$cadena"
		echo "$cadena" >> "$7"

		idPais=$(awk -F ";" -v pais="$4" -v lines="$numLineas" -v c="$count" -v f="$found" '{
		if ($2==pais){
			print "ok";
			f++;
		}else{
			c++;
			if (lines==c && f==0){
				print $1+1
			}
		}
		}' "$8")

		if [ "$idPais" != "ok" ]; then
			echo "$idPais;$4" >> "$8"
		fi
	fi

	exit	
}

#	Funcion para eliminar una persona de la db.
Eliminar() { 
	clear

	if (test $2 -eq 1); then
		echo "El archivo de personas se encuentran vacio."
		exit
	fi

	#sed -i '/$1/d' "$3"
	#awk -F ";" -v dni="$1" '$2==dni {
	#	rm $0;
	#	printf "%d %d %s %d %d\n", $1, $2, $3, $4, $NR}' "$3"
	#numLineas=$(cat "$4" | wc -l)
	#let count=0

	#awk -F ";" -v dni="$1" -v lines="$numLineas" -v c="$count" '{
	#	if ($2==dni){

#		}else{
#			c++;
#			if (lines==c){
#				print "El dni no existe.";
#			}	
#		}
#	}' "$4"

	

	exit	
}

#	Funcion para listar todas las personas pertenecientes a un pais.
Listar() { 
	clear

	if (test $2 -eq 1 || test $3 -eq 1 ); then
		echo "Uno o ambos archivos se encuentran vacios."
		exit
	fi

	numLineas=$(cat "$5" | wc -l)
	let count=0
	let found=0

	idPais=$(awk -F ";" -v pais="$1" -v lines="$numLineas" -v c="$count" -v f="$found" '{
		if ($2==pais){
			printf ("%d", $1);
			f++;
		}else{
			c++;
			if (lines==c && f==0){
				print "El pais no existe.";
			}
		}
	}' "$5")

	if [ "$idPais" = "El pais no existe." ]; then
		echo "$idPais"
	else
		numLineas=$(cat "$4" | wc -l)
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
		}' "$4"
	fi	

	exit
}

#	Se comprueba que la cantidad de parametros sea 1 2 o 4
if (test $# -lt 1 || test $# -gt 5 ); then 	
	ErrorSintaxOHelp 1
fi

#	Es ayuda ?
if [ "$1" = "-h" ]; then
	ErrorSintaxOHelp 0
elif [ "$1" = "-help" ]; then
	ErrorSintaxOHelp 0
elif [ "$1" = "-?" ]; then
	ErrorSintaxOHelp 0
fi

#Compruebo si existe personas.txt
if test -e "$PWD/personas.txt"; then
	if test -s "$PWD/personas.txt"; then
	 		#	Existe el archivo
		archivoPersonas="$PWD"/personas.txt
		let personasVacio=0
	else
	 		#	Archivo Vacio
		archivoPersonas="$PWD"/personas.txt
		let personasVacio=1
	fi	
else
	#	Archivo Inexistente o Vacio
	touch personas.txt
	archivoPersonas="$PWD"/personas.txt
	let personasVacio=1
fi

#Compruebo si existe paises.txt
if test -e "$PWD/paises.txt"; then
	if test -s "$PWD/paises.txt"; then
	 	#	Existe el archivo
		archivoPaises="$PWD"/paises.txt

		let paisesVacio=0
	else
	 		#	Archivo Vacio
		archivoPersonas="$PWD"/paises.txt
		let paisesVacio=1
	fi
else
	#	Archivo Inexistente
	touch paises.txt
	archivoPaises="$PWD"/paises.txt
	let paisesVacio=1
fi

#	Me fijo que operacion debo realizar
if [ "$1" = "-d" ]; then
	Mostrar $2 $personasVacio $paisesVacio "$archivoPersonas" "$archivoPaises"
elif [ "$1" = "-a" ]; then
	Aniadir $2 "$3" "$4" $5 $personasVacio $paisesVacio "$archivoPersonas" "$archivoPaises"
elif [ "$1" = "-e" ]; then
	Eliminar $2 $personasVacio "$archivoPersonas"
elif [ "$1" = "-p" ]; then
	Listar $2 $personasVacio $paisesVacio "$archivoPersonas" "$archivoPaises"
else
	ErrorSintaxOHelp 1
fi
