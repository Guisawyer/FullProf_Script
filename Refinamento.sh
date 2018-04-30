#!/bin/bash 
 
# Criado						: 2017/08/01 (Ver. 3.0)
# Ult. Atualização	: 2018/02/21
# Autor							: Guilherme <Guisawyer@yahoo.com.br>
# Notas							: Script para Rodar o Fullprof

shopt -s extglob # Para poder usar o comando rm !()
source Linhas.sh
Debug=0
ZeroPara=0
CaminhoScript=$( which Refinamento.sh | sed "s/\/Refinamento.sh//")

function Exist_Files () {
	if [[ ! -e $ArqNome.pcr || ! -e $ArqNome.dat ]]
	then
		echo "Não existe o arquivo $ArqNome.dat e/ou $ArqNome.pcr"
		echo -e "\033[01;31m Os dois arquivos devem ter o mesmo NOME!\033[0m"
		exit 1
	fi
}

function Tipo_Correto () {
	if [[ $Tipo != 1 && $Tipo != 4 && $Tipo != 6 ]];then
		echo -e "\n\033[33;1mO Tipo deve ser:\033[0m"
	  echo -e "\033[31;3m1 --> Método Rietveld\033[0m"
	  echo -e "\033[31;3m4 --> Método LeBail\033[0m"
	  echo -e "\033[31;3m6 --> Método LeBail + Rietveld\033[0m\n"
	  echo -e "\033[33;1mPara maiores informações Digite:\033[0m\n"
	  echo -e "\033[31;3mRefinamento.sh --help\033[0m\n"
		exit 2
	fi
}

function Criando_Files (){
	sed -i '/^$/d' $(echo $ArqNome).dat
	seq $(sed -n '1p' $(echo $ArqNome).dat) > ang
	sed -n "2,$ p"  $(echo $ArqNome).dat > int
	sed -i '/^$/d' int
	sed -i '/^$/d' ang
	paste ang int > DRX.dat
}

	case $# in
		1)
			case $1 in
			-l|--list)
					gedit $CaminhoScript/Lista.sh
					exit 0
		  ;;
			-h|--help)
					clear
					cat $CaminhoScript/Avisos
					exit 0
			;;
			-o|--ordem)
					gedit $CaminhoScript/Ordem.sh
					exit 0
			;;
			--listexec)
					chmod 744 $CaminhoScript/Lista.sh
					Lista.sh
					exit 0
			;;
			*)
				ArqNome=$(echo $1)
				Tipo=0
				Exist_Files
			;;
			esac
		;;
		2)
			ArqNome=$(echo $1)
			Tipo=$(echo $2)
			Exist_Files
			Tipo_Correto
		;;
		3)
			case $3 in
				-d|--debug)
				Debug=1
				ArqNome=$(echo $1)
				Tipo=$(echo $2)
				Exist_Files
				Tipo_Correto
		  ;;
		  	-z|--zero)
				ZeroPara=1
				ArqNome=$(echo $1)
				Tipo=$(echo $2)
				Exist_Files
				Tipo_Correto
		  ;;
		  *)
		  	clear 
				cat $CaminhoScript/Avisos
				exit 1
			;;
			esac

		;;
		4)
			ArqNome=$(echo $1)
			Tipo=$(echo $2)
			XRange_Min=$(echo $3)
			XRange_Max=$(echo $4)
			if [[ ! -z "${XRange_Min//[0-9.]}" || ! -z "${XRange_Max//[0-9.]}" ]]; then
				Criando_Files
				XRange_Max=$(echo "scale=2; $(sort -g -k 2 DRX.dat | tail -1 | gawk '{print $1}' ) + 1.1" | bc)
				XRange_Min=$(echo "scale=2; $(sort -g -k 2 DRX.dat | tail -1 | gawk '{print $1}' ) - 1.1" | bc)
			fi
			if [[ $(echo "scale=3; $XRange_Min >= $XRange_Max" | bc -l) -eq 1 ]];then
				if [[  $XRange_Min == $XRange_Max  ]];then
					Criando_Files
					XRange_Max=$(echo "scale=2; $(sort -g -k 2 DRX.dat | tail -1 | gawk '{print $1}' ) + 1.1" | bc)
					XRange_Min=$(echo "scale=2; $(sort -g -k 2 DRX.dat | tail -1 | gawk '{print $1}' ) - 1.1" | bc)
				else
					tempRange=$XRange_Min
					XRange_Min=$XRange_Max
					XRange_Max=$tempRange
				fi

			fi
			Exist_Files
			Tipo_Correto
		;;
		*)
			clear 
			cat $CaminhoScript/Avisos
			exit 1
		;;
	esac


	if [[ -e PCR-Bkp/$ArqNome.pcr  ]]
	then
		cp PCR-Bkp/$ArqNome.pcr .
	fi

