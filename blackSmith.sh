#!/bin/bash  
# Este script se mete en la estructura de directorios y convención de nombres
# de un kit Analogue Drums (BlackSmith) y categoriza los samples según mic, round robin e intensidad.


# Cambiar por el código de drumkit
drumkit="AD35" 
drumkitName="BlackSmith"
rrq=6 # Cantidad de round robins, depende del kit

# Identificar los platos que no tienen closemic, en blacksmith solo el ride tiene close mic, los demás no
cymbals=(China-EG Crash1-BL Crash1-CH Crash1-EG Crash2-BL Crash2-CH Crash2-EG FXCrash-BL FXCrash-EG Hihat-EC Hihat-EL Hihat-EO Hihat-ES Hihat-ET Hihat-FS Hihat-PD Hihat-TC Hihat-TL Hihat-TO Hihat-TS Hihat-TT Splash-EG Stack-EG)

r="RR" # Round robin, este valor es una constante
s="Samples" # Constante del directorio de samples

dir=$drumkitName"/"$s # Este es el path en el cual hay que correr el script


# Estoy en el directorio SAMPLES
if [ `pwd | rev | cut -d'/' -f 1,2 | rev` = $dir ]; then 
	for directorio in `ls -1|sort`; do  # Por cada cuerpo de batería
		# Me aseguro de que es un directorio, sino lo omito
		if [ -d $directorio ]; then
			cd $directorio
		else
			continue
		fi
		
		#-----------------------------------------#

		sound=`echo $directorio | cut -d'-' -f 1` # Guardo el nombre del instrumento

		# Creo los dirs para los distintos tipos de microfoneo
		mkdir closemic overheadmic roommic smashmic 
		
		# Si es snare tenés el microfoneo snarebottom, si es kick tenes el submic
		layerList=(CM OH RM SM) 
		if [[ $directorio == "Snare"* ]]; then
			mkdir snarebottom
			layerList[${#layerList[*]}]=SB
		fi

		if [[ $directorio == "Kick"* ]]; then
			mkdir kicksubmic
			layerList[${#layerList[*]}]=KS
		fi
		#-----------------------------------------#


		# Sample file AD35_KickLCMRR1_106_127_CN.wav
		pre_file=$drumkit"_"$sound # AD35_KickL

		# Muevo los samples a directorios según layer
		for layer in ${layerList[*]}; do

			# Averiguo si el cuerpo es un hihat, pq si es asi tengo que agregarle un codigo antes del round robin
			if [ $sound == "Hihat" ]; then
				file="$pre_file$layer*$r"
			else
				file="$pre_file$layer$r"
			fi

			case $layer in
				CM) outdir=closemic		
					;;
				OH) outdir=overheadmic
					;;
				RM) outdir=roommic
					;;
				SM) outdir=smashmic
					;;
				SB) outdir=snarebottom
					;;
				KS) outdir=kicksubmic
					;;
			esac

			# Muevo los archivos a su categoria por layer
			# Si no hay nada que mover, paso al siguiente layer
			if ! mv $file* $outdir;	then
				continue
			fi
			

			#-----------------------------------------#

			# voy adentro de cada layer y categorizo los archivos por round robin
			cd $outdir

			for i in $(seq 1 $rrq) # Por cada round robin que haya lo muevo a su respectiva carpeta
			do
				mkdir $i
				mv $file$i* $i
			done 
			
			#-----------------------------------------#

			# Me vuelvo al dir anterior, tengo que procesar otro layer
			cd ..
		done

		# Vuelvo al dir anterior, ya terminé con este cuerpo
		cd ..

		if [[ `pwd` != *"$s"*  ]]; then
			echo Me fui a cualquier lado... supongo que ya terminé
			exit 1;
		fi
	done
else
	echo "Necesito estar en el dir de Analogue drums/Samples";
fi

# Limpio el directorio de closemic para los platos que no tienen ese microfoneo
for i in ${cymbals[*]}; do
	rm -rf $i/closemic; 
done
