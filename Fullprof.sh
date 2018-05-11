				#############################################################
				##                                                         ##
				##  Funções para Rodar o Fullprof e Testar a Convergência  ##
				##                                                         ## 
				#############################################################

source CopiaArq.sh
RUN=0  # Quando zero, é a primeira vez que está rodando!! Logo n tem Chi para comparar... 
passo=0 # Quando zero - Não precisa alterar o passo
conta_passo=0.9 # Contagem inicial para mudar o Passo
Vec_Shape_Val=0 # QUando zero o Shape possui valores entre (0,1)
Erro_Vec=0 # Quando zero Significa que Não está na fase de Refazer os parâmetros que derão errados!!
Verif_Biso_Val=0 # Quando zero BISO OK!! Se 1... deu negativo ou acima de 5
Biso_Mode=0 # Desligado - Somente liga quando o Biso for iniciado!
COND=0 # Quando ZERO - Não estão fazendo condições quando = 1  - Entrou na Parte de Fazer Condições - Modo de saida Diferente dos Demais
COND1=0
ERRO_PASSO=0
Passo_OK=0 # Quando Muda para 1 sig que usando o Passo deu certo e n precisa refazer tudo de novo!!!
FINALIZAR=0 # Quando ZERO desligado... ainda n entrou modo finalizar!!
Pos_Atomic_Exc=0
Shape_Mode=0
Atomo_Mode=0
OCC_MODE=0
Finalizar_VEC=0
ParamUVW=0

function MsgErro(){
	echo -e "\033[01;31m$1\033[0m" 
}

function MsgFunc(){
   echo -e "\033[04;34;47m$1\033[0m"
}

function MsgFunc1(){ 
	MsgFunc "Parâmetro \033[02;30;47m$1\033[04;34;47m da Fase $fase: $nome_fase"
}

function MsgFunc2(){
	MsgFunc "Parâmetro \033[02;30;47m$1\033[04;34;47m"
}

function MsgFunc3(){
	MsgFunc "Parâmetro \033[02;30;47m$1\033[04;34;47m do Átomo $CalVal1 da Fase $fase: $nome_fase"
}

function MsgPasso(){
	echo -e "\033[01;31mNão convergiu.\033[0m Baixando o passo para $(echo $1)" 
}

function Sair () {
	rm -f !($ArqNome.dat|$ArqNome.pcr|$ArqNome.png|$ArqNome.irf) &> /dev/null
	exit 1
}

trap Sair SIGINT  # Para quando Para o Script com Ctrl + C deletar arquivos desnecessários!!

function Salve_Erros () {
	if [[ $Erro_Vec == 0 ]]; then
		echo "$nome" >> Erro1.sh
	elif [[ $Erro_Vec == 1 ]]; then
		echo "$nome" >> Erro2.sh
	elif [[ $Erro_Vec == 2 ]]; then
		echo "$nome" >> Erro3.sh
	else
		echo "$nome" >> Erro4.sh
	fi
}


function Verif_Shape (){
	if [ $ColJob2 != 7 ] ; then  
		faseA=$fase
		LOC_Val_ref=$LOC_Val 
	  LOC_Parm_ref=$LOC_Parm 
	  NomePRef=${Nome_Parametro[@]}
		fase=1
		while [ $fase -le $ColJob3 ] ; do
			linhaSCALE
			Vec_Shape=$(echo "$CalVal2 > 1.0" | bc) # Verificando se o Shape deu valor acima de 1.0 . Se igual a 1 é Verdade.
			Vec_Shape2=$(echo "$CalVal2 < 0" | bc)  # Verificando se o Shape deu valor abaixo de 0. Se igual a 1 é Verdade.
			if [[ $Vec_Shape == 1 || $Vec_Shape2 == 1 ]] ; then
				Vec_Shape_Val=1 # Estourou o Shape!!!
				Vec_Shape_Val1=1 # Estourou o Shape Para o Verificador do EXEC do ERRO!!!
				Shape_errado=$CalVal2
				if [[ $RUN == 0 ]]; then
					MsgErro "Verifeque seu PCR. O Shape está com valor Impróprio. Não pode ser Negativo nem MAIOR que 1.0 !!" 
					exit 1
				fi
			fi
			fase=$((fase +1))
		done
		fase=$faseA
		LOC_Val=$LOC_Val_ref 
	  LOC_Parm=$LOC_Parm_ref
	  Nome_Parametro=${NomePRef[@]}
	fi
}
function Vec_Pos_Atomica () {
	faseA=$fase
	fase=1
	while [ $fase -le $ColJob3 ] ; do
		VEC_linhaNat
		VEC_linhaNUMATOM
		VEC_linhaATOM
		VEC_AtomNumero=1
		while [ $VEC_AtomNumero -le $VEC_ColNat1 ] ; do
		
		
		if [[ $(echo "scale=4; $(echo $VEC_ColAtom3 | wc -c)  > 9 " | bc -l  ) -eq 1 || $(echo "scale=4; $(echo $VEC_ColAtom4 | wc -c)  > 9 " | bc     -l  ) -eq 1 || $(echo "scale=4; $(echo $VEC_ColAtom5 | wc -c)  > 9 " | bc -l  ) -eq 1 ]] ;then
			Pos_Atomic_Exc=1
			if [[ $RUN == 0 ]]; then
					MsgErro "Verifeque seu PCR. Existem posições Atômicas com valores Estranhos!!" 
					exit 1
			fi
		else
			if [[ $(echo "scale=4; $VEC_ColAtom3  > 1.2 " | bc -l ) -eq 1 || $(echo "scale=4; $VEC_ColAtom4  > 1.2 " | bc -l ) -eq 1 || $(echo "scale=4; $VEC_ColAtom5  > 1.2 " | bc -l ) -eq 1 ]];then
				Pos_Atomic_Exc=1
				if [[ $RUN == 0 ]]; then
					MsgErro "Verifeque seu PCR. Existem posições Atômicas com valores maiores que 1.2!!" 
					exit 1
				fi
			fi
		fi
			VEC_LOC_Val_Atom=$((VEC_LOC_Val_Atom + (2+ 2*VEC_BETA) ))
			VEC_linhaATOM
			VEC_AtomNumero=$((VEC_AtomNumero +1))
		done
		fase=$((fase +1))
	done
	fase=$faseA
}


function verif_chi () {
	if [[ $(echo "scale=4; $CHINOVO > 1.3*$CHI" | bc -l ) -eq 1 ]]; then 
		recuperecpOK
		if [[ $COND == 0 ]];then
			echo -e "\n\033[01;31mConvergiu... mas com um Chi² muito alto -> $CHINOVO , sendo o Chi² anterior igual a: $CHI\033[0m"
			if [[ $Erro_Vec == 0 ]]; then 
				echo -e "\033[02;32mSerá feita uma nova tentativa no final.\033[0m\n"
			fi
			Salve_Erros
		else
			echo -e -n "\033[02;31m$i\033[01;39;1m|\033[0m"
		fi
		Verif_Chi_Valor=1  # Deu ruim!!
		Verif_Chi_Valor1=1 # Deu ruim - Mas esse eh para o executavel do ERRO!!
		passo=0
		conta_passo=0.9
	else
		Verif_Chi_Valor=0 # Deu Certo
		Verif_Chi_Valor1=0
		if [[ $Run_OK == 1 ]]; then
			if [[ $COND == 0 ]];then
				CHI=$CHINOVO
				echo -e "\n   \033[02;34mConvergiu com Chi² = \033[02;34;1m$CHI\033[0m\n"
				conta_passo=0.9
				cpOK
			else
				if [[ $(echo "scale=4; $CHINOVO < $CHI*1.01" | bc -l ) -eq 1 ]]; then 
					echo -e -n "\033[02;36;1m$i\033[01;39;1m|\033[0m"
					if [[ $OCC_MODE == 0 ]];then
						cpOK
						CHI=$CHINOVO
					else
						echo "$i; $CHINOVO" >> Cond.dat
						cpCOND
						recuperecpOK
					fi
				else
					echo -e -n "\033[02;34m$i\033[01;39;1m|\033[0m"
					recuperecpOK
				fi
				conta_passo=0.9					
			fi
		fi
	fi
}


function convergencia () {
	CHINOVO=$(grep "Global user-weigthed" saida | tail -1 | gawk '{print $7}')  # Forma mais precisa de Obter o Chi², com mais casas decimais!!
	if [[ $RUN == 0 ]]; then
		CHI=$CHINOVO
		if [[ -f $(echo $ArqNome).new ]] ;then  # Verificando se criou um arquivo .new
			rm $(echo $ArqNome).pcr
			mv $(echo $ArqNome).new $(echo $ArqNome).pcr
		fi
		if [[ $Run_OK == 1 ]]; then
			RUN=$((RUN +1 ))
			echo -e "\n   \033[02;34mConvergiu com Chi² = $CHI\033[0m\n"
			cpOK
		fi
		Verif_Chi_Valor=0 # Pois eh a primeira vez q entra... por isso essa variavel está aqui
	else
		verif_chi
	fi
}


function MudarPasso () {
	passo=1 #Tera que mudar o valor do passo
	echo "fase=$fase ; $nome" > Passo.sh
	sed -i '1i\#!/bin/bash\' Passo.sh
	recuperecpOK
	conta_passo=$(echo "scale=2; $conta_passo - 0.2" | bc )
	if [[ $(echo "scale=2; $conta_passo < 0.1" | bc -l ) -eq 1 ]];then
		echo -e "\033[01;31mNão convergiu mesmo baixando os passos!\033[0m\n" 
		if [[ $Erro_Vec == 0 ]]; then 
			echo -e "\033[02;32mSerá feita uma nova tentativa no final.\033[0m\n"
		fi		
		Salve_Erros
		recuperecpOK
		passo=0
		conta_passo=0.9
	fi
	if [[ $passo == 1 ]]; then
		source Passo.sh
	fi
}

