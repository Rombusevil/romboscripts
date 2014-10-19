#!/bin/bash
# Script para renombrar fotos con timestamp tomadas por celulares Android.
# From IMG_20141018_102601.jpg  to  2014-10-18 10.26.01.jpg

RENAME=false;	# Modo debug
#RENAME=true;	# Modo renombrar
somethingToDelete=false;
cant=0;

for a in *.jpg; do 
	# Si el nombre empieza con IMG hay que renombrar
	if [ "${a:0:3}" == "IMG" ]; then
		somethingToDelete=true;
		cant=$((cant+1)); # Al final muestro cuantos archivos se renombraron

		if [ $RENAME == true ]; then
			# Efectúo el comando
			echo "${a:4:4}-${a:8:2}-${a:10:2} ${a:13:2}.${a:15:2}.${a:17:2}.jpg" | xargs -i mv $a {}; 
		else
			# Imprimo el comando para debug
			echo "${a:4:4}-${a:8:2}-${a:10:2} ${a:13:2}.${a:15:2}.${a:17:2}.jpg" | xargs -i echo moves $a to {}; 
		fi
	fi
done



if [ $somethingToDelete == false ]; then 
	echo "No tengo nada para renombrar.";
elif [ $RENAME == false ]; then
	echo "$cant archivos califican para renombrar";
	echo "Script modo debug. Para efectuar los cambios correrlo en modo RENAME.";
else
	echo "$cant archivos renombrados.";
fi

