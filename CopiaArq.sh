##########################################
#### Copia Segura dos Arquivos gerados  ##
##########################################

function cpOK(){
cp $(echo $ArqNome).fou $(echo $ArqNome)-OK.fou &> /dev/null
cp $(echo $ArqNome).hkl $(echo $ArqNome)-OK.hkl &> /dev/null
cp $(echo $ArqNome).inp $(echo $ArqNome)-OK.inp &> /dev/null
cp $(echo $ArqNome).out $(echo $ArqNome)-OK.out &> /dev/null   
cp $(echo $ArqNome).pcr $(echo $ArqNome)-OK.pcr &> /dev/null 
cp $(echo $ArqNome).pl1 $(echo $ArqNome)-OK.pl1  &> /dev/null
cp $(echo $ArqNome).pl2 $(echo $ArqNome)-OK.pl2  &> /dev/null
cp $(echo $ArqNome).rpa $(echo $ArqNome)-OK.rpa  &> /dev/null
cp $(echo $ArqNome).sav $(echo $ArqNome)-OK.sav &> /dev/null
cp $(echo $ArqNome).sum $(echo $ArqNome)-OK.sum  &> /dev/null
cp $(echo $ArqNome).sym $(echo $ArqNome)-OK.sym  &> /dev/null

cp_k=$(ls $ArqNome?.hkl 2> /dev/null | wc -l) 
cp_k=1
	while [ $cp_k -le $(ls $ArqNome?.hkl 2> /dev/null | wc -l) ]; do
			cp $(ls $ArqNome?.hkl | sed -n "$cp_k p") $(echo $ArqNome)$cp_k-OK.hkl &> /dev/null
	
		cp_k=$((cp_k+1))
	done
cp_k=$(ls $ArqNome?.fst 2> /dev/null | wc -l)  
cp_k=1
	while [ $cp_k -le $(ls $ArqNome?.fst 2> /dev/null | wc -l) ]; do
			cp $(ls $ArqNome?.fst | sed -n "$cp_k p") $(echo $ArqNome)$cp_k-OK.fst &> /dev/null
		
		cp_k=$((cp_k+1))
	done

cp_k=$(ls $ArqNome?.atm 2> /dev/null | wc -l)  
cp_k=1
	while [ $cp_k -le $(ls $ArqNome?.atm 2> /dev/null | wc -l) ]; do
			cp $(ls $ArqNome?.atm | sed -n "$cp_k p") $(echo $ArqNome)$cp_k-OK.atm &> /dev/null
		
		cp_k=$((cp_k+1))
	done

cp_k=$(ls $ArqNome?.mcif 2> /dev/null | wc -l) 
cp_k=1 
	while [ $cp_k -le $(ls $ArqNome?.mcif 2> /dev/null | wc -l) ]; do
			cp $(ls $ArqNome?.mcif | sed -n "$cp_k p") $(echo $ArqNome)$cp_k-OK.mcif &> /dev/null
		
		cp_k=$((cp_k+1))
	done


#fi
}