function verificar () {	

	Passo_OK=0
	Verif_Chi_Valor=1  # Deu ruim!!
	Verif_Chi_Valor1=1
	normal_end=$(grep "Normal end, final calculations and writing" saida)
	NaN=$(grep "NaN" saida)

	if [[ -f $(echo $ArqNome).new ]] ;then  # Verificando se Deu NaN no .new
		NaN2=$(grep "NaN" $(echo $ArqNome).new )
		if [[ -n $NaN2 ]];then  ## Se Der NaN Já deleta o Arquivo para n da erros futuros!!
			rm $(echo $ArqNome).new
		else
			mv $(echo $ArqNome).new $(echo $ArqNome).pcr
		fi
	fi

	Asterisco=$(grep "\*" $(echo $ArqNome).pcr)
	NegativeGAUSSIAN=$(grep "Negative GAUSSIAN" saida)
	Fractional=$(grep "Fractional coordidate of atom" saida)

	if [[ -z $Asterisco ]]; then
		if [[ $RUN == 0 || $Shape_Mode == 1 ]]; then
			Verif_Shape
		fi
		if [[ $RUN == 0 || $Atomo_Mode == 1 ]]; then
			Vec_Pos_Atomica
		fi
	fi
	
	if [[ -n "$normal_end" && -z "$NaN" && -z "$NaN2" && "$Vec_Shape_Val" == 0 && "$Verif_Biso_Val" == 0 && -z "$NegativeGAUSSIAN" && -z "$Fractional" && "$Pos_Atomic_Exc" == 0 && -z "$Asterisco" ]] ;	then
		conv=$(grep "Convergence reached" saida)

		if [[ -n $conv ]] ;	then 

			convergencia

			passo=0
		else
			if [[ $RUN == 0 ]]; then
				echo -e "\033[02;31mNão convergiu na Primeira tentativa!! VERIFIQUE SEUS DADOS ANTES DE RODAR NO SCRIPT\033[0m"
				exit 1
			else
				if [[ $COND == 0 && $COND1 == 0 && $ERRO_PASSO == 0 && $FINALIZAR == 0 ]];then
					MudarPasso
					if [[ $Verif_Chi_Valor == 0 ]]; then
						Passo_OK=1 # Tudo Ok!! 
					fi
				else

					if [[ $COND == 1 && $COND1 == 1 ]];then
						echo -e -n "\033[02;31m$i\033[01;39;1m|\033[0m"
						recuperecpOK
					else
						echo -e -n "\033[02;31m \\u2620 Erro \\u2620 \033[01;39;1m|\033[0m"
						ERRO_PASSO=1
						recuperecpOK
					fi
				fi
			fi
		fi
	else
		recuperecpOK
		NaN2="" # Somente para limpar a variavel!! Pois essa variavel está dentro de uma IF e depende da exista do arq .new
		if [[ $COND == 0 ]]; then
			if [[ $Vec_Shape_Val == 1 ]]; then		
				echo -e "\n\033[01;31mConvergiu mas o Shape ficou com valor Impróprio. --> $Shape_errado <-- \033[0m\n"
				if [[ $Erro_Vec == 0 ]]; then 
					echo -e "\033[02;32mSerá feita uma nova tentativa no final.\033[0m\n"
				fi
				Salve_Erros
			elif [[ $Verif_Biso_Val == 1 ]]; then	
				echo -e "\n\033[01;31mConvergiu mas o Biso ficou com valor Impróprio.\033[0m"
				if [[ $Erro_Vec == 0 ]]; then 
					echo -e "\033[02;32mSerá feita uma nova tentativa no final.\033[0m\n"
				fi
				Salve_Erros
			else
				echo -e "\n\033[01;31m \\u2620 Erro \\u2620 \033[0m\n"
				if [[ $Erro_Vec == 0 ]]; then 
					echo -e "\033[02;32mSerá feita uma nova tentativa no final.\033[0m\n"
				fi
				if [[ $RUN == 0 ]]; then
					echo -e "\033[02;31mERRO NA PRIMEIRA TENTATIVA!! VERIFIQUE SEUS DADOS ANTES DE RODAR NO SCRIPT\033[0m"
					if [[ ! -z $Fractional ]]; then
							echo -e "\033[02;31m$Fractional\033[0m"
					fi
					exit 1
				fi
				Erro_Erro=1
				Salve_Erros
			fi
		else
			echo -e -n "\033[02;31m$i\033[01;39;1m|\033[0m"
		fi
		passo=0
		conta_passo=0.9
		Vec_Shape_Val=0
		Verif_Biso_Val=0
		Pos_Atomic_Exc=0
	fi

}

function fullprof () {
	Run_OK=0
	while [ $Run_OK -le 1 ]; do
		fp2k $(echo $ArqNome) > saida
	if [[ $Debug == 1 ]]; then
  	grep -B 15 CPU saida    # Verificar a saida
    grep -B 7 overlap saida # Verificar a saida
    grep -B 7 REFLECTIONS saida
  fi
		verificar
		if [[ $Verif_Chi_Valor != 0 ]]; then
			break
		fi
		if [[ $Passo_OK == 1 ]];then
			break
		fi
		Run_OK=$((Run_OK +1 ))
	done

	if [[ $Verif_Chi_Valor == 0 && $COND == 0 ]]; then
		source Grafico.sh
	fi

	Passo_OK=0
}


					##############################
					## 			  								  ##
					##  Funções dos Parâmetros  ##
					## 			   				          ##
  				##############################


###########################
# Salvando Nome das fases #
###########################

function NomeFase (){
	temp_nome=$(grep -n "Nat " $(echo $ArqNome).pcr | cut -f1 -d":" | sed -n ${fase}p)
	temp_nome=$((temp_nome - 2))
	nome_fase=$(sed -n ${temp_nome}p $(echo $ArqNome).pcr)
}


###################
# Parâmetro Valor #
###################

function Parametro (){

	if [[ $passo == 0 ]];then
		P=$(grep "Number" $(echo $ArqNome).pcr | cut -f1 -d"!")
 		PP=$(echo "scale=2; ($P+1)*10 + 1.00" | bc )
	else
		P=$(grep "Number" $(echo $ArqNome).pcr | cut -f1 -d"!")
	 	PP=$(echo "scale=2; ($P+1)*10 + $conta_passo" | bc )
	fi
}

#####################
# Função para Rodar #
#####################

