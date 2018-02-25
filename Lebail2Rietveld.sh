				#########################################################################
				##                                                        						 ##
				##  Apos Refinar pelo Método LeBail, Mudar PCR para o Método Rietveld  ##
				##                                                        		         ## 
				#########################################################################
				
cp PCR-Bkp/$ArqNome.pcr $ArqNome-bk.pcr
cp $ArqNome.pcr PCR-Bkp/$ArqNome-bk-Lebail.pcr

function linhaSCALE2 (){
	#!  Scale        Shape1      Bov      Str1      Str2      Str3   Strain-Model
	LOC_Le=$(grep -n "!  Scale" $(echo $ArqNome-bk).pcr | cut -f1 -d":" | sed -n ${fase}p )
	LOC_Val_SCALE_Le=$((LOC_Le + 1))
	LINHA_Val_SCALE_Le=$(sed -n ${LOC_Val_SCALE_Le}p $(echo $ArqNome-bk).pcr)
	CalSCALE1_Le=$(echo $LINHA_Val_SCALE_Le | cut -f1 -d" ") # Scale
}

function linhaUVW2 (){
	#!       U         V          W           X          Y        GauSiz   LorSiz Size-Model
	LOC_Le=$(grep -n "!       U " $(echo $ArqNome-bk).pcr | cut -f1 -d":" | sed -n ${fase}p )
	LOC_Val_UVW_Le=$((LOC_Le + 1))
	LINHA_Val_UVW_Le=$(sed -n ${LOC_Val_UVW_Le}p $(echo $ArqNome-bk).pcr)
}


function linhaABC2 () {
	#!     a          b         c        alpha      beta       gamma      #Cell Info
	LOC_Le=$(grep -n "!     a " $(echo $ArqNome-bk).pcr | cut -f1 -d":" | sed -n ${fase}p )
	LOC_Val_ABC_Le=$((LOC_Le + 1))
	Linha_Val_ABC_Le=$(sed -n ${LOC_Val_ABC_Le}p $(echo $ArqNome-bk).pcr)
}

function linhaZERO1 () {
	#!  Zero    Code    SyCos    Code   SySin    Code  Lambda     Code MORE ->Patt# 1
	LOC_Le=$(grep -n "!  Zero" $(echo $ArqNome-bk).pcr | cut -f1 -d":")
	LOCZERO_Le=$((LOC_Le + 1))

	Linha_Zero_Le=$(sed -n ${LOCZERO_Le}p $(echo $ArqNome-bk).pcr)
}

linhaZERO
linhaZERO1
Linha_Zero_Le=$(echo $ColZERO1 0.000 $ColZERO3 $ColZERO4 $ColZERO5 $ColZERO6 $ColZERO7 $ColZERO8 $ColZERO9 )
sed -i "$LOCZERO_Le s/.*/$Linha_Zero_Le/" $(echo $ArqNome-bk).pcr

fase=1
while [ $fase -le $ColJob3 ] ; do
	linhaSCALE
	linhaSCALE2
	LINHA_Val_SCALE_Le=$(echo $CalSCALE1_Le $CalSCALE2 $CalSCALE3 $CalSCALE4 $CalSCALE5 $CalSCALE6 $CalSCALE7)
	sed -i "$LOC_Val_SCALE_Le s/.*/$LINHA_Val_SCALE_Le/" $(echo $ArqNome-bk).pcr
	fase=$((fase +1))
done

fase=1
while [ $fase -le $ColJob3 ] ; do
	linhaABC
	linhaABC2
	Linha_Val_ABC_Le=$(echo $ColABC1 $ColABC2 $ColABC3 $ColABC4 $ColABC5 $ColABC6)
	sed -i "$LOC_Val_ABC_Le s/.*/$Linha_Val_ABC_Le/" $(echo $ArqNome-bk).pcr
	fase=$((fase +1))
done

fase=1
while [ $fase -le $ColJob3 ] ; do
	linhaUVW
	linhaUVW2
	LINHA_Val_UVW_Le=$(echo $CalUVW1 $CalUVW2 $CalUVW3 $CalUVW4 $CalUVW5 $CalUVW6 $CalUVW7 $CalUVW8)
	sed -i "$LOC_Val_UVW_Le s/.*/$LINHA_Val_UVW_Le/" $(echo $ArqNome-bk).pcr
	fase=$((fase +1))
done

cp $ArqNome-bk.pcr $ArqNome.pcr
cp $ArqNome.png $ArqNome-LeBail.png

rm -f !($ArqNome.dat|$ArqNome.pcr|$ArqNome-LeBail.png|Refinamento.plt) &> /dev/null

RUN=0 
Erro_Vec=0