function recuperecpOK(){
cp $(echo $ArqNome)-OK.fou $(echo $ArqNome).fou
cp $(echo $ArqNome)-OK.hkl $(echo $ArqNome).hkl
cp $(echo $ArqNome)-OK.inp $(echo $ArqNome).inp
cp $(echo $ArqNome)-OK.out $(echo $ArqNome).out   
cp $(echo $ArqNome)-OK.pcr $(echo $ArqNome).pcr 
cp $(echo $ArqNome)-OK.pl1 $(echo $ArqNome).pl1 
cp $(echo $ArqNome)-OK.pl2 $(echo $ArqNome).pl2 
cp $(echo $ArqNome)-OK.rpa $(echo $ArqNome).rpa 
cp $(echo $ArqNome)-OK.sav $(echo $ArqNome).sav
cp $(echo $ArqNome)-OK.sum $(echo $ArqNome).sum 
cp $(echo $ArqNome)-OK.sym $(echo $ArqNome).sym 
#cp_k=1
#if [[ $LeBail == 0 ]]; then
#	while [ $cp_k -le $(ls $ArqNome?.fst | wc -l) ]; do
#		cp $(echo $ArqNome)$cp_k-OK.fst $(echo $ArqNome)$cp_k.fst
#		if [[ $ColJob12 == 1 ]]; then
#			cp $(echo $ArqNome)$cp_k-OK.mic $(echo $ArqNome)$cp_k.mic
#		fi
#		cp_k=$((cp_k+1))
#	done
#else
#	while [ $cp_k -le $(ls $ArqNome?.hkl | wc -l) ]; do
#		cp $(echo $ArqNome)$cp_k-OK.hkl $(echo $ArqNome)$cp_k.hkl
#		cp_k=$((cp_k+1))
#	done
#fi

cp_k=$(ls $ArqNome?.hkl 2> /dev/null | wc -l)    
cp_k=1
	while [ $cp_k -le $(ls $ArqNome?.hkl 2> /dev/null | wc -l) ]; do
			cp $(ls $ArqNome?-OK.hkl | sed -n "$cp_k p") $(echo $ArqNome)$cp_k.hkl &> /dev/null
	
		cp_k=$((cp_k+1))
	done
cp_k=$(ls $ArqNome?.fst 2> /dev/null | wc -l)  
cp_k=1
	while [ $cp_k -le $(ls $ArqNome?.fst 2> /dev/null | wc -l) ]; do
			cp $(ls $ArqNome?-OK.fst | sed -n "$cp_k p") $(echo $ArqNome)$cp_k.fst &> /dev/null
		
		cp_k=$((cp_k+1))
	done

cp_k=$(ls $ArqNome?.atm 2> /dev/null | wc -l) 
cp_k=1
	while [ $cp_k -le $(ls $ArqNome?.atm 2> /dev/null | wc -l) ]; do
			cp $(ls $ArqNome?-OK.atm | sed -n "$cp_k p") $(echo $ArqNome)$cp_k.atm &> /dev/null
		
		cp_k=$((cp_k+1))
	done

cp_k=$(ls $ArqNome?.mcif 2> /dev/null | wc -l)  
cp_k=1
	while [ $cp_k -le $(ls $ArqNome?.mcif 2> /dev/null | wc -l) ]; do
			cp $(ls $ArqNome?-OK.mcif | sed -n "$cp_k p") $(echo $ArqNome)$cp_k.mcif &> /dev/null
		
		cp_k=$((cp_k+1))
	done
}


function cpCOND(){
cp $(echo $ArqNome).fou $(echo $ArqNome)-COND-$i.fou
cp $(echo $ArqNome).hkl $(echo $ArqNome)-COND-$i.hkl
cp $(echo $ArqNome).inp $(echo $ArqNome)-COND-$i.inp
cp $(echo $ArqNome).out $(echo $ArqNome)-COND-$i.out   
cp $(echo $ArqNome).pcr $(echo $ArqNome)-COND-$i.pcr 
cp $(echo $ArqNome).pl1 $(echo $ArqNome)-COND-$i.pl1 
cp $(echo $ArqNome).pl2 $(echo $ArqNome)-COND-$i.pl2 
cp $(echo $ArqNome).rpa $(echo $ArqNome)-COND-$i.rpa 
cp $(echo $ArqNome).sav $(echo $ArqNome)-COND-$i.sav
cp $(echo $ArqNome).sum $(echo $ArqNome)-COND-$i.sum 
cp $(echo $ArqNome).sym $(echo $ArqNome)-COND-$i.sym 
#cp_k=1
#if [[ $LeBail == 0 ]]; then
#	while [ $cp_k -le $(ls $ArqNome?.fst | wc -l) ]; do
#		cp $(echo $ArqNome)$cp_k.fst $(echo $ArqNome)$cp_k-COND-$i.fst
#		if [[ $ColJob12 == 1 ]]; then
#			cp $(echo $ArqNome)$cp_k.mic $(echo $ArqNome)$cp_k-COND-$i.mic
#		fi
#		cp_k=$((cp_k+1))
#	done
#else
#	while [ $cp_k -le $(ls $ArqNome?.hkl | wc -l) ]; do
#		cp $(echo $ArqNome)$cp_k.hkl $(echo $ArqNome)$cp_k-COND-$i.hkl
#		cp_k=$((cp_k+1))
#	done
#fi

cp_k=$(ls $ArqNome?.hkl 2> /dev/null | wc -l) 
cp_k=1
	while [ $cp_k -le $(ls $ArqNome?.hkl 2> /dev/null | wc -l) ]; do
			cp $(ls $ArqNome?.hkl | sed -n "$cp_k p") $(echo $ArqNome)$cp_k-COND-$i.hkl &> /dev/null
	
		cp_k=$((cp_k+1))
	done
cp_k=$(ls $ArqNome?.fst 2> /dev/null | wc -l)  
cp_k=1
	while [ $cp_k -le $(ls $ArqNome?.fst 2> /dev/null | wc -l) ]; do
			cp $(ls $ArqNome?.fst | sed -n "$cp_k p") $(echo $ArqNome)$cp_k-COND-$i.fst &> /dev/null
		
		cp_k=$((cp_k+1))
	done

cp_k=$(ls $ArqNome?.atm 2> /dev/null | wc -l)  
cp_k=1
	while [ $cp_k -le $(ls $ArqNome?.atm  2> /dev/null | wc -l) ]; do
			cp $(ls $ArqNome?.atm | sed -n "$cp_k p") $(echo $ArqNome)$cp_k-COND-$i.atm &> /dev/null
		
		cp_k=$((cp_k+1))
	done

cp_k=$(ls $ArqNome?.mcif 2> /dev/null | wc -l)  
cp_k=1
	while [ $cp_k -le $(ls $ArqNome?.mcif 2> /dev/null | wc -l) ]; do
			cp $(ls $ArqNome?.mcif | sed -n "$cp_k p") $(echo $ArqNome)$cp_k-COND-$i.mcif &> /dev/null
		
		cp_k=$((cp_k+1))
	done
}

