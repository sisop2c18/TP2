#!/bin/bash

#################################################
#			  Sistemas Operativos			 	#
#		Trabajo Práctico 2 - Ejericio 1			#
#		Nombre del Script: ejercicio1.sh		#
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

Calcular () {
if [ ! $3 -eq 5 ]; then
Calcular $2 $(expr $1 + $2) $(expr $3 + 1) else
echo $2 
fi }

if [ ! $# -eq 0 ]; then
echo "Cantidad de parametros mandados distinta de 0"
exit 1 
fi
Calcular 0 1 0
exit 1

# A) el script si no le mandas ningun parametro calcula hasta Fibonacchi de 5 de manera recursiva.

# C) '' el contenido se interpreta de forma literal ,
# "" el contenido interpreta las referencias a variables y 
# `` (acento grave) Se utilizan para indicar a bash que interprete el comando que hay entre los acentos

# D) let: nos permite trabajar fácilmente con variables numéricas en scripts.
# expr: resuelve expresiones matematicas
# test: es un comando para evaluar expresiones devolviendo 0 en el caso de que la expresión evaluada sea verdadera o un valor distinto de 0 en el caso de ser falso
# es capaz de analizar cadenas de texto, enteros y ficheros evaluando sus propiedades para analizar lo que más nos interese de estos elementos.

# E) 
# IF : 
#if "condicion"
#then
#  "comandos"
#[elif "condicion"
#then
#  "comandos"]
#[else
#  "comandos"]
#fi

# FOR :
#for i [in lista]
#do
#   echo $i
#done

# WHILE:
#while condicion
#do
#  comandos
#done

# F)
# Ejemplo While:
#NUM=0

#while [ $NUM -le 10 ]; do
#    echo "\$NUM: $NUM"
#    let NUM=$NUM+1
#done

# Ejemplo For:
#for HOST in www.google.com www.altavista.com www.yahoo.com
#do
#  echo "-----------------------"
#  echo $HOST
#  echo "-----------------------"
#done

# Ejemplo if:
#CADENA2="dos"
#CADENA3=""

#if [ $CADENA1 = $CADENA2 ]; then
#    echo "\$CADENA1 es igual a \$CADENA2"

#elif [ $CADENA1 != $CADENA2 ]; then
#    echo "\$CADENA1 no es igual a \$CADENA2"

#fi

#if [ -z $CADENA3 ]; then
#    echo "\$CADENA3 esta vacia"
#fi
