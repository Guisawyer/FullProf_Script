##########################################
#### Copia Segura dos Arquivos gerados  ##
##########################################

function cpOK(){
cp $(echo $ArqNome).fou $(echo $ArqNome)-OK.fou
cp $(echo $ArqNome).hkl $(echo $ArqNome)-OK.hkl
cp $(echo $ArqNome).inp $(echo $ArqNome)-OK.inp
cp $(echo $ArqNome).out $(echo $ArqNome)-OK.out   
cp $(echo $ArqNome).pcr $(echo $ArqNome)-OK.pcr 
cp $(echo $ArqNome).pl1 $(echo $ArqNome)-OK.pl1 
cp $(echo $ArqNome).pl2 $(echo $ArqNome)-OK.pl2 
cp $(echo $ArqNome).rpa $(echo $ArqNome)-OK.rpa 
cp $(echo $ArqNome).sav $(echo $ArqNome)-OK.sav
cp $(echo $ArqNome).sum $(echo $ArqNome)-OK.sum 
cp $(echo $ArqNome).sym $(echo $ArqNome)-OK.sym 
cp_k=1
if [[ $LeBail == 0 ]]; then
	while [ $cp_k -le $(ls $ArqNome?.fst | wc -l) ]; do
		cp $(echo $ArqNome)$cp_k.fst $(echo $ArqNome)$cp_k-OK.fst
		if [[ $ColJob12 == 1 ]]; then
			cp $(echo $ArqNome)$cp_k.mic $(echo $ArqNome)$cp_k-OK.mic
		fi
		cp_k=$((cp_k+1))
	done
else
	while [ $cp_k -le $(ls $ArqNome?.hkl | wc -l) ]; do
		cp $(echo $ArqNome)$cp_k.hkl $(echo $ArqNome)$cp_k-OK.hkl
		cp_k=$((cp_k+1))
	done
fi
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
cp_k=1
if [[ $LeBail == 0 ]]; then
	while [ $cp_k -le $(ls $ArqNome?.fst | wc -l) ]; do
		cp $(echo $ArqNome)$cp_k-OK.fst $(echo $ArqNome)$cp_k.fst
		if [[ $ColJob12 == 1 ]]; then
			cp $(echo $ArqNome)$cp_k-OK.mic $(echo $ArqNome)$cp_k.mic
		fi
		cp_k=$((cp_k+1))
	done
else
	while [ $cp_k -le $(ls $ArqNome?.hkl | wc -l) ]; do
		cp $(echo $ArqNome)$cp_k-OK.hkl $(echo $ArqNome)$cp_k.hkl
		cp_k=$((cp_k+1))
	done
fi
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
cp_k=1
if [[ $LeBail == 0 ]]; then
	while [ $cp_k -le $(ls $ArqNome?.fst | wc -l) ]; do
		cp $(echo $ArqNome)$cp_k.fst $(echo $ArqNome)$cp_k-COND-$i.fst
		if [[ $ColJob12 == 1 ]]; then
			cp $(echo $ArqNome)$cp_k.mic $(echo $ArqNome)$cp_k-COND-$i.mic
		fi
		cp_k=$((cp_k+1))
	done
else
	while [ $cp_k -le $(ls $ArqNome?.hkl | wc -l) ]; do
		cp $(echo $ArqNome)$cp_k.hkl $(echo $ArqNome)$cp_k-COND-$i.hkl
		cp_k=$((cp_k+1))
	done
fi
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
cp_k=1
if [[ $LeBail == 0 ]]; then
	while [ $cp_k -le $(ls $ArqNome?.fst | wc -l) ]; do
		cp $(echo $ArqNome)$cp_k-COND-$i.fst $(echo $ArqNome)$cp_k.fst
		if [[ $ColJob12 == 1 ]]; then
			cp $(echo $ArqNome)$cp_k-COND-$i.mic $(echo $ArqNome)$cp_k.mic
		fi
		cp_k=$((cp_k+1))
	done
else
	while [ $cp_k -le $(ls $ArqNome?.hkl | wc -l) ]; do
		cp $(echo $ArqNome)$cp_k-COND-$i.hkl $(echo $ArqNome)$cp_k.hkl
		cp_k=$((cp_k+1))
	done
fi
}
