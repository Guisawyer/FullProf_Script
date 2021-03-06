					###########################################################
					##                                                       ##
					##  Preparando o PCR para Refinar pelo Método de LeBail  ##
					##                                                       ## 
					###########################################################

LeBail=1 # Modo LeBail Ligado - Metodo Rietvel Desligado!!
	
# Alterando a forma de saida:
	linhaIpr
	LinhaIpr=$(echo "$ColIpr1 $ColIpr2 0 0 2 $ColIpr6 $ColIpr7 $ColIpr8 $ColIpr9 5 $ColIpr11 2 1 3 4 1 $ColIpr17")
	sed -i "$LOCIpr s/.*/$LinhaIpr/" $(echo $ArqNome).pcr
	linhaIpr
# Prf: ColIpr10 --> 5 - Saida gera dois arquivos  .pl1 e .pl2 para gerar os gráficos no GNUplot. Padrão = 1 - Para gerar o .prf
# Rpa: ColIpr12 --> 2 - Gera um arquivo CODFIL.sav onde contem colunas para : h , k , l , mult , Iobs , 2θ , d_hkl
# Sym: ColIpr12 --> 1 - Prepares CODFIL.sym
# HKL: ColIpr12 --> 3 - h , k , l , mult , Freal , Fimag , 2θ , Intensity
# Fou: ColIpr12 --> 4 - h , k , l , Fobs , Fcalc , Phase
# Sho: ColIpr16 --> 1 - Imprime somente dados do Ultimo Ciclo!! 

# Número de Ciclos , R_at  R_an  R_pr  R_gl (Passos Atomicos, Anisotrópico, Profile e Global)
	linhaNCY
	LinhaNCY=$(echo "200 $ColNCY2 1.00 1.00 1.00 1.00 $ColNCY7 $ColNCY8 $ColNCY9 $ColNCY10 $ColNCY11")
	sed -i "$LOCNCY s/.*/$LinhaNCY/" $(echo $ArqNome).pcr
	linhaNCY 
# NCY  = 100  - Número de Ciclos
# R_at = 1.00 - Passo dos parâmetros Atômicos
# R_an = 1.00 - Passo dos parâmetros Anisotrópicos
# R_pr = 1.00 - Passo dos parâmetros do Perfil
# R_gl = 1.00 - Passo dos parâmetros Globais

# Descobrindo os valores da linha # !Job Npr Nph Nba Nex Nsc Nor Dum Iwg Ilo Ias Res Ste Nre Cry Uni Cor Opt Aut - Para descobrir a quantidade de Fases 
	linhaJob 
	LinhaJob=$(echo $ColJob1 $ColJob2 $ColJob3 $ColJob4 $ColJob5 $ColJob6 $ColJob7 1 $ColJob9 $ColJob10 1 $ColJob12 $ColJob13 $ColJob14 $ColJob15 $ColJob16 $ColJob17 $ColJob18 1 )
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
	
	linhaZERO
	LINHA_Val=$(echo 0.06350 $CalVal2 $CalVal3 $CalVal4 $CalVal5 $CalVal6 $CalVal7 $CalVal8 $CalVal9 )
	sed -i "$LOC_Val s/.*/$LINHA_Val/" $(echo $ArqNome).pcr

	
	while [ $fase -le $ColJob3 ] ; do
		linhaUVW
		LINHA_Val=$(echo  0.031063  -0.041520   0.033182  $CalVal4 $CalVal5 $CalVal6 $CalVal7 $CalVal8 )
		sed -i "$LOC_Val s/.*/$LINHA_Val/" $(echo $ArqNome).pcr
		fase=$((fase +1))
	done
	fase=1
	
	while [ $fase -le $ColJob3 ] ; do
		linhaSCALE
		LINHA_Val=$(echo 0.00001 $CalVal2 0.0000 $CalVal4 $CalVal5 $CalVal6 $CalVal7 )
		sed -i "$LOC_Val s/.*/$LINHA_Val/" $(echo $ArqNome).pcr
		LINHA_Parm=$(echo 0.000 $CalParam2 $CalParam3 $CalParam4 $CalParam5 $CalParam6)
		sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
		fase=$((fase+1))
	done
	fase=1

# - Zerando o ATZ - Peso Percentual de cada fase
	while [ $fase -le $ColJob3 ] ; do
		linhaNat
		LinhaNat=$(echo 0 $ColNat2 $ColNat3 $ColNat4 $ColNat5 $ColNat6 2 $ColNat8 $ColNat9 $ColNat10 $ColNat11 0.0 $ColNat13 $ColNat14 $ColNat15 )
		sed -i "$LOCNat s/.*/$LinhaNat/" $(echo $ArqNome).pcr
		fase=$((fase+1))
	done
	fase=1


# - Comentando as linhas dos Atomos
	while [ $fase -le $ColJob3 ] ; do
		linhaNUMATOM
		sed -i "${LOC_Val_ATOM},${LOC_Val_ATOM2}s/^/\!/g" $(echo $ArqNome).pcr
		fase=$((fase+1))
	done
	fase=1

	Verif_Shape

# - Salvando o PCR com as alterações iniciais
	cp $(echo $ArqNome).pcr PCR-Bkp/$(echo $ArqNome)-LeBail.pcr
	echo " " >> PCR-Bkp/README
	echo "O Arquivo $(echo $ArqNome)-LeBail.pcr - É o .prc com as devidas alterações que o próprio Script faz, MAS sem refinar." >> PCR-Bkp/README
	echo "Somente alterando as condições iniciais para fazer o Refinamento pelo Método de LeBail." >> PCR-Bkp/README
  echo -e "\033[36;2m
  #################
  #               #
  # Método LeBail #
  #               #
  #################\033[0m\n" 

