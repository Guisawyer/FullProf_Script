CaminhoScript=$( which Refinamento.sh | sed "s/\/Refinamento.sh//")
Num_List=1
Num_List_Total=$(grep "Refinar_Lista" $CaminhoScript/Lista.sh | wc -l)
Num_List_Total=$((Num_List_Total - 2))

function Refinar_Lista () {
	cd $Caminho_Arquivo
	Camin=$(pwd)
  echo -ne "\033]0; Executando Lista ($Num_List/$Num_List_Total) : $(echo $Camin)\007"
	Refinamento.sh $Nome_Arquivo $Tipo -z | tee Final
	Num_List=$((Num_List + 1))
}
Caminho_Geral=/home/guilherme/Documentos/Script


Caminho_Arquivo=$Caminho_Geral/1Fase
Nome_Arquivo=AFO
Tipo=1
ZooMMin=""
ZooMMax=""
Refinar_Lista

Caminho_Arquivo=$Caminho_Geral/2Fase
Nome_Arquivo=BTNN20_80
Tipo=1
ZooMMin=""
ZooMMax=""
Refinar_Lista

Caminho_Arquivo=$Caminho_Geral/Beta
Nome_Arquivo=29
Tipo=1
ZooMMin=""
ZooMMax=""
Refinar_Lista

Caminho_Arquivo=$Caminho_Geral/Padrao
Nome_Arquivo=Si
Tipo=1
ZooMMin=""
ZooMMax=""
Refinar_Lista


Caminho_Arquivo=$Caminho_Geral/Strain
Nome_Arquivo=BTNN20_80
Tipo=1
ZooMMin=""
ZooMMax=""
Refinar_Lista