function Rodar (){ #$CalVal2 MsgFunc2 ${Nome_Parametro[0]} Parametro_2_9
	Vec_temp=$(echo $1 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			$2 $3
		else
			MsgPasso $conta_passo
		fi
		$4
		fullprof
		
		if [[ $ZeroPara == 1 || $ParamUVW == 1 ]] ; then
			$5
			$6
			cpOK
		fi
		
	fi
}

##########
# Escala #
##########

function escala () {
	nome="fase=$fase; escala"
	NomeFase
	Parametro
	linhaSCALE
	if [[ $passo == 0 ]] ; then
		MsgFunc1 ${Nome_Parametro[0]}
	else
		MsgPasso $conta_passo
	fi
	
	Vec_temp=$(echo $CalParam1 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		Parametro_1_6
	fi
	fullprof

}

function ESCALA () {
	fase=1
	while [ $fase -le $ColJob3 ] ; do
		escala
		fase=$((fase +1))
	done
}


######################
# Parametros de Rede #
######################

# Parametros de Rede a
function paramA () {
	nome="fase=$fase; paramA"
	NomeFase
	Parametro
	linhaABC
	Rodar $CalParam1 MsgFunc1 ${Nome_Parametro[0]} Parametro_1_6 linhaABC Parametro_0_6_1
}

# Parametros de Rede b
function paramB (){
	nome="fase=$fase; paramB"
	NomeFase
	Parametro
	linhaABC
	Rodar $CalParam2 MsgFunc1 ${Nome_Parametro[1]} Parametro_2_6 linhaABC Parametro_0_6_1
}

# Parametros de Rede c
function paramC (){
	nome="fase=$fase; paramC"
	NomeFase
	Parametro
	linhaABC
	Rodar $CalParam3 MsgFunc1 ${Nome_Parametro[2]} Parametro_3_6 linhaABC Parametro_0_6_1
}


function PARAMETROS_REDE () {
	fase=1
	while [ $fase -le $ColJob3 ] ; do
		paramA
		paramB
		paramC
		fase=$((fase +1))
	done
}

###############
# Parametro W #
###############

function paramW () {
	nome="fase=$fase; paramW"
  nome=""
	NomeFase
	Parametro
	linhaUVW
	Rodar $CalParam3 MsgFunc1 ${Nome_Parametro[2]} Parametro_3_7 linhaUVW Parametro_0_7_1
}

###############
# Parametro V #
###############

function paramV () {
	nome="fase=$fase; paramV"
  nome=""
	NomeFase
	Parametro
	linhaUVW
	Rodar $CalParam2 MsgFunc1 ${Nome_Parametro[1]} Parametro_2_7 linhaUVW Parametro_0_7_1
}

###############
# Parametro U #
###############

function paramU () {
	nome="fase=$fase; paramU"
	nome=""
	NomeFase
	Parametro
	linhaUVW
	Rodar $CalParam1 MsgFunc1 ${Nome_Parametro[0]} Parametro_1_7 linhaUVW Parametro_0_7_1
}

function paramUVWZERAR () {
	linhaUVW
	ContUVW=0
	Vec_temp=$(echo $CalParam1 | cut -f1 -d".")
	if [[ $Vec_temp != 0 ]] ; then
		ContUVW=$((ContUVW+1))
	fi
	Vec_temp=$(echo $CalParam2 | cut -f1 -d".")
	if [[ $Vec_temp != 0 ]] ; then
		ContUVW=$((ContUVW+1))
	fi
	Vec_temp=$(echo $CalParam3 | cut -f1 -d".")
	if [[ $Vec_temp != 0 ]] ; then
		ContUVW=$((ContUVW+1))
	fi
	LINHA_Parm=$(echo 0.000 0.000 0.000 $CalParam4 $CalParam5 $CalParam6 $CalParam7)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
	ParNumber=$(grep -n "Number" $(echo $ArqNome).pcr | cut -f1 -d":")
	NumParAtual=$(grep  "\!Number of" $(echo $ArqNome).pcr | cut -f1 -d"!")
	NumParAtual=$((NumParAtual-ContUVW))
	sed -i "$ParNumber s/.*/      $NumParAtual    !Number of refined parameters/" $(echo $ArqNome).pcr		

}

function PARAMETROS_UVW () {
	ParamUVW=1
	fase=1
	while [ $fase -le $ColJob3 ] ; do
		paramW
		paramV
		paramU
		fase=$((fase +1))
	done
	ParamUVW=0
}

##################
# Parametro Zero #
##################

function paramZERO () {
	nome=paramZERO
	Parametro
	linhaZERO
	Rodar $CalVal2 MsgFunc2 ${Nome_Parametro[0]} Parametro_2_9 linhaZERO Parametro_0_9 
}


###################
# Parametro SyCos #
###################

function paramSyCos () {
	nome=paramSyCos
	Parametro
	linhaZERO
	Rodar $CalVal4 MsgFunc2 ${Nome_Parametro[2]} Parametro_4_9 linhaZERO Parametro_0_9
}

###################
# Parametro SySin #
###################

function paramSySin () {
	nome=paramSySin
	Parametro
	linhaZERO
	Rodar $CalVal6 MsgFunc2 ${Nome_Parametro[4]} Parametro_6_9 linhaZERO Parametro_0_9
}

###################
# Parametro Shape #
###################

function paramShape () {
	if [[ $ColJob2 -eq 5 || $ColJob2 -eq 4 || $ColJob2 -eq 6 ]] ; then
		nome="fase=$fase; paramShape"
		NomeFase
		Parametro
		linhaSCALE
		Rodar $CalParam2 MsgFunc1 ${Nome_Parametro[1]} Parametro_2_6 linhaSCALE Parametro_0_6
	else
		echo -e "\033[04;32mO parametro SHAPE só refina quando se usa o Npr = 4, 5 e 6.\033[0m"
		echo -e "\033[04;32mLeia pag. 110 do Manual do FullProf para mais detalhes.\033[0m"
		echo
	fi
}

function PARAMETRO_SHAPE () {
	Shape_Mode=1
	fase=1
	while [ $fase -le $ColJob3 ] ; do
		paramShape
		fase=$((fase +1))
	done
}

#############################
# Parametro X e Parametro Y #
#############################

function paramX () {
	if [[ $ColJob2 == 7 ]] ; then
		nome="fase=$fase; paramX"
		NomeFase
		Parametro
		linhaUVW
		Rodar $CalParam4 MsgFunc1 ${Nome_Parametro[3]} Parametro_4_7 linhaUVW Parametro_0_7
	else
		echo -e "\033[04;32mO parametro X só refina quando se usa o Npr = 7.\033[0m"
		echo -e "\033[04;32mLeia pag. 111 do Manual do FullProf para mais detalhes.\033[0m"
		echo
	fi
}

function paramY () {
	if [[ $ColJob2 == 7 ]] ; then
		nome="fase=$fase; paramY"
		NomeFase
		Parametro
		linhaUVW
		Rodar $CalParam5 MsgFunc1 ${Nome_Parametro[4]} Parametro_5_7 linhaUVW Parametro_0_7
	else
		echo -e "\033[04;32mO parametro Y só refina quando se usa o Npr = 7.\033[0m"
		echo -e "\033[04;32mLeia pag. 111 do Manual do FullProf para mais detalhes.\033[0m"
		echo
	fi
}

function PARAMETROS_XY () {
	fase=1
	while [ $fase -le $ColJob3 ] ; do
		paramX
		fase=$((fase +1))
	done
	fase=1
	while [ $fase -le $ColJob3 ] ; do
		paramY
		fase=$((fase +1))
	done
}

function GauSiz () {
	nome="fase=$fase; GauSiz"
	NomeFase
	Parametro
	linhaUVW
	Rodar $CalParam6 MsgFunc1 ${Nome_Parametro[5]} Parametro_6_7 linhaUVW Parametro_0_7
}

function LorSiz () {
	nome="fase=$fase; LorSiz"
	NomeFase
	Parametro
	linhaUVW
	Rodar $CalParam7 MsgFunc1 ${Nome_Parametro[6]} Parametro_7_7 linhaUVW Parametro_0_7
}

function PARAMETRO_GauSiz_LorSiz () {
	fase=1
	while [ $fase -le $ColJob3 ] ; do
		GauSiz 
		LorSiz 
		fase=$((fase +1))
	done
}


#############################
# Parametros de Assimetrias #
#############################

# Assimetria 1
function paramAss1 () {
	nome="fase=$fase; paramAss1"
	NomeFase
	Parametro
	linhaPREF
	if [[ $ColJob2 == 7 ]] ; then 
		Rodar $CalParam3 MsgFunc1 ${Nome_Parametro[2]} Parametro_3_8 linhaPREF Parametro_0_8
	else
		Rodar $CalParam3 MsgFunc1 ${Nome_Parametro[2]} Parametro_3_6 linhaPREF Parametro_0_6
	fi
}


# Assimetria 2
function paramAss2 () {
	nome="fase=$fase; paramAss2"
	NomeFase
	Parametro
	linhaPREF
	if [[ $ColJob2 == 7 ]] ; then
		Rodar $CalParam4 MsgFunc1 ${Nome_Parametro[3]} Parametro_4_8 linhaPREF Parametro_0_8
	else
		Rodar $CalParam4 MsgFunc1 ${Nome_Parametro[3]} Parametro_4_6 linhaPREF Parametro_0_6
	fi
}

# Assimetria 3
function paramAss3 () {
	nome="fase=$fase; paramAss3"
	NomeFase
	Parametro
	linhaPREF
	if [[ $ColJob2 == 7 ]] ; then
		Rodar $CalParam5 MsgFunc1 ${Nome_Parametro[4]} Parametro_5_8 linhaPREF Parametro_0_8
	else
		Rodar $CalParam5 MsgFunc1 ${Nome_Parametro[4]} Parametro_5_6 linhaPREF Parametro_0_6
	fi
}

# Assimetria 4
function paramAss4 () {
	nome="fase=$fase; paramAss4"
	NomeFase
	Parametro
	linhaPREF
	if [[ $ColJob2 == 7 ]] ; then
		Rodar $CalParam6 MsgFunc1 ${Nome_Parametro[5]} Parametro_6_8 linhaPREF Parametro_0_8
	else
		Rodar $CalParam6 MsgFunc1 ${Nome_Parametro[5]} Parametro_6_6 linhaPREF Parametro_0_6
	fi
}

function paramS_L () {
	nome="fase=$fase; paramS_L"
	NomeFase
	Parametro
	linhaPREF
	Rodar $CalParam7 MsgFunc1 ${Nome_Parametro[6]} Parametro_7_8 linhaPREF Parametro_0_8
}

function paramD_L () {
	nome="fase=$fase; paramD_L"
	NomeFase
	Parametro
	linhaPREF
	Rodar $CalParam8 MsgFunc1 ${Nome_Parametro[7]} Parametro_8_8 linhaPREF Parametro_0_8
}

function PARAMETRO_ASSIMETRIA () {
	fase=1
	while [ $fase -le $ColJob3 ] ; do
		paramAss1 
		paramAss2 
		paramAss3 
		paramAss4 
		if [[ $ColJob2 == 7 ]] ; then
			paramS_L      
			paramD_L
		fi
		fase=$((fase +1))
	done
}

##############
# BackGround #
##############

function paramBack1 () {
	nome=paramBack1
	Parametro
	linhaBackcoef
	Rodar $CalParam1 MsgFunc2 "Primeiro_Coeficiente_do_Background" Parametro_1_6  linhaBackcoef Parametro_0_6_1
}

function paramBack2 () {
	nome=paramBack2
	Parametro
	linhaBackcoef
	Rodar $CalParam2 MsgFunc2 "Segundo_Coeficiente_do_Background" Parametro_2_6 linhaBackcoef Parametro_0_6_1
}

function paramBack3 () {
	nome=paramBack3
	Parametro
	linhaBackcoef
	Rodar $CalParam3 MsgFunc2 "Terceiro_Coeficiente_do_Background" Parametro_3_6 linhaBackcoef Parametro_0_6_1
}

function paramBack4 () {
	nome=paramBack4
	Parametro
	linhaBackcoef
	Rodar $CalParam4 MsgFunc2 "Quarto_Coeficiente_do_Background" Parametro_4_6  linhaBackcoef Parametro_0_6_1
}

function paramBack5 () {
	nome=paramBack5
	Parametro
	linhaBackcoef
	Rodar $CalParam5 MsgFunc2 "Quinto_Coeficiente_do_Background" Parametro_5_6 linhaBackcoef Parametro_0_6_1
}

function paramBack6 () {
	nome=paramBack6
	Parametro
	linhaBackcoef
	Rodar $CalParam6 MsgFunc2 "Sexto_Coeficiente_do_Background" Parametro_6_6 linhaBackcoef Parametro_0_6_1
}


function paramBack () {
	if [[ $passo == 0 ]] ; then
		echo -e "\033[04;34;47mBackground\033[0m"
	fi
	LOCBaCk=$(grep -n "2Theta/TOF/" $(echo $ArqNome).pcr | cut -f1 -d":")
	LOCBaCk=$((LOCBaCk + 1))
	X=1
	if [ $ColJob4 == 0 ] ; then
		paramBack1
		paramBack2
		paramBack3
		paramBack4
		paramBack5
		paramBack6
	else
		#nome=paramBack
		nome=""
		Parametro
		while [[ $X -le $ColJob4 ]] ; do
			LINHAback=$(sed -n ${LOCBaCk}p $(echo $ArqNome).pcr)
			BACK1=$(echo $LINHAback | cut -f1 -d" ")
			BACK2=$(echo $LINHAback | cut -f2 -d" ")
			BACK3=$(echo $LINHAback | cut -f3 -d" ")
			LINHAback=$(echo $BACK1 $BACK2 $(echo $PP) )
			sed -i "$LOCBaCk s/.*/$LINHAback/" $(echo $ArqNome).pcr
			X=$((X + 1))
			LOCBaCk=$((LOCBaCk + 1))
			PP=$(echo "scale=2; $PP + 10 " | bc )
		done
		if [[ $passo == 0 ]] ; then
			echo -e "\033[02;32mRefinando os $ColJob4 parâmetros do Background\033[0m"
		else
			MsgPasso $conta_passo
		fi
		fullprof
		if [[ $Verif_Chi_Valor == 0 ]] ; then
			LOCBaCk=$(grep -n "2Theta/TOF/" $(echo $ArqNome).pcr | cut -f1 -d":")
			LOCBaCk=$((LOCBaCk + 1))
			X=1
			if [[ $Finalizar_VEC == 0 ]] ; then
				while [[ $X -le $ColJob4 ]] ; do
					LINHAback=$(sed -n ${LOCBaCk}p $(echo $ArqNome).pcr)
					BACK1=$(echo $LINHAback | cut -f1 -d" ")
					BACK2=$(echo $LINHAback | cut -f2 -d" ")
					BACK3=$(echo $LINHAback | cut -f3 -d" ")
					LINHAback=$(echo $BACK1 $BACK2 0.000 )
					sed -i "$LOCBaCk s/.*/$LINHAback/" $(echo $ArqNome).pcr
					X=$((X + 1))
					LOCBaCk=$((LOCBaCk + 1))
				done
			
				ParNumber=$(grep -n "Number" $(echo $ArqNome).pcr | cut -f1 -d":")
				NumParAtual=$(grep  "\!Number of" $(echo $ArqNome).pcr | cut -f1 -d"!")
				NumParAtual=$((NumParAtual-ColJob4))
				sed -i "$ParNumber s/.*/      $NumParAtual    !Number of refined parameters/" $(echo $ArqNome).pcr		
				echo -e "\033[02;32mTravando os Parâmetros do Background. Refinando...\033[0m"
				fullprof
			fi
		fi
	fi
}

###################
# Posição Atômica #
###################

function Pos_Especial () {
	PosicoesEspeciais=(0 0.5 0.25 0.33333 0.3333 0.66666 0.6667 0.75 0.375 0.125 0.625 0.875)
	for i in ${PosicoesEspeciais[@]} ; do
		if [[ $(echo "scale=4; $1  == $i " | bc -l ) -eq 1 ]] ;then
			Pos_ESP=1
			break
		else
			Pos_ESP=0
	fi	
	done

}

function EIXO_X () {
	nome="fase=$fase; LOC_Parm_Atom=$LOC_Parm;LOC_Val=$LOC_Val; linhaATOM; EIXO_X"
	NomeFase
	Parametro
	Vec_temp=$(echo $CalParam1 | cut -f1 -d".")
	Pos_Especial $CalVal3
	if [[ $Vec_temp == 0 && $Pos_ESP == 0 ]] ; then
#		if [[ $passo == 0 ]] ; then
#			MsgFunc3 "X"
#		else
#			MsgPasso $conta_passo
#		fi
#		LINHA_Parm_Atom=$(echo $(echo $PP) $CalValP2 $CalValP3 $CalValP4 $CalValP5)
#		sed -i "$LOC_Parm_Atom s/.*/$LINHA_Parm_Atom/" $(echo $ArqNome).pcr
#		fullprof
	Rodar $CalParam1 MsgFunc3 ${Nome_Parametro[0]} Parametro_1_5 linhaATOM Parametro_0_5 
  fi
}

function EIXO_Y () {
	nome="fase=$fase; LOC_Parm_Atom=$LOC_Parm;LOC_Val_Atom=$LOC_Val; linhaATOM; EIXO_Y"
	NomeFase
	Parametro
	Vec_temp=$(echo $CalParam2 | cut -f1 -d".")
	Pos_Especial $CalVal4
	if [[ $Vec_temp == 0 && $Pos_ESP == 0 ]] ; then
#		if [[ $passo == 0 ]] ; then
#			MsgFunc3 "Y"
#		else
#			MsgPasso $conta_passo
#		fi
#		LINHA_Parm_Atom=$(echo $CalValP1  $(echo $PP) $CalValP3 $CalValP4 $CalValP5)
#		sed -i "$LOC_Parm_Atom s/.*/$LINHA_Parm_Atom/" $(echo $ArqNome).pcr
#		fullprof
	Rodar $CalParam2 MsgFunc3 ${Nome_Parametro[1]} Parametro_2_5 linhaATOM Parametro_0_5 
  fi
}

function EIXO_Z () {
	nome="fase=$fase; LOC_Parm_Atom=$LOC_Parm;LOC_Val_Atom=$LOC_Val; linhaATOM;  EIXO_Z"
	NomeFase
	Parametro
	Vec_temp=$(echo $CalParam3 | cut -f1 -d".")
	Pos_Especial $CalVal5
	if [[ $Vec_temp == 0 && $Pos_ESP == 0 ]] ; then
#		if [[ $passo == 0 ]] ; then
#			MsgFunc3 "Z"
#		else
#			MsgPasso $conta_passo
#		fi
#		LINHA_Parm_Atom=$(echo  $CalValP1 $CalValP2  $(echo $PP)  $CalValP4 $CalValP5)
#		sed -i "$LOC_Parm_Atom s/.*/$LINHA_Parm_Atom/" $(echo $ArqNome).pcr
#		fullprof
	Rodar $CalParam3 MsgFunc3 ${Nome_Parametro[2]} Parametro_3_5 linhaATOM Parametro_0_5 
  fi
}

function PosicaoAtomica () {
	Atomo_Mode=1
	fase=1
	while [ $fase -le $ColJob3 ] ; do
		linhaNat
		linhaNUMATOM
		linhaATOM
		AtomNumero=1
		while [ $AtomNumero -le $ColNat1 ] ; do
			EIXO_X
			linhaATOM
			EIXO_Y
			linhaATOM
			EIXO_Z
			linhaATOM
			LOC_Parm=$((LOC_Parm + (2+ 2*BETA) ))
			LOC_Val=$((LOC_Val + (2+ 2*BETA) ))
			linhaATOM
			AtomNumero=$((AtomNumero +1))
		done
		fase=$((fase +1))
	done
}



#Salvar Biso

function Verif_Biso () {
		faseA=$fase
		fase=1
	while [ $fase -le $ColJob3 ] ; do
		linhaNat
		VEC_linhaNUMATOM
		VEC_linhaATOM
		VEC_AtomNumero=1
		while [ $VEC_AtomNumero -le $ColNat1 ] ; do
			if [[ $(echo "scale=5; $VEC_ColAtom6 < 0" | bc -l ) -eq 1 || $(echo "scale=5; $VEC_ColAtom6 < 0" | bc -l ) -gt 5 ]];then
				Verif_Biso_Val=1 # Deu valor Improprio do Biso
				if [[ $RUN == 0 ]]; then
					echo -e "\033[01;31mBISO NEGATIVO OU ACIMA DE 5!! - MUDE ANTES DE RODA O SCRIPT\033[0m" 
					exit 1
				fi
			fi
			if [[ $VEC_BETA == 1 ]];then
				VEC_LOC_Parm_Atom=$((VEC_LOC_Parm_Atom + 4))
				VEC_LOC_Val_Atom=$((VEC_LOC_Val_Atom + 4))
			else
				VEC_LOC_Parm_Atom=$((VEC_LOC_Parm_Atom + 2))
				VEC_LOC_Val_Atom=$((VEC_LOC_Val_Atom + 2))
			fi
			linhaATOM
			VEC_AtomNumero=$((VEC_AtomNumero +1))
		done
		fase=$((fase +1))
	done
		fase=$faseA
}


function verifcdopagem () {
	AtomIguais=0
	VerifAtom=1
	LOC_Val_Atom_inicial=$(echo $LOC_Val)
	LOC_Val_Parm_inicial=$(echo $LOC_Parm)
	linhaATOM
	OCC_MAX=$CalVal7
	while [ $VerifAtom == 1 ] ; do
		linhaATOM
		Atom1=$CalVal3
		Atom2=$CalVal4
		Atom3=$CalVal5
		atom7=$CalVal7
		LOC_Val=$((LOC_Val + (2+ 2*BETA) ))
		linhaATOM
		Atom4=$CalVal3
		Atom5=$CalVal4
		Atom6=$CalVal5
		Atom8=$CalVal7
		if [[ $Atom1 == $Atom4 && $Atom2 == $Atom5 && $Atom3 == $Atom6 ]] ; then
			AtomIguais=$((AtomIguais+1))
			OCC_MAX=$(echo "scale=5; $Atom8 + $OCC_MAX" | bc )
		else
			VerifAtom=0
		fi
	done
	LOC_Val=$(echo $LOC_Val_Atom_inicial)
	LOC_Parm=$(echo $LOC_Val_Parm_inicial)
}

function Parametro_Biso () {
	OCC_MODE=1
	COND=1 # Entrou na Parte de Fazer Condições - Modo de saida Diferente dos Demais
	COND1=1 # Para evitar entrar no Passo quando o COND = 0!!
	linhaNat
	linhaNUMATOM
	linhaATOM
	NomeFase
	AtomNumero=1
	while [ $AtomNumero -le $ColNat1 ] ; do
		NomeFase
		MsgFunc3 "Biso" 
		echo -e "\n\033[02;32mO Biso irá variar de 0 até 2.99988 num intervalo de 0.07692.\033[0m"
		echo -e "\033[02;32mFundamentals of Powder Diffraction and Structural Characterization of Materials. 2 Ed. Pag 207.\033[0m\n"
		verifcdopagem
		Cont_Linha=1
		Cont_Linha_Quebra=10
		for i in $(seq 0.00000 0.07692 3)
		do
			Contagem_Atomo=0
			while [ $Contagem_Atomo -le $AtomIguais ] ; do
				linhaATOM
				LINHA_Val=$(echo  $CalVal1 $CalVal2 $CalVal3  $CalVal4 $CalVal5 $i $CalVal7 $CalVal8 $CalVal9 $CalVal10 $CalVal11 )
				sed -i "$LOC_Val s/.*/$LINHA_Val/" $(echo $ArqNome).pcr
				LOC_Val=$((LOC_Val + (2+ 2*BETA) ))
				Contagem_Atomo=$((Contagem_Atomo+1))
			done
			fullprof
			if [[ $Cont_Linha == $Cont_Linha_Quebra ]];then #Somente para saltar uma linha na tela!!
				Cont_Linha_Quebra=$((Cont_Linha_Quebra+10))
				echo
			fi
			Cont_Linha=$((Cont_Linha+1))
			LOC_Val=$(echo $LOC_Val_Atom_inicial)
		done
		
		if [[ -f Cond.dat ]];then
			i=$(sort -g -k 2 Cond.dat | cut -f1 -d ";" | head -1)
			CHI=$(sort -g -k 2 Cond.dat | cut -f2 -d ";" | head -1)
			recuperecpCOND
			cpOK
			rm -f *-COND* Cond.dat
		fi
		
		linhaATOM
		echo -e "\n\033[02;32mMelhor Biso do Átomo $CalVal1 da fase $fase foi de: $CalVal6 com Chi² = \033[02;34;1m$CHI\033[02;32m.\033[0m\n"
		COND=0
	#	fullprof
		COND=1	
		LOC_Val=$((LOC_Val + (2+ 2*BETA)*(1+AtomIguais) ))
		linhaATOM
		AtomNumero=$((AtomNumero +1+ 1*AtomIguais))
	done
}

###################
# Posição Atômica #
###################

function BETA_11 () {
	nome="fase=$fase; LOC_Parm_BETA=$LOC_Parm_BETA;LOC_Val_BETA=$LOC_Val_BETA; linhaBETA; LOC_Val_Atom=$LOC_Val_Atom; linhaATOM; BETA_11"
	NomeFase
	Parametro
	Vec_temp=$(echo $ColBETAP1 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc3 "BETA11" 
		else
			MsgPasso $conta_passo
		fi
		LINHA_Parm_BETA=$(echo $(echo $PP) $ColBETAP2 $ColBETAP3 $ColBETAP4 $ColBETAP5 $ColBETAP6 )
		sed -i "$LOC_Parm_BETA s/.*/$LINHA_Parm_BETA/" $(echo $ArqNome).pcr
		fullprof
  fi
}


function BETA_22 () {
	nome="fase=$fase; LOC_Parm_BETA=$LOC_Parm_BETA;LOC_Val_BETA=$LOC_Val_BETA; linhaBETA; LOC_Val_Atom=$LOC_Val_Atom; linhaATOM; BETA_22"
	NomeFase
	Parametro
	Vec_temp=$(echo $ColBETAP2 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc3 "BETA22" 
		else
			MsgPasso $conta_passo
		fi
		LINHA_Parm_BETA=$(echo $ColBETAP1 $(echo $PP) $ColBETAP3 $ColBETAP4 $ColBETAP5 $ColBETAP6 )
		sed -i "$LOC_Parm_BETA s/.*/$LINHA_Parm_BETA/" $(echo $ArqNome).pcr
		fullprof
  fi
}

function BETA_33 () {
	nome="fase=$fase; LOC_Parm_BETA=$LOC_Parm_BETA;LOC_Val_BETA=$LOC_Val_BETA; linhaBETA; LOC_Val_Atom=$LOC_Val_Atom; linhaATOM; BETA_33"
	NomeFase
	Parametro
	Vec_temp=$(echo $ColBETAP3 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc3 "BETA33" 
		else
			MsgPasso $conta_passo
		fi
		LINHA_Parm_BETA=$(echo $ColBETAP1 $ColBETAP2 $(echo $PP) $ColBETAP4 $ColBETAP5 $ColBETAP6 )
		sed -i "$LOC_Parm_BETA s/.*/$LINHA_Parm_BETA/" $(echo $ArqNome).pcr
		fullprof
  fi
}

function BETA_12 () {
	nome="fase=$fase; LOC_Parm_BETA=$LOC_Parm_BETA;LOC_Val_BETA=$LOC_Val_BETA; linhaBETA; LOC_Val_Atom=$LOC_Val_Atom; linhaATOM; BETA_12"
	NomeFase
	Parametro
	Vec_temp=$(echo $ColBETAP4 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc3 "BETA12" 
		else
			MsgPasso $conta_passo
		fi
		LINHA_Parm_BETA=$(echo $ColBETAP1 $ColBETAP2 $ColBETAP3 $(echo $PP) $ColBETAP5 $ColBETAP6 )
		sed -i "$LOC_Parm_BETA s/.*/$LINHA_Parm_BETA/" $(echo $ArqNome).pcr
		fullprof
  fi
}

function BETA_13 () {
	nome="fase=$fase; LOC_Parm_BETA=$LOC_Parm_BETA;LOC_Val_BETA=$LOC_Val_BETA; linhaBETA; LOC_Val_Atom=$LOC_Val_Atom; linhaATOM; BETA_13"
	NomeFase
	Parametro
	Vec_temp=$(echo $ColBETAP5 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc3 "BETA13" 
		else
			MsgPasso $conta_passo
		fi
		LINHA_Parm_BETA=$(echo $ColBETAP1 $ColBETAP2 $ColBETAP3 $ColBETAP4 $(echo $PP) $ColBETAP6 )
		sed -i "$LOC_Parm_BETA s/.*/$LINHA_Parm_BETA/" $(echo $ArqNome).pcr
		fullprof
  fi
}

function BETA_23 () {
	nome="fase=$fase; LOC_Parm_BETA=$LOC_Parm_BETA;LOC_Val_BETA=$LOC_Val_BETA; linhaBETA; LOC_Val_Atom=$LOC_Val_Atom; linhaATOM; BETA_23"
	NomeFase
	Parametro
	Vec_temp=$(echo $ColBETAP6 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc3 "BETA23" 
		else
			MsgPasso $conta_passo
		fi
		LINHA_Parm_BETA=$(echo $ColBETAP1 $ColBETAP2 $ColBETAP3 $ColBETAP4 $ColBETAP5 $(echo $PP) )
		sed -i "$LOC_Parm_BETA s/.*/$LINHA_Parm_BETA/" $(echo $ArqNome).pcr
		fullprof
  fi
}

function Parametro_Beta () {
	linhaNat
	linhaNUMATOM
	linhaBETA
	linhaATOM
	AtomNumero=1
	while [ $AtomNumero -le $ColNat1 ] ; do
		BETA_11
		linhaBETA
		linhaATOM
		BETA_22
		linhaBETA
		linhaATOM
		BETA_33
		linhaBETA
		linhaATOM
		BETA_12
		linhaBETA
		linhaATOM
		BETA_13
		linhaBETA
		linhaATOM
		BETA_23
		linhaBETA
		linhaATOM
		LOC_Parm_BETA=$((LOC_Parm_BETA + 4))
		LOC_Val_BETA=$((LOC_Val_BETA + 4))
		LOC_Parm=$((LOC_Parm + 4))
		LOC_Val=$((LOC_Val + 4))
		linhaBETA
		linhaATOM
		AtomNumero=$((AtomNumero +1))
	done
}

function PAR_BISO () {
	nome="fase=$fase; LOC_Parm_Atom=$LOC_Parm;LOC_Val_Atom=$LOC_Val; linhaATOM;  PAR_BISO"
	NomeFase
	Parametro
	Vec_temp=$(echo $CalParam4 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc3 "Biso" 
		else
			MsgPasso $conta_passo
		fi
		LINHA_Parm=$(echo  $CalParam1 $CalParam2  $CalParam3 $(echo $PP) $CalParam5)
		sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
		fullprof
  fi
}

function Parametro_Biso1 () {
		linhaNat
		linhaNUMATOM
		linhaATOM
		AtomNumero=1
		while [ $AtomNumero -le $ColNat1 ] ; do
			PAR_BISO
			linhaATOM
			LOC_Parm=$((LOC_Parm + (2+ 2*BETA) ))
			LOC_Val=$((LOC_Val + (2+ 2*BETA) ))
			linhaATOM
			AtomNumero=$((AtomNumero +1))
		done
		OCC_MODE=0
}

function Parametro_Termico () {
	fase=1
	if [[ $Biso_Mode == 0 ]];then
		linhaNUMATOM
		while [ $fase -le $ColJob3 ] ; do
			linhaNUMATOM
			if [[ $BETA == 1 ]];then
				Parametro_Beta
			else
				Parametro_Biso
			fi
			fase=$((fase+1))
		done
	else
		linhaNUMATOM
		while [ $fase -le $ColJob3 ] ; do
			NomeFase
			linhaNUMATOM
			Parametro_Biso1
			fase=$((fase+1))
		done
	fi
	COND=0
	COND1=0
}





function PAR_OCC () {
	nome="fase=$fase; LOC_Parm_Atom=$LOC_Parm;LOC_Val_Atom=$LOC_Val; linhaATOM;  PAR_OCC"
	verifcdopagem
	linhaATOM
	Contagem_Atomo=0
	while [ $Contagem_Atomo -le $AtomIguais ] ; do
		NomeFase
		Parametro
		Vec_temp=$(echo $CalParam5 | cut -f1 -d".")
		if [[ $Vec_temp == 0 ]] ; then
			if [[ $passo == 0 ]] ; then
			MsgFunc3 "Ocupação" 
			else
				MsgPasso $conta_passo
			fi
			if [ $Contagem_Atomo == 0 ] ;then
				LINHA_Parm=$(echo  $CalParam1 $CalParam2  $CalParam3 $CalParam4 $(echo $PP) )
			else
				LINHA_Parm=$(echo  $CalParam1 $CalParam2  $CalParam3 $CalParam4 -$(echo $PP) )
			fi
			sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
		fi
		LOC_Parm=$((LOC_Parm + (2+ 2*BETA) ))
		LOC_Val=$((LOC_Val + (2+ 2*BETA) ))
		linhaATOM
		Contagem_Atomo=$((Contagem_Atomo+1))
	done
	fullprof
		
}

function Parametro_Ocupacao2 () {
	linhaNat
	linhaNUMATOM
	linhaATOM
	AtomNumero=1
	while [ $AtomNumero -le $ColNat1 ] ; do
		PAR_OCC
		linhaATOM
		AtomNumero=$((AtomNumero +1+ 1*AtomIguais))
	done
}

function Parametro_Ocupacao1 () {
	OCC_MODE=1
	COND=1 # Entrou na Parte de Fazer Condições - Modo de saida Diferente dos Demais
	COND1=1 # Para evitar entrar no Passo quando o COND = 0!!
	linhaNat
	linhaNUMATOM
	linhaATOM
	AtomNumero=1
	while [ $AtomNumero -le $ColNat1 ] ; do
		I_COND_ENTRA=0 
		verifcdopagem
		linhaATOM
		if [[ $AtomIguais == 0 ]];then
			OCC_MIN=0.80
			OCC_MAX=1
			OCC_MAX_M=0
			OCC_MAX_Min=-20
		else
#			OCC_MAX=1.05
			OCC_MIN=0.8 #0.5
			OCC_MAX=1
			OCC_MAX_M=0
			OCC_MAX_Min=-50
		fi
		NomeFase
		MsgFunc3 "Ocupação"
		echo -e "\n\033[02;32mA Ocupação irá variar de $OCC_MAX_Min% a $OCC_MAX_M% num intervalo de 0.005.\033[0m\n"
#		for i in $(seq 0.95 0.005 $OCC_MAX)
		Cont_Linha=1
		Cont_Linha_Quebra=10
		for i in $(seq $OCC_MIN 0.005 $OCC_MAX)
		do
			Contagem_Atomo=0
			while [ $Contagem_Atomo -le $AtomIguais ] ; do
				linhaATOM
				if [[ $Contagem_Atomo == 0 ]]; then
					LINHA_Val=$(echo  $CalVal1 $CalVal2 $CalVal3  $CalVal4 $CalVal5 $CalVal6 $(echo "scale=5; $CalVal7*$i"  | bc ) $CalVal8 $CalVal9 $CalVal10 $CalVal11 )
					
					sed -i "$LOC_Val s/.*/$LINHA_Val/" $(echo $ArqNome).pcr
					Diff_Occ=$(echo "scale=5; $CalVal7 - $CalVal7*$i"  | bc )
				else
					LINHA_Val=$(echo  $CalVal1 $CalVal2 $CalVal3  $CalVal4 $CalVal5 $CalVal6 $(echo "scale=5; $CalVal7 + ($Diff_Occ/$AtomIguais)"  | bc ) $CalVal8 $CalVal9 $CalVal10 $CalVal11 )

					sed -i "$LOC_Val s/.*/$LINHA_Val/" $(echo $ArqNome).pcr
				fi

				LOC_Val=$((LOC_Val + (2+ 2*BETA) ))
				Contagem_Atomo=$((Contagem_Atomo+1))
			done
			fullprof
			if [[ $Cont_Linha == $Cont_Linha_Quebra ]];then #Somente para saltar uma linha na tela!!
				Cont_Linha_Quebra=$((Cont_Linha_Quebra+10))
				echo
			fi
			Cont_Linha=$((Cont_Linha+1))
			LOC_Val=$(echo $LOC_Val_Atom_inicial)
		done
		
		if [[ -f Cond.dat ]];then
			i=$(sort -g -k 2 Cond.dat | cut -f1 -d ";" | head -1)
			CHI=$(sort -g -k 2 Cond.dat | cut -f2 -d ";" | head -1)
			recuperecpCOND
			cpOK
			rm -f *-COND* Cond.dat
		fi
		linhaATOM
		echo -e "\n\n\033[02;32mMelhor Ocupação do Átomo $CalVal1 da fase $fase foi de: $CalVal7 com Chi² = \033[02;34;1m$CHI\033[02;32m.\033[0m\n\033[0m"
		COND=0
		#fullprof
		COND=1	
		LOC_Val=$((LOC_Val + (2+ 2*BETA)*(1+AtomIguais) ))
		linhaATOM
		AtomNumero=$((AtomNumero +1+ 1*AtomIguais))
	done
}

function Parametro_Ocupacao () {
	fase=1
	if [[ $Ocup_Mode == 1 ]];then
		linhaNUMATOM
		while [ $fase -le $ColJob3 ] ; do
			linhaNUMATOM
			Parametro_Ocupacao2
			fase=$((fase+1))
		done
	else
		linhaNUMATOM
		while [ $fase -le $ColJob3 ] ; do
			linhaNUMATOM
			Parametro_Ocupacao1
			fase=$((fase+1))
		done
		fi
	COND=0
	COND1=0
	OCC_MODE=0
}


################
# Strain_Model #
################

function Strain_Model13_1 () {
	nome="fase=$fase; Strain_Model13_1"
	NomeFase
	Parametro
	linha_Strain_Model13
	Vec_temp=$(echo $ColStrainP1 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc1 ${Strain_Mode_Nome[0]}
		else
			MsgPasso $conta_passo
		fi
		Linha_Parm_Strain=$(echo $(echo $PP) $ColStrainP2)
		sed -i "$LOC_Parm_Strain s/.*/$Linha_Parm_Strain/" $(echo $ArqNome).pcr
		fullprof
	fi
}

function Strain_Model13_2 () {
	nome="fase=$fase; Strain_Model13_2"
	NomeFase
	Parametro
	linha_Strain_Model13
	Vec_temp=$(echo $ColStrainP2 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc1 ${Strain_Mode_Nome[1]}
		else
			MsgPasso $conta_passo
		fi
		Linha_Parm_Strain=$(echo $ColStrainP1 $(echo $PP) )
		sed -i "$LOC_Parm_Strain s/.*/$Linha_Parm_Strain/" $(echo $ArqNome).pcr
		fullprof
	fi
}

function Strain_Model8_1 () {
	nome="fase=$fase; Strain_Model8_1"
	NomeFase
	Parametro
	linha_Strain_Model8
	Vec_temp=$(echo $ColStrainP1 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc1 ${Strain_Mode_Nome[0]}
		else
			MsgPasso $conta_passo
		fi
		Linha_Parm_Strain=$(echo $(echo $PP) $ColStrainP2 $ColStrainP3)
		sed -i "$LOC_Parm_Strain s/.*/$Linha_Parm_Strain/" $(echo $ArqNome).pcr
		fullprof
	fi
}

function Strain_Model8_2 () {
	nome="fase=$fase; Strain_Model8_2"
	NomeFase
	Parametro
	linha_Strain_Model8
	Vec_temp=$(echo $ColStrainP2 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc1 ${Strain_Mode_Nome[1]}
		else
			MsgPasso $conta_passo
		fi
		Linha_Parm_Strain=$(echo $ColStrainP1 $(echo $PP) $ColStrainP3)
		sed -i "$LOC_Parm_Strain s/.*/$Linha_Parm_Strain/" $(echo $ArqNome).pcr
		fullprof
	fi
}

function Strain_Model8_3 () {
	nome="fase=$fase; Strain_Model8_3"
	NomeFase
	Parametro
	linha_Strain_Model8
	Vec_temp=$(echo $ColStrainP3 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc1 ${Strain_Mode_Nome[2]}
		else
			MsgPasso $conta_passo
		fi
		Linha_Parm_Strain=$(echo  $ColStrainP1 $ColStrainP2 $(echo $PP))
		sed -i "$LOC_Parm_Strain s/.*/$Linha_Parm_Strain/" $(echo $ArqNome).pcr
		fullprof
	fi
}



function Strain_Model4_1 () {
	nome="fase=$fase; Strain_Model4_1"
	NomeFase
	Parametro
	linha_Strain_Model4
	Vec_temp=$(echo $ColStrainP1 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc1 ${Strain_Mode_Nome[0]}
		else
			MsgPasso $conta_passo
		fi
		Linha_Parm_Strain=$(echo $(echo $PP) $ColStrainP2 $ColStrainP3 $ColStrainP4)
		sed -i "$LOC_Parm_Strain s/.*/$Linha_Parm_Strain/" $(echo $ArqNome).pcr
		fullprof
	fi
}

function Strain_Model4_2 () {
	nome="fase=$fase; Strain_Model4_2"
	NomeFase
	Parametro
	linha_Strain_Model4
	Vec_temp=$(echo $ColStrainP2 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc1 ${Strain_Mode_Nome[1]}
		else
			MsgPasso $conta_passo
		fi
		Linha_Parm_Strain=$(echo $ColStrainP1 $(echo $PP) $ColStrainP3 $ColStrainP4)
		sed -i "$LOC_Parm_Strain s/.*/$Linha_Parm_Strain/" $(echo $ArqNome).pcr
		fullprof
	fi
}

function Strain_Model4_3 () {
	nome="fase=$fase; Strain_Model4_3"
	NomeFase
	Parametro
	linha_Strain_Model4
	Vec_temp=$(echo $ColStrainP3 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc1 ${Strain_Mode_Nome[2]}
		else
			MsgPasso $conta_passo
		fi
		Linha_Parm_Strain=$(echo  $ColStrainP1 $ColStrainP2 $(echo $PP)  $ColStrainP4)
		sed -i "$LOC_Parm_Strain s/.*/$Linha_Parm_Strain/" $(echo $ArqNome).pcr
		fullprof
	fi
}
function Strain_Model4_4 () {
	nome="fase=$fase; Strain_Model4_4"
	NomeFase
	Parametro
	linha_Strain_Model4
	Vec_temp=$(echo $ColStrainP4 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc1 ${Strain_Mode_Nome[3]}
		else
			MsgPasso $conta_passo
		fi
		Linha_Parm_Strain=$(echo  $ColStrainP1 $ColStrainP2 $ColStrainP3 $(echo $PP))
		sed -i "$LOC_Parm_Strain s/.*/$Linha_Parm_Strain/" $(echo $ArqNome).pcr
		fullprof
	fi
}


function Strain_Model3_1 () {
	nome="fase=$fase; Strain_Model3_1"
	NomeFase
	Parametro
	linha_Strain_Model3
	Vec_temp=$(echo $ColStrainP1 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc1 ${Strain_Mode_Nome[0]}
		else
			MsgPasso $conta_passo
		fi
		Linha_Parm_Strain=$(echo $(echo $PP) $ColStrainP2 $ColStrainP3 $ColStrainP4 $ColStrainP5 $ColStrainP6)
		sed -i "$LOC_Parm_Strain s/.*/$Linha_Parm_Strain/" $(echo $ArqNome).pcr
		fullprof
	fi
}

function Strain_Model3_2 () {
	nome="fase=$fase; Strain_Model3_2"
	NomeFase
	Parametro
	linha_Strain_Model3
	Vec_temp=$(echo $ColStrainP2 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc1 ${Strain_Mode_Nome[1]}
		else
			MsgPasso $conta_passo
		fi
		Linha_Parm_Strain=$(echo $ColStrainP1 $(echo $PP) $ColStrainP3 $ColStrainP4 $ColStrainP5 $ColStrainP6)
		sed -i "$LOC_Parm_Strain s/.*/$Linha_Parm_Strain/" $(echo $ArqNome).pcr
		fullprof
	fi
}

function Strain_Model3_3 () {
	nome="fase=$fase; Strain_Model3_3"
	NomeFase
	Parametro
	linha_Strain_Model3
	Vec_temp=$(echo $ColStrainP3 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc1 ${Strain_Mode_Nome[2]}
		else
			MsgPasso $conta_passo
		fi
		Linha_Parm_Strain=$(echo  $ColStrainP1 $ColStrainP2 $(echo $PP)  $ColStrainP4 $ColStrainP5 $ColStrainP6)
		sed -i "$LOC_Parm_Strain s/.*/$Linha_Parm_Strain/" $(echo $ArqNome).pcr
		fullprof
	fi
}
function Strain_Model3_4 () {
	nome="fase=$fase; Strain_Model3_4"
	NomeFase
	Parametro
	linha_Strain_Model3
	Vec_temp=$(echo $ColStrainP4 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc1 ${Strain_Mode_Nome[3]}
		else
			MsgPasso $conta_passo
		fi
		Linha_Parm_Strain=$(echo  $ColStrainP1 $ColStrainP2 $ColStrainP3 $(echo $PP)  $ColStrainP5 $ColStrainP6)
		sed -i "$LOC_Parm_Strain s/.*/$Linha_Parm_Strain/" $(echo $ArqNome).pcr
		fullprof
	fi
}
function Strain_Model3_5 () {
	nome="fase=$fase; Strain_Model3_5"
	NomeFase
	Parametro
	linha_Strain_Model3
	Vec_temp=$(echo $ColStrainP5 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc1 ${Strain_Mode_Nome[4]}
		else
			MsgPasso $conta_passo
		fi
		Linha_Parm_Strain=$(echo $ColStrainP1 $ColStrainP2 $ColStrainP3 $ColStrainP4 $(echo $PP)  $ColStrainP6)
		sed -i "$LOC_Parm_Strain s/.*/$Linha_Parm_Strain/" $(echo $ArqNome).pcr
		fullprof
	fi
}
function Strain_Model3_6 () {
	nome="fase=$fase; Strain_Model3_6"
	NomeFase
	Parametro
	linha_Strain_Model3
	Vec_temp=$(echo $ColStrainP6 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		if [[ $passo == 0 ]] ; then
			MsgFunc1 ${Strain_Mode_Nome[5]}
		else
			MsgPasso $conta_passo
		fi
		Linha_Parm_Strain=$(echo  $ColStrainP1 $ColStrainP2 $ColStrainP3 $ColStrainP4 $ColStrainP5 $(echo $PP) )
		sed -i "$LOC_Parm_Strain s/.*/$Linha_Parm_Strain/" $(echo $ArqNome).pcr
		fullprof
	fi
}

function STR1 () {
	nome="fase=$fase; STR1"
	NomeFase
	Parametro
	linhaSCALE
	if [[ $passo == 0 ]] ; then
			MsgFunc1 "Str1"
	else
		MsgPasso $conta_passo
	fi
	Vec_temp=$(echo $CalSCALEP4 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		LINHA_Parm_SCALE=$(echo  $CalSCALEP1 $CalSCALEP2 $CalSCALEP3  $(echo $PP)  $CalSCALEP5 $CalSCALEP6)
		sed -i "$LOC_Parm_SCALE s/.*/$LINHA_Parm_SCALE/" $(echo $ArqNome).pcr
	fi
	fullprof
}

function STR2 () {
	nome="fase=$fase; STR2"
	NomeFase
	Parametro
	linhaSCALE
	if [[ $passo == 0 ]] ; then
			MsgFunc1 "Str2"
	else
		MsgPasso $conta_passo
	fi
	Vec_temp=$(echo $CalSCALEP5 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		LINHA_Parm_SCALE=$(echo  $CalSCALEP1 $CalSCALEP2 $CalSCALEP3  $CalSCALEP4 $(echo $PP)  $CalSCALEP6)
		sed -i "$LOC_Parm_SCALE s/.*/$LINHA_Parm_SCALE/" $(echo $ArqNome).pcr
	fi
	fullprof
}

function STR3 () {
	nome="fase=$fase; STR3"
	NomeFase
	Parametro
	linhaSCALE
	if [[ $passo == 0 ]] ; then
			MsgFunc1 "Str3"
	else
		MsgPasso $conta_passo
	fi
	Vec_temp=$(echo $CalSCALEP6 | cut -f1 -d".")
	if [[ $Vec_temp == 0 ]] ; then
		LINHA_Parm_SCALE=$(echo  $CalSCALEP1 $CalSCALEP2 $CalSCALEP3  $CalSCALEP4  $CalSCALEP5 $(echo $PP))
		sed -i "$LOC_Parm_SCALE s/.*/$LINHA_Parm_SCALE/" $(echo $ArqNome).pcr
	fi
	fullprof
}

function Lorentzian_strain () {

	if [[ $ColNat14 == 7 ]];then
		nome="fase=$fase; Lorentzian_strain"
		NomeFase
		Parametro
		linha_Lorentzian_strain
		if [[ $passo == 0 ]] ; then
			MsgFunc1 "Lorentzian Strain"
		else
			MsgPasso $conta_passo
		fi
		Vec_temp=$(echo $ColStrain2 | cut -f1 -d".")
		if [[ $Vec_temp == 0 ]] ; then
			Linha_Val_Strain=$(echo  $ColStrain1 $(echo $PP))
			sed -i "$LOC_Val_Strain s/.*/$Linha_Val_Strain/" $(echo $ArqNome).pcr
		fi
		fullprof
	fi
}


function Strain_Model () {
	fase=1
	while [ $fase -le $ColJob3 ] ; do
		linhaNat
		if [[ $ColNat10 == 1 ]];then
			linhaSCALE
			case $CalVal7 in
				3)
					Strain_Model3_1
					Strain_Model3_2
					Strain_Model3_3
					Strain_Model3_4
					Strain_Model3_5
					Strain_Model3_6
					Lorentzian_strain
					;;
				4|5)
					Strain_Model4_1
					Strain_Model4_2
					Strain_Model4_3
					Strain_Model4_4
					Lorentzian_strain
				;;
				8|9|10|11|12)
					Strain_Model8_1
					Strain_Model8_2
					Strain_Model8_3
					Lorentzian_strain
				;;
				13|14)
					Strain_Model13_1
					Strain_Model13_2
					Lorentzian_strain
				;;
				*)
					echo -e "\033[01;31mModelo de Strain não implementado no Script.\033[0m"
				;;
			esac
		else
			echo -e "\033[01;31mOpção de Strain não Ativada!!\033[0m"
			echo -e "\033[02;32mVeja na pag. 119 do Manual do FullProf como implementar no arquivo $ArqNome.pcr.\033[0m\n"
		fi
		fase=$((fase +1))
	done
}

function paramSM1 () {
	nome="fase=$fase; paramSM1"
	NomeFase
	Parametro
	Linha_Size_Model
	Rodar $CalParam1 MsgFunc1 ${Nome_Parametro[0]} Parametro_1_6 Linha_Size_Model Parametro_0_6_1
}

function paramSM2 () {
	nome="fase=$fase; paramSM2"
	NomeFase
	Parametro
	Linha_Size_Model
	Rodar $CalParam2 MsgFunc1 ${Nome_Parametro[1]} Parametro_2_6 Linha_Size_Model Parametro_0_6_1
}
function paramSM3 () {
	nome="fase=$fase; paramSM3"
	NomeFase
	Parametro
	Linha_Size_Model
	Rodar $CalParam3 MsgFunc1 ${Nome_Parametro[2]} Parametro_3_6 Linha_Size_Model Parametro_0_6_1
}
function paramSM4 () {
	nome="fase=$fase; paramSM4"
	NomeFase
	Parametro
	Linha_Size_Model
	Rodar $CalParam4 MsgFunc1 ${Nome_Parametro[3]} Parametro_4_6 Linha_Size_Model Parametro_0_6_1
}
function paramSM5 () {
	nome="fase=$fase; paramSM5"
	NomeFase
	Parametro
	Linha_Size_Model
	Rodar $CalParam5 MsgFunc1 ${Nome_Parametro[4]} Parametro_5_6 Linha_Size_Model Parametro_0_6_1
}
function paramSM6 () {
	nome="fase=$fase; paramSM6"
	NomeFase
	Parametro
	Linha_Size_Model
	Rodar $CalParam6 MsgFunc1 ${Nome_Parametro[5]} Parametro_6_6 Linha_Size_Model Parametro_0_6_1
}

function paramSM7 () {
	nome="fase=$fase; paramSM7"
	NomeFase
	Parametro
	Linha_Size_Model_21
	Rodar $CalParam1 MsgFunc1 ${Nome_Parametro[0]} Parametro_1_2 Linha_Size_Model_21 Parametro_0_2
}

function paramSM8 () {
	nome="fase=$fase; paramSM8"
	NomeFase
	Parametro
	Linha_Size_Model_21
	Rodar $CalParam2 MsgFunc1 ${Nome_Parametro[1]} Parametro_2_2 Linha_Size_Model_21 Parametro_0_2
}

function paramSM1_17 () {
	nome="fase=$fase; paramSM1_17"
	NomeFase
	Parametro
	Linha_Size_Model_17
	Rodar $CalParam1 MsgFunc1 ${Nome_Parametro[0]} Parametro_1_5 Linha_Size_Model_17 Parametro_0_5
}

function paramSM2_17 () {
	nome="fase=$fase; paramSM2_17"
	NomeFase
	Parametro
	Linha_Size_Model_17
	Rodar $CalParam2 MsgFunc1 ${Nome_Parametro[1]} Parametro_2_5 Linha_Size_Model_17 Parametro_0_5
}

function paramSM3_17 () {
	nome="fase=$fase; paramSM3_17"
	NomeFase
	Parametro
	Linha_Size_Model_17
	Rodar $CalParam3 MsgFunc1 ${Nome_Parametro[2]} Parametro_3_5 Linha_Size_Model_17 Parametro_0_5
}

function paramSM4_17 () {
	nome="fase=$fase; paramSM4_17"
	NomeFase
	Parametro
	Linha_Size_Model_17
	Rodar $CalParam4 MsgFunc1 ${Nome_Parametro[3]} Parametro_4_5 Linha_Size_Model_17 Parametro_0_5
}

function paramSM5_17 () {
	nome="fase=$fase; paramSM5_17"
	NomeFase
	Parametro
	Linha_Size_Model_17
	Rodar $CalParam5 MsgFunc1 ${Nome_Parametro[4]} Parametro_5_5 Linha_Size_Model_17 Parametro_0_5
}

function Size_Model () {
	fase=1
	while [ $fase -le $ColJob3 ] ; do
		linhaUVW
		ModelSizeLaue=$(echo $CalVal8)
			case $ModelSizeLaue in
				0)
					echo -e "\033[01;31mSize Model não Ativado no PCR.\033[0m"
					echo -e "\033[02;32mVeja na pag. 117 do Manual do FullProf como implementar no arquivo $ArqNome.pcr.\033[0m\n"
				;;
				18)
					paramSM1
					paramSM2
					paramSM3
					paramSM4
					paramSM5
					paramSM6
				;;
				17)
					paramSM1_17
					paramSM2_17
					paramSM3_17
					paramSM4_17
					paramSM5_17
				;;
				21)
					paramSM1
					paramSM2
					paramSM3
					paramSM4
					paramSM5
					paramSM6
					paramSM7
					paramSM8
				;;
				*)
					echo -e "\033[01;31mSize Model não implementado no Script.\033[0m"
				;;
			esac
		fase=$((fase +1))
	done
}
#############################
# Finalizando o Refinamento #
#############################

function Exec_Erros (){

	Erro_Erro=0
	Verif_Chi_Valor1=0
	Vec_Shape_Val1=0
	ERRO_PASSO=0

	if	[[ -f Erro1.sh ]] ; then
		Erro_Vec=1 # Se 1 Significa que entrou para verificar os parametros que derão errados e tentar novamente!!
		sed '1i\#!/bin/bash\' Erro1.sh > Erro.sh
		echo -e "\033[02;31;1mREFAZENDO OS PARAMETROS QUE DERAM ERRADOS\033[0m"
		echo -e "\033[02;32mRefinando...\033[0m"
		fullprof
		if [[ $Verif_Chi_Valor1 == 0 && $Vec_Shape_Val1 == 0 && $Erro_Erro == 0 && $ERRO_PASSO == 0 ]]; then
			source Erro.sh
		else
			echo -e "\033[01;31mErro na Finalização !!\033[0m"
			cp Erro.sh Erro2.sh 
		fi
	fi
	Erro_Erro=0
	Verif_Chi_Valor1=0
	Vec_Shape_Val1=0
	ERRO_PASSO=0
	if	[[ -f Erro2.sh ]] ; then
		Erro_Vec=2 # Se 1 Significa que entrou para verificar os parametros que derão errados e tentar novamente!!
		sed '1i\#!/bin/bash\' Erro2.sh > Erro.sh
		echo -e "\033[02;31;1mREFAZENDO OS PARAMETROS QUE DERAM ERRADOS - AGORA BAIXANDO PASSO GLOBAL PARA 0.8 -\033[0m"
		echo
		# Número de Ciclos , R_at  R_an  R_pr  R_gl (Passos Atomicos, Anisotrópico, Profile e Global)
		linhaNCY
		LinhaNCY=$(echo "100 $ColNCY2 0.80 0.80 0.80 0.80 $ColNCY7 $ColNCY8 $ColNCY9 $ColNCY10 $ColNCY11")
		sed -i "$LOCNCY s/.*/$LinhaNCY/" $(echo $ArqNome).pcr
		linhaNCY 
		echo -e "\033[02;32mRefinando com o passo 0.8 - Antes de rodar os Paramentros que deram errado.\033[0m"
		fullprof
		if [[ $Verif_Chi_Valor1 == 0 && $Vec_Shape_Val1 == 0 && $Erro_Erro == 0 && $ERRO_PASSO == 0 ]]; then
			source Erro.sh
		else
			echo -e "\033[01;31mErro ao baixar o passo. Não será verificado os erros para o passo 0.8 !!\033[0m" 
			cp Erro2.sh Erro3.sh
		fi
	fi
	Erro_Erro=0
	Verif_Chi_Valor1=0
	Vec_Shape_Val1=0
	ERRO_PASSO=0

	if	[[ -f Erro3.sh ]] ; then
		Erro_Vec=3 # Se 1 Significa que entrou para verificar os parametros que derão errados e tentar novamente!!
		sed '1i\#!/bin/bash\' Erro3.sh > Erro.sh
		echo -e "\033[02;31;1mREFAZENDO OS PARAMETROS QUE DERAM ERRADOS - AGORA BAIXANDO PASSO GLOBAL PARA 0.5 -\033[0m"
		echo
		# Número de Ciclos , R_at  R_an  R_pr  R_gl (Passos Atomicos, Anisotrópico, Profile e Global)
		linhaNCY
		LinhaNCY=$(echo "100 $ColNCY2 0.50 0.50 0.50 0.50 $ColNCY7 $ColNCY8 $ColNCY9 $ColNCY10 $ColNCY11")
		sed -i "$LOCNCY s/.*/$LinhaNCY/" $(echo $ArqNome).pcr
		linhaNCY 
		echo -e "\033[02;32mRefinando com o passo 0.5 - Antes de rodar os Paramentros que deram errado.\033[0m"
		fullprof
		if [[ $Verif_Chi_Valor1 == 0 && $Vec_Shape_Val1 == 0 && $Erro_Erro == 0 && $ERRO_PASSO == 0  ]]; then
			source Erro.sh
		else
			echo -e "\033[01;31mErro ao baixar o passo. Não será verificado os erros para o passo 0.5 !!\033[0m" 
			cp Erro3.sh Erro4.sh
		fi
	fi
	rm -f Erro1.sh Erro2.sh Erro3.sh Erro.sh

	Erro_Erro=0
	Verif_Chi_Valor1=0
	Vec_Shape_Val1=0
	ERRO_PASSO=0
}

function Finalizando () {
	echo -e "\033[02;31;1mFINALIZANDO...\033[0m\n"
	FINALIZAR=1
	fullprof
#	fullprof
	linhaIpr
	LinhaIpr=$(echo "$ColIpr1 $ColIpr2 $ColIpr3 $ColIpr4 $ColIpr5 $ColIpr6 $ColIpr7 $ColIpr8 $ColIpr9 1 $ColIpr11 -1 1 1 4 1 $ColIpr17")
	sed -i "$LOCIpr s/.*/$LinhaIpr/" $(echo $ArqNome).pcr
	linhaIpr
	echo -e "\033[02;32mGerando os Arquivos: \n \033[02;34m\\u2623 $(echo $ArqNome).cif \n \\u2623 $(echo $ArqNome).prf \033[0m"
	fullprof
	source Size.sh
	# --- Fazendo os Arquivos Legiveis para Usuário Windows!! --- #
	unix2dos $(echo $ArqNome).pcr  &> /dev/null
	unix2dos $(echo $ArqNome).out  &> /dev/null
	
# --- Apagando Arquivos Desnecessários --- #
	rm -f *-OK* DRX.dat DRX.plt fase* graf_* int ang saida Passo.sh *prof.cif
}

