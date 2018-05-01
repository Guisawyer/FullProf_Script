#!/bin/bash 
 
# Criado						: 
# Ult. Atualização	:  
# Autor							:  
# Notas							:  

NPH=$(grep -n Phase $(echo $ArqNome).hkl | wc -l)

for j in $(seq 1 $NPH) ; do

	Val1=$(grep -n Phase $(echo $ArqNome).hkl | cut -f1 -d":" | sed -n ${j}p )
	k=$((j+1))
	Veck=$(echo "$k > $NPH" | bc)
  if [[ $Veck == 1 ]] ; then
		Reflection=$(wc -l $(echo $ArqNome).hkl | cut -f1 -d" ")
	else
		Val2=$(grep -n Phase $(echo $ArqNome).hkl | cut -f1 -d":" | sed -n ${k}p )
		Reflection=$((Val2 -1))
	fi
	
	#Reflection=$(sed -n "${Val1}p" $(echo $ArqNome).hkl | awk {'print $5'})
	Val1=$((Val1 + 3))
	#Reflection=$((Reflection + Val1))
	sed -n "$Val1,$Reflection p" $(echo $ArqNome).hkl > HKL_Phase${j}
  awk '{print $7,$8, $10}' HKL_Phase${j} | sort -k3 -nr | head -15 > DadosSize${j}.txt
	rm -f Size${j}.dat
	for i in $(seq 1 15); do

		Pi=$(echo "scale=10; 4*a(1)" | bc -l)
		Ang2th=$(sed -n "$i p" DadosSize${j}.txt | cut -f1 -d" ")
		Sin=$(echo "scale=5; s(($Ang2th/2.0)*2*$Pi/360.0) " | bc -l)
		Fwhw=$(sed -n "$i p" DadosSize${j}.txt | cut -f2 -d" ")
		Bo=$(echo "scale=5; $Fwhw*2*$Pi/360.0 " | bc -l)
		Bi=$(echo "scale=5; 0.148*2*$Pi/360.0 " | bc -l)
		VecBibo=$(echo "$Bo >= $Bi" | bc)
	
		if [[ $VecBibo == 1 ]] ; then 
			#BoCos=$(echo "scale=8; c(($Ang2th/2.0)*2*$Pi/360.0)*sqrt($Bo*$Bo - $Bi*$Bi) " | bc -l)
			BoCos=$(echo "scale=8; c(($Ang2th/2.0)*2*$Pi/360.0)*(sqrt(($Bo-$Bi) * sqrt(($Bo*$Bo) - ($Bi*$Bi)))) " | bc -l)
			echo $Sin $BoCos >> Size${j}.dat
		fi
	
	done
	sort -n Size${j}.dat > Size${j}.txt
	sed "s/XXXX/Size${j}/g" Size.plt > Size${j}.plt
	gnuplot Size${j}.plt &> /dev/null
done
