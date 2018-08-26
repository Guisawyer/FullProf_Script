					###############################################
					##                                           ##
					##  Preparando o PCR para o Método Rietveld  ##
					##                                           ## 
					###############################################

LeBail=0 # Modo LeBail Desligado - Metodo Rietvel Ligado!!
# Alterando a forma de saida:
	linhaIpr
	LinhaIpr=$(echo "$ColIpr1 $ColIpr2 0 0 2 $ColIpr6 $ColIpr7 $ColIpr8 $ColIpr9 5 $ColIpr11 2 1 1 4 1 $ColIpr17")
	sed -i "$LOCIpr s/.*/$LinhaIpr/" $(echo $ArqNome).pcr
	linhaIpr
# Prf: ColIpr10 --> 5 - Saida gera dois arquivos  .pl1 e .pl2 para gerar os gráficos no GNUplot. Padrão = 1 - Para gerar o .prf
# Rpa: ColIpr12 --> 2 - Gera um arquivo CODFIL.sav onde contem colunas para : h , k , l , mult , Iobs , 2θ , d_hkl
# Rpa: ColIpr12 --> -1 - Gera um arquivo CODFIL.cif
# Sym: ColIpr13 --> 1 - Prepares CODFIL.sym
# HKL: ColIpr14 --> 3 - h , k , l , mult , Freal , Fimag , 2θ , Intensity
# Fou: ColIpr15 --> 4 - h , k , l , Fobs , Fcalc , Phase
# Sho: ColIpr16 --> 1 - Imprime somente dados do Ultimo Ciclo!! 

# Número de Ciclos , R_at  R_an  R_pr  R_gl (Passos Atomicos, Anisotrópico, Profile e Global)
	linhaNCY
	LinhaNCY=$(echo "100 $ColNCY2 1.00 1.00 1.00 1.00 $ColNCY7 $ColNCY8 $ColNCY9 $ColNCY10 $ColNCY11")
	sed -i "$LOCNCY s/.*/$LinhaNCY/" $(echo $ArqNome).pcr
	linhaNCY 
# NCY  = 100  - Número de Ciclos
# R_at = 1.00 - Passo dos parâmetros Atômicos
# R_an = 1.00 - Passo dos parâmetros Anisotrópicos
# R_pr = 1.00 - Passo dos parâmetros do Perfil
# R_gl = 1.00 - Passo dos parâmetros Globais

# Descobrindo os valores da linha # !Job Npr Nph Nba Nex Nsc Nor Dum Iwg Ilo Ias Res Ste Nre Cry Uni Cor Opt Aut - Para descobrir a quantidade de Fases 
	linhaJob 
	LinhaJob=$(echo $ColJob1 $ColJob2 $ColJob3 $ColJob4 $ColJob5 $ColJob6 $ColJob7 1 $ColJob9 $ColJob10 1 $ColJob12 $ColJob13 $ColJob14 $ColJob15 $ColJob16 $ColJob17 1 1 )
	sed -i "$LOCJob s/.*/$LinhaJob/" $(echo $ArqNome).pcr
	linhaJob
# Aut = 1 - Liberdade para mudar os parâmetros!!
	
# Verificando qual função usada e fazendo as possiveis alterações no PCR a depender da função usada!
# Npr != (Diferente) de 7  -- Não Refina os Parâmetros X e Y
# Npr == 7 -- Não Refina o Parâmetro Shape
	fase=1
	while [ $fase -le $ColJob3 ] ; do
		if [ $ColJob2 != 7 ] ; then
			linhaUVW
			LINHA_Val=$(echo $CalVal1 $CalVal2 $CalVal3 0.000 0.000 $CalVal6 $CalVal7 $CalVal8 )
			sed -i "$LOC_Val s/.*/$LINHA_Val/" $(echo $ArqNome).pcr
		else
			linhaSCALE
			LINHA_Val=$(echo $CalVal1 0.000 $CalVal3 $CalVal4 $CalVal5 $CalVal6 $CalVal7 )
			sed -i "$LOC_Val s/.*/$LINHA_Val/" $(echo $ArqNome).pcr
		fi
		fase=$((fase +1))
	done
	fase=1

# - Zerando o ATZ - Peso Percentual de cada fase
	while [ $fase -le $ColJob3 ] ; do
		linhaNat
		LinhaNat=$(echo $ColNat1 $ColNat2 $ColNat3 $ColNat4 $ColNat5 $ColNat6 $ColNat7 $ColNat8 $ColNat9 $ColNat10 $ColNat11 0.0 $ColNat13 $ColNat14 $ColNat15 )
		sed -i "$LOCNat s/.*/$LinhaNat/" $(echo $ArqNome).pcr
		fase=$((fase+1))
	done
	fase=1

	while [ $fase -le $ColJob3 ] ; do
		linhaNat
		linhaNUMATOM
		linhaATOM
		AtomNumero=1
		while [ $AtomNumero -le $ColNat1 ] ; do
			LINHA_Val=$(echo  $CalVal1 $CalVal2 $CalVal3  $CalVal4 $CalVal5 0.00000 $CalVal7 $CalVal8 $CalVal9 $CalVal10 $CalVal11 )
			sed -i "$LOC_Val s/.*/$LINHA_Val/" $(echo $ArqNome).pcr
			linhaATOM
			LOC_Parm=$((LOC_Parm + (2+ 2*BETA) ))
			LOC_Val=$((LOC_Val + (2+ 2*BETA) ))
			linhaATOM
			AtomNumero=$((AtomNumero +1))
		done
		fase=$((fase +1))
	done
	fase=1

#	while [ $fase -le $ColJob3 ] ; do
#		linhaUVW           
#		LINHA_Val=$(echo 0.006872  -0.019632   0.017920  $CalVal4 $CalVal5 $CalVal6 $CalVal7 $CalVal8 )
#		sed -i "$LOC_Val s/.*/$LINHA_Val/" $(echo $ArqNome).pcr
#		fase=$((fase +1))
#	done
#	fase=1
	Cristalito=$(grep "Resolution file for Pattern" $(echo $ArqNome).pcr)
	if [[ -z "$Cristalito" && $ColJob2 == 7 ]] ; then
		linhaJob 
		LinhaJob=$(echo $ColJob1 $ColJob2 $ColJob3 $ColJob4 $ColJob5 $ColJob6 $ColJob7 1 $ColJob9 $ColJob10 1 1 $ColJob13 $ColJob14 $ColJob15 $ColJob16 $ColJob17 1 1 )
		sed -i "$LOCJob s/.*/$LinhaJob/" $(echo $ArqNome).pcr
		linhaJob
		sed -i '7i \!  Resolution file for Pattern#   1' $(echo $ArqNome).pcr
		sed -i '8i \DRXH57.irf' $(echo $ArqNome).pcr
		cp $CaminhoScript/DRXH57.irf .
  fi
	

	Verif_Shape

# - Salvando o PCR com as alterações iniciais
	cp $(echo $ArqNome).pcr PCR-Bkp/$(echo $ArqNome)-inicial.pcr
	echo " " >> PCR-Bkp/README
	echo "O Arquivo $(echo $ArqNome)-inicial.pcr - É o .prc com as devidas alterações que o próprio Script faz, MAS sem refinar." >> PCR-Bkp/README
	echo "Somente alterando as condições iniciais se necessário." >> PCR-Bkp/README
  echo -e "\033[36;2m
  ###################
  #                 #
  # Método Rietveld #
  #                 #
  ###################\033[0m\n" 

