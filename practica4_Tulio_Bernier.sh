#!/bin/bash

####################################
# PRACTICA 4.- GESTION DE PAQUETES #
####################################

function statusPackage(){
	whereis $1 | grep bin/$1 | wc -l
} # Esta función chequea si el paquete está instalado o no devolviendo un código númerico. Si es igual a 0, es que no está instalado.

function processToArray(){
	RUTA_FICHERO=$1
	LISTA=$(cat $RUTA_FICHERO | while read linea ; do
		echo $linea
	done )
	echo ${LISTA[@]}
} # Esta funcion procesa todos las lineas a un array.

function processArray() {
	LISTA_PAQUETES=$(processToArray ./paquetes.txt) # Almacena el vector que contiene las lineas del fichero
	for INFO_PAQUETES in ${LISTA_PAQUETES[@]} ; do
		NOMBRE=$(echo $INFO_PAQUETES | cut -d":" -f1) # Almacena el nombre del paquete.
		ACCION=$(echo $INFO_PAQUETES | cut -d":" -f2) # Almacena la accion a realizar sobre el paquete
		case $ACCION in
			"add")
				if [[ $(statusPackage $NOMBRE) -eq 0 ]] # Si da 0, es que no existe, por lo tanto lo instala.
				then
					apt-get install $NOMBRE -y
				else # Asumiendo que da distinto de 0, muestra que está instalado.
					echo "Esta instalado el paquete $NOMBRE"
				fi
				;;
			"remove")
				if [[ $(statusPackage $NOMBRE) -eq 0 ]] # Si da 0, es que no existe, por lo tanto no hace nada.
				then
					echo "No está instalado el paquete $NOMBRE"
				else # Asumiendo que da distinto de 0, lo elimina de forma efectiva el paquete.
					apt-get purge $NOMBRE -y
				fi
				;;
			"status") # Chequea el status.
				if [[ $(statusPackage $NOMBRE) -eq 0 ]]
				then
					echo "No esta instalado el paquete $NOMBRE"
				else
					echo "Esta instalado el paquete $NOMBRE"
				fi
				;;
		esac
	done
} # Esta función procesa el array

function main(){
	if [[ $(whoami) == "root" ]] # El el usuario es root, ejecuta la programa.
	then
		processArray # Procesamiento de los paquetes.
	fi
}

main # Ejecucción del programa.