#Verificar se o arquivo contem o caracter ^M e retirar!!
	cat $(echo $ArqNome).dat | tr -d "\r" > temporal.tmp 
	mv temporal.tmp $(echo $ArqNome).dat
	cat $(echo $ArqNome).pcr | tr -d "\r" > temporal.tmp
	mv temporal.tmp $(echo $ArqNome).pcr



###########################
# Salvando Nome das fases #
###########################
	
	function NomeFase (){
		temp_nome=$(grep -n "Nat " $(echo $ArqNome).pcr | cut -f1 -d":" | sed -n ${fase}p)
		temp_nome=$((temp_nome - 2))
		nome_fase1=$(sed -n ${temp_nome}p $(echo $ArqNome).pcr)
		nome_fase=$(sed -n ${temp_nome}p $(echo $ArqNome).pcr | sed "s/ //g" )
		sed -i "${temp_nome} s/$nome_fase1/$nome_fase/" $(echo $ArqNome).pcr
		
	}

	linhaJob
	fase=1
	while [ $fase -le $ColJob3 ] ; do
		NomeFase
		sed "1 s/.*/Verificando nome da Fase \"$nome_fase\"/" $(echo $ArqNome).pcr &> temp
		ERRO=$?
		rm temp
		if [[ $ERRO == 1 ]]; then
			echo -e "\033[01;31mMude o nome da fase $fase - Procure usar somente letras e Numeros SEM ESPAÇOS!!\033[0m"
			exit 1
		fi
			fase=$((fase +1))
		done
	fase=1


	mkdir -p PCR-Bkp
	cp $ArqNome.pcr PCR-Bkp
	echo "$ArqNome.pcr - Arquivo Original - Não sofreu nenhuma alteração do Script" > PCR-Bkp/README

  cp $CaminhoScript/DRX.plt .
	cp $CaminhoScript/Refinamento.plt .
	cp $CaminhoScript/Size.plt .
	Criando_Files

	if [[ $# -ne 4 ]];	then
		XRange_Max=$(echo "scale=2; $(sort -g -k 2 DRX.dat | tail -1 | gawk '{print $1}' ) + 1.1" | bc)
		XRange_Min=$(echo "scale=2; $(sort -g -k 2 DRX.dat | tail -1 | gawk '{print $1}' ) - 1.1" | bc)
	fi
	XRange_Min1=$(sed -n '1p' $ArqNome.dat | gawk '{print $1}'| cut -f1 -d . )
	XRange_Max1=$(sed -n '1p' $ArqNome.dat | gawk '{print $3}'| cut -f1 -d . ) 
	XTICS=$(echo "scale=2; ($XRange_Max-$XRange_Min)/2 " | bc )
	sed -i "16 s/set xtics.*/set xtics $XTICS in nomirror /" DRX.plt
	sed -i "15 s/set xrange.*/set xrange [$XRange_Min:$XRange_Max]/" DRX.plt
	sed -i "26 s/set xrange.*/set xrange [$XRange_Min1:$XRange_Max1]/" DRX.plt

# --- Gerando dados Iniciais para a Criação do Gráfico ---- FIM ---- #


# --- Parte das Escolhas que o Usuário Irá fazer --- INICIO --- #


Vec_Saida=0
	source Fullprof.sh
	Escolha=0
	while [ $Escolha == 0 ];do 
		clear
		if [ $Tipo -eq 0 ] ;then
		Tipo=$(dialog --backtitle "Script para Refinamento utilizando o FullProf. Versão 3.0" --stdout  --no-tags --ok-label Prosseguir --cancel-label Sair --radiolist "Selecione uma opção:" 0 0 0 \
				"1" "Refinar pelo Método Rietveld" on \
				"2" "Alterar a Ordem do Refinamento para o Método Rietveld" off \
				"3" "Verificar e/ou alterar o Zoom intervalo do Gráfico" off \
				"4" "Refinar pelo Método LeBail" off \
				"5" "Alterar a Ordem do Refinamento para o Método LeBail" off \
				"6" "Refinar pelo Método LeBail + Rietveld" off \
				"7" "Editar e Executar uma Lista" off \
			  )
			Vec_Saida=$(echo $?)
		fi
		
		if [ "$Vec_Saida" -eq "0" ]; then
			case $Tipo in
	
				1)
					clear
					T1=$(date +%s)
					source Rietveld.sh
					source Ordem.sh 
					T2=$(date +%s)
					diffsec="$(expr $T2 - $T1)"
					echo -e "\033[02;31;1mFinalizou no dia: $(LC_ALL=pt_BR.UTF-8 date "+%d de %B de %Y, às %H:%M:%S ")\033[0m"
					echo -e -n "\033[02;31;1mTempo de duração do Refinamento:" && echo |  awk -v D=$diffsec '{printf " %02d:%02d:%02d\n",D/(60*60),D%(60*60)/60,D%60}'
					exit 0
				;;
				2)
					gedit $CaminhoScript/Ordem.sh
					Tipo=0
					continue
				;;
				3)
					gnuplot -p -e "load 'DRX.plt'"
					OPCAO=$(dialog --backtitle "Script para Refinamento utilizando o FullProf. Versão 3.0" \
					               --title "Gráfico Zoom" --stdout --yes-label Sim  --no-label Não \
					               --yesno "Gostaria de Modificar o Zoom?" 5 33)
					if [ $? -eq 0 ]; then
						temp=$( echo $XRange_Min | cut -f1 -d . )
						XRange_Min=$(dialog --title "Intervalo Inicial" --stdout \
						                    --rangebox "Valor do Zoom Inical:"  0 0 $XRange_Min1 $((XRange_Max1 - 2)) $temp )
						XRange_Max=$(dialog --title "Intervalo Final"   --stdout  \
										            --rangebox "Valor do Zoom Final:"   0 0 $((XRange_Min+1))  $XRange_Max1 $((XRange_Min+1)) )
						sed -i "15 s/set xrange.*/set xrange [$XRange_Min:$XRange_Max]/" DRX.plt
						XTICS=$(echo "scale=2; ($XRange_Max-$XRange_Min)/2 " | bc )
						sed -i "16 s/set xtics.*/set xtics $XTICS in nomirror /" DRX.plt
					fi
					Tipo=0
					continue
				;;
				4)
					clear
					T1=$(date +%s)
					source LeBail.sh
					source Ordem2.sh 
					T2=$(date +%s)
					diffsec="$(expr $T2 - $T1)"
					echo -e "\033[02;31;1mFinalizou no dia: $(LC_ALL=pt_BR.UTF-8 date "+%d de %B de %Y, às %H:%M:%S ")\033[0m"
					echo -e -n "\033[02;31;1mTempo de duração do Refinamento:" && echo |  awk -v D=$diffsec '{printf " %02d:%02d:%02d\n",D/(60*60),D%(60*60)/60,D%60}'
					exit 0
				;;
				5)
					gedit $CaminhoScript/Ordem2.sh
					Tipo=0
					continue
				;;
				6)
					clear
					T1=$(date +%s)
          echo -e "\033[34;2m
          \t\t############################
          \t\t#                          #
          \t\t# Método LeBail + Rietveld #
          \t\t#                          #
          \t\t############################\033[0m\n" 
					source LeBail.sh
					source Ordem2.sh 
					source Lebail2Rietveld.sh
					source Rietveld.sh
					source Ordem.sh 
					T2=$(date +%s)
					diffsec="$(expr $T2 - $T1)"
					echo -e "\033[02;31;1mFinalizou no dia: $(LC_ALL=pt_BR.UTF-8 date "+%d de %B de %Y, às %H:%M:%S ")\033[0m"
					echo -e -n "\033[02;31;1mTempo de duração do Refinamento:" && echo |  awk -v D=$diffsec '{printf " %02d:%02d:%02d\n",D/(60*60),D%(60*60)/60,D%60}' 
					exit 0
				;;
				7)
					gedit $CaminhoScript/Lista.sh
					OPCAO=$(dialog --backtitle "Script para Refinamento utilizando o FullProf. Versão 3.0" \
					               --title "Lista" --stdout --yes-label Sim  --no-label Não \
					               --yesno "Gostaria de Executar a Lista?" 5 33)
					if [ $? -eq 0 ]; then
						chmod 744 $CaminhoScript/Lista.sh
						Lista.sh
						exit 0
					fi
					Tipo=0
					continue
				;;
			esac
		else
			rm -f ang DRX.dat DRX.plt int Refinamento.plt
			exit 0
		fi
	done
 
 
# --- Parte das Escolhas que o Usuário Irá fazer ---- FIM ---- #

