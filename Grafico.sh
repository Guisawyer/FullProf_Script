		###############
		##	         ##		
		##  Gráfico  ##
		##           ##
		###############

	RGB=(000000 6b851e 147ae1 bae147 7ae14 599999 91eb85 7851eb 9c28f5 451eb8 6e147a dc28f5)
	fase_temp=$fase
	YMAXOBS=$(sort -g -k 2 $ArqNome.pl1 | gawk '{print $2}' | tail -1)
	YMAXCAL=$(sort -g -k 3 $ArqNome.pl1 | gawk '{print $3}' | tail -1)
	if [[ $(echo "$YMAXOBS > $YMAXCAL" | bc -l) -eq 1 ]]; then
		YMAX=$YMAXOBS
	else
		YMAX=$YMAXCAL
	fi
	YINCREM=$(echo "scale=2; $YMAX *0.04" | bc)
	YMAXRANGE=$(echo "scale=2; $YMAX + $YINCREM" | bc)
	YMINRANGE=$(echo "scale=2; $(sort -g -k 4 $ArqNome.pl1 | gawk '{print $4}' | head -1) - $YINCREM  " | bc)
	Yerro=$(echo "scale=2; $(sort -g -k 4 $ArqNome.pl1 | gawk '{print $4}' | tail -1)" | bc)
	Ypeak=$(sed '/^$/d' $ArqNome.pl2 | sort -g -k 2 | sed -n 2p | gawk '{print $2}')
	YERROINCR=$(echo "scale=2; 2*$Ypeak - $Yerro - 2*$YINCREM" | bc )
	YMINRANGE=$(echo "scale=2; $YMINRANGE + $YERROINCR " | bc)
 	echo " plot '$ArqNome.pl1'  using 1:2 ls 1  title 'Obs' , '' using 1:3 w l ls 2  title 'Calc', '' using 1:(\$4+$YERROINCR) w l ls 3  title '(Obs - Calc)' " > graf_temp
 	echo " plot '$ArqNome.pl1'  using 1:2 ls 1  notitle, '' using 1:3 w l ls 2  notitle, '' using 1:(\$4+$YERROINCR) w l ls 3  notitle " > graf_temp_zoom
	fase=1
	while [ $fase -le $ColJob3 ] ; do
		NomeFase
		grep "$(sort -g -k2  -r -u $ArqNome.pl2 | sed -n ${fase}p | sed 's/-//' | gawk '{print $2,$3}' )" $ArqNome.pl2 > peak-$fase
		echo " , 'peak-$fase' using 1:(\$2-$YINCREM)  linetype -1 pointtype '|' tc rgb '#$(echo ${RGB[fase]})' title  '$nome_fase' " > fase-$fase
		echo " , 'peak-$fase' using 1:(\$2-$YINCREM)  linetype -1 pointtype '|' tc rgb '#$(echo ${RGB[fase]})' notitle " > faseZooM-$fase
		paste graf_temp fase-$fase > graf_temp2
		paste graf_temp_zoom faseZooM-$fase > graf_temp3
		mv graf_temp2 graf_temp
		mv graf_temp3 graf_temp_zoom
		fase=$((fase +1))
		done
	fase=1

	sed -i "s/set output.*/set output \"$(echo $ArqNome).png\"/" Refinamento.plt
	sed -i "22 s/.*/$(cat graf_temp) /" Refinamento.plt


	XTICS=$(echo "scale=2; ($XRange_Max-$XRange_Min)/2 " | bc )
	sed -i "7 s/set xrange.*/set xrange [$XRange_Min1:$XRange_Max1]/" Refinamento.plt
	sed -i "8 s/set yrange.*/set yrange [$YMINRANGE:$YMAXRANGE]/" Refinamento.plt
	sed -i "28 s/set xrange.*/set xrange [$XRange_Min:$XRange_Max]/" Refinamento.plt
	sed -i "29 s/set xtics.*/set xtics $XTICS in nomirror /" Refinamento.plt
	sed -i "34 s/.*/$(cat graf_temp_zoom) /" Refinamento.plt
	gnuplot Refinamento.plt &> /dev/null

	fase=$fase_temp