function recuperecpCOND(){
cp $(echo $ArqNome)-COND-$i.fou $(echo $ArqNome).fou
cp $(echo $ArqNome)-COND-$i.hkl $(echo $ArqNome).hkl
cp $(echo $ArqNome)-COND-$i.inp $(echo $ArqNome).inp
cp $(echo $ArqNome)-COND-$i.out $(echo $ArqNome).out   
cp $(echo $ArqNome)-COND-$i.pcr $(echo $ArqNome).pcr 
cp $(echo $ArqNome)-COND-$i.pl1 $(echo $ArqNome).pl1 
cp $(echo $ArqNome)-COND-$i.pl2 $(echo $ArqNome).pl2 
cp $(echo $ArqNome)-COND-$i.rpa $(echo $ArqNome).rpa 
cp $(echo $ArqNome)-COND-$i.sav $(echo $ArqNome).sav
cp $(echo $ArqNome)-COND-$i.sum $(echo $ArqNome).sum 
cp $(echo $ArqNome)-COND-$i.sym $(echo $ArqNome).sym 
#cp_k=1
#if [[ $LeBail == 0 ]]; then
#	while [ $cp_k -le $(ls $ArqNome?.fst | wc -l) ]; do
#		cp $(echo $ArqNome)$cp_k-COND-$i.fst $(echo $ArqNome)$cp_k.fst
#		if [[ $ColJob12 == 1 ]]; then
#			cp $(echo $ArqNome)$cp_k-COND-$i.mic $(echo $ArqNome)$cp_k.mic
#		fi
#		cp_k=$((cp_k+1))
#	done
#else
#	while [ $cp_k -le $(ls $ArqNome?.hkl | wc -l) ]; do
#		cp $(echo $ArqNome)$cp_k-COND-$i.hkl $(echo $ArqNome)$cp_k.hkl
#		cp_k=$((cp_k+1))
#	done
#fi
cp_k=$(ls $ArqNome?.hkl 2> /dev/null | wc -l)  
cp_k=1
	while [ $cp_k -le $(ls $ArqNome?.hkl 2> /dev/null | wc -l) ]; do
			cp $(ls $ArqNome?-COND-$i.hkl | sed -n "$cp_k p") $(echo $ArqNome)$cp_k.hkl &> /dev/null
	
		cp_k=$((cp_k+1))
	done
cp_k=$(ls $ArqNome?.fst 2> /dev/null| wc -l)  
cp_k=1
	while [ $cp_k -le $(ls $ArqNome?.fst 2> /dev/null | wc -l) ]; do
			cp $(ls $ArqNome?-COND-$i.fst | sed -n "$cp_k p") $(echo $ArqNome)$cp_k.fst &> /dev/null
		
		cp_k=$((cp_k+1))
	done

cp_k=$(ls $ArqNome?.atm 2> /dev/null | wc -l)  
cp_k=1
	while [ $cp_k -le $(ls $ArqNome?.atm 2> /dev/null | wc -l) ]; do
			cp $(ls $ArqNome?-COND-$i.atm | sed -n "$cp_k p") $(echo $ArqNome)$cp_k.atm &> /dev/null
		
		cp_k=$((cp_k+1))
	done

cp_k=$(ls $ArqNome?.mcif 2> /dev/null | wc -l)  
cp_k=1
	while [ $cp_k -le $(ls $ArqNome?.mcif 2> /dev/null | wc -l) ]; do
			cp $(ls $ArqNome?-COND-$i.mcif | sed -n "$cp_k p") $(echo $ArqNome)$cp_k.mcif &> /dev/null
		
		cp_k=$((cp_k+1))
	done
}
