			#############################
			##                         ## 
			##  Linhas dos Parametros  ##
			##                         ##
			#############################

function linhaJob (){
	# !Job Npr Nph Nba Nex Nsc Nor Dum Iwg Ilo Ias Res Ste Nre Cry Uni Cor Opt Aut
	LOCJob=$(grep -n "Job " $(echo $ArqNome).pcr | cut -f1 -d":")
	LOCJob=$((LOCJob + 1))

	LinhaJob=$(sed -n ${LOCJob}p $(echo $ArqNome).pcr ) 
	ColJob1=$(echo $LinhaJob | cut -f1 -d" ") #Job
	ColJob2=$(echo $LinhaJob | cut -f2 -d" ") #Npr
	ColJob3=$(echo $LinhaJob | cut -f3 -d" ") #Nph
	ColJob4=$(echo $LinhaJob | cut -f4 -d" ") #Nba
	ColJob5=$(echo $LinhaJob | cut -f5 -d" ") #Nex
	ColJob6=$(echo $LinhaJob | cut -f6 -d" ") #Nsc
	ColJob7=$(echo $LinhaJob | cut -f7 -d" ") #Nor
	ColJob8=$(echo $LinhaJob | cut -f8 -d" ") #Dum
	ColJob9=$(echo $LinhaJob | cut -f9 -d" ") #Iwg
	ColJob10=$(echo $LinhaJob | cut -f10 -d" ") #Ilo
	ColJob11=$(echo $LinhaJob | cut -f11 -d" ") #Ias
	ColJob12=$(echo $LinhaJob | cut -f12 -d" ") #Res
	ColJob13=$(echo $LinhaJob | cut -f13 -d" ") #Ste
	ColJob14=$(echo $LinhaJob | cut -f14 -d" ") #Nre
	ColJob15=$(echo $LinhaJob | cut -f15 -d" ") #Cry
	ColJob16=$(echo $LinhaJob | cut -f16 -d" ") #Uni
	ColJob17=$(echo $LinhaJob | cut -f17 -d" ") #Cor
	ColJob18=$(echo $LinhaJob | cut -f18 -d" ") #Opt
	ColJob19=$(echo $LinhaJob | cut -f19 -d" ") #Aut
}

function linhaIpr () {
	#!Ipr Ppl Ioc Mat Pcr Ls1 Ls2 Ls3 NLI Prf Ins Rpa Sym Hkl Fou Sho Ana
	LOCIpr=$(grep -n "Ipr " $(echo $ArqNome).pcr | cut -f1 -d":")
	LOCIpr=$((LOCIpr + 1))
	
	LinhaIpr=$(sed -n ${LOCIpr}p $(echo $ArqNome).pcr )
	ColIpr1=$(echo $LinhaIpr | cut -f1 -d" ") # Ipr
	ColIpr2=$(echo $LinhaIpr | cut -f2 -d" ") # Ppl
	ColIpr3=$(echo $LinhaIpr | cut -f3 -d" ") # Ioc
	ColIpr4=$(echo $LinhaIpr | cut -f4 -d" ") # Mat
	ColIpr5=$(echo $LinhaIpr | cut -f5 -d" ") # Pcr
	ColIpr6=$(echo $LinhaIpr | cut -f6 -d" ") # Ls1
	ColIpr7=$(echo $LinhaIpr | cut -f7 -d" ") # Ls2
	ColIpr8=$(echo $LinhaIpr | cut -f8 -d" ") # Ls3
	ColIpr9=$(echo $LinhaIpr | cut -f9 -d" ") # NLI
	ColIpr10=$(echo $LinhaIpr | cut -f10 -d" ") # Prf
	ColIpr11=$(echo $LinhaIpr | cut -f11 -d" ") # Ins
	ColIpr12=$(echo $LinhaIpr | cut -f12 -d" ") # Rpa
	ColIpr13=$(echo $LinhaIpr | cut -f13 -d" ") # Sym
	ColIpr14=$(echo $LinhaIpr | cut -f14 -d" ") # Hkl
	ColIpr15=$(echo $LinhaIpr | cut -f15 -d" ") # Fou	
	ColIpr16=$(echo $LinhaIpr | cut -f16 -d" ") # Sho	
	ColIpr17=$(echo $LinhaIpr | cut -f17 -d" ") # Ana
}

function linhaNCY () {
	#!NCY  Eps  R_at  R_an  R_pr  R_gl     Thmin       Step       Thmax    PSD    Sent0
	LOCNCY=$(grep -n "NCY" $(echo $ArqNome).pcr | cut -f1 -d":")
	LOCNCY=$((LOCNCY + 1))

	LinhaNCY=$(sed -n ${LOCNCY}p $(echo $ArqNome).pcr)
	ColNCY1=$(echo $LinhaNCY | cut -f1 -d" ") # NCY
	ColNCY2=$(echo $LinhaNCY | cut -f2 -d" ") # Eps
	ColNCY3=$(echo $LinhaNCY | cut -f3 -d" ") # R_at
	ColNCY4=$(echo $LinhaNCY | cut -f4 -d" ") # R_an
	ColNCY5=$(echo $LinhaNCY | cut -f5 -d" ") # R_pr
	ColNCY6=$(echo $LinhaNCY | cut -f6 -d" ") # R_gl
	ColNCY7=$(echo $LinhaNCY | cut -f7 -d" ") # Thmin
	ColNCY8=$(echo $LinhaNCY | cut -f8 -d" ") # Step
	ColNCY9=$(echo $LinhaNCY | cut -f9 -d" ") # Thmax
	ColNCY10=$(echo $LinhaNCY | cut -f10 -d" ") # PSD
	ColNCY11=$(echo $LinhaNCY | cut -f11 -d" ") # Sent0
}

function linhaNat (){
	#!Nat Dis Ang Pr1 Pr2 Pr3 Jbt Irf Isy Str Furth       ATZ    Nvk Npr More
	LOCNat=$(grep -n "Nat " $(echo $ArqNome).pcr | cut -f1 -d":" | sed -n ${fase}p )
	LOCNat=$((LOCNat + 1))

	LinhaNat=$(sed -n ${LOCNat}p $(echo $ArqNome).pcr ) 
	ColNat1=$(echo $LinhaNat | cut -f1 -d" ") #Nat
	ColNat2=$(echo $LinhaNat | cut -f2 -d" ") #Dis
	ColNat3=$(echo $LinhaNat | cut -f3 -d" ") #Ang
	ColNat4=$(echo $LinhaNat | cut -f4 -d" ") #Pr1
	ColNat5=$(echo $LinhaNat | cut -f5 -d" ") #Pr2
	ColNat6=$(echo $LinhaNat | cut -f6 -d" ") #Pr3
	ColNat7=$(echo $LinhaNat | cut -f7 -d" ") #Jbt
	ColNat8=$(echo $LinhaNat | cut -f8 -d" ") #Irf
	ColNat9=$(echo $LinhaNat | cut -f9 -d" ") #Isy
	ColNat10=$(echo $LinhaNat | cut -f10 -d" ") #Str
	ColNat11=$(echo $LinhaNat | cut -f11 -d" ") #Furth
	ColNat12=$(echo $LinhaNat | cut -f12 -d" ") #ATZ
	ColNat13=$(echo $LinhaNat | cut -f13 -d" ") #Nvk
	ColNat14=$(echo $LinhaNat | cut -f14 -d" ") #Npr
	ColNat15=$(echo $LinhaNat | cut -f15 -d" ") #More
}

function VEC_linhaNat (){
	#!Nat Dis Ang Pr1 Pr2 Pr3 Jbt Irf Isy Str Furth       ATZ    Nvk Npr More
	VEC_LOCNat=$(grep -n "Nat " $(echo $ArqNome).pcr | cut -f1 -d":" | sed -n ${fase}p )
	VEC_LOCNat=$((VEC_LOCNat + 1))

	VEC_LinhaNat=$(sed -n ${VEC_LOCNat}p $(echo $ArqNome).pcr ) 
	VEC_ColNat1=$(echo $VEC_LinhaNat | cut -f1 -d" ") #Nat

}


function Val (){
	LINHA_Val=$(sed -n ${LOC_Val}p $(echo $ArqNome).pcr)
	CalVal1=$(echo $LINHA_Val | cut -f1 -d" ")
	CalVal2=$(echo $LINHA_Val | cut -f2 -d" ")	 
	CalVal3=$(echo $LINHA_Val | cut -f3 -d" ")	 
	CalVal4=$(echo $LINHA_Val | cut -f4 -d" ")	  
	CalVal5=$(echo $LINHA_Val | cut -f5 -d" ")	
	CalVal6=$(echo $LINHA_Val | cut -f6 -d" ")	
	CalVal7=$(echo $LINHA_Val | cut -f7 -d" ")
	CalVal8=$(echo $LINHA_Val | cut -f8 -d" ")
	CalVal9=$(echo $LINHA_Val | cut -f9 -d" ")
	CalVal10=$(echo $LINHA_Val | cut -f10 -d" ")
	CalVal11=$(echo $LINHA_Val | cut -f11 -d" ")
}

function Param (){
	LINHA_Parm=$(sed -n ${LOC_Parm}p $(echo $ArqNome).pcr)
	CalParam1=$(echo $LINHA_Parm | cut -f1 -d" ")  
	CalParam2=$(echo $LINHA_Parm | cut -f2 -d" ")  
	CalParam3=$(echo $LINHA_Parm | cut -f3 -d" ")  
	CalParam4=$(echo $LINHA_Parm | cut -f4 -d" ") 
	CalParam5=$(echo $LINHA_Parm | cut -f5 -d" ")  
	CalParam6=$(echo $LINHA_Parm | cut -f6 -d" ") 
	CalParam7=$(echo $LINHA_Parm | cut -f7 -d" ")  
	CalParam8=$(echo $LINHA_Parm | cut -f8 -d" ")  
	CalParam9=$(echo $LINHA_Parm | cut -f9 -d" ")  
	CalParam10=$(echo $LINHA_Parm | cut -f10 -d" ")  
	CalParam11=$(echo $LINHA_Parm | cut -f11 -d" ")  
}

function linhaZERO () {
	Nome_Parametro=(Zero Code SyCos Code SySin Code Lambda Code MORE)
	LOC=$(grep -n "!  Zero" $(echo $ArqNome).pcr | cut -f1 -d":")
	LOC_Val=$((LOC + 1))
	Val
}

function linhaSCALE (){
	Nome_Parametro=(Scale Shape1 Bov Str1 Str2 Str3 Strain-Model)
	LOC=$(grep -n "!  Scale" $(echo $ArqNome).pcr | cut -f1 -d":" | sed -n ${fase}p )
	LOC_Val=$((LOC + 1))
	LOC_Parm=$((LOC + 2))
	Val
	Param
}

function linhaUVW (){
	Nome_Parametro=(U V W X Y GauSiz LorSiz Size-Model)
	LOC=$(grep -n "!       U " $(echo $ArqNome).pcr | cut -f1 -d":" | sed -n ${fase}p )
	LOC_Val=$((LOC + 1))
	LOC_Parm=$((LOC + 2))
	Val
	Param
}

function Linha_Size_Model (){
	Nome_Parametro=($(grep Y00 $ArqNome.pcr | cut -f2 -d"!"))
	LOC=$(grep -n "Y00" $(echo $ArqNome).pcr | cut -f1 -d":" | sed -n ${fase}p )
	LOC_Val=$((LOC + 1))
	LOC_Parm=$((LOC + 2))
	Val
	Param
}

function Linha_Size_Model_21 (){
	Nome_Parametro=($(grep Y64 $ArqNome.pcr | cut -f2 -d"!"))
	LOC=$(grep -n "Y64" $(echo $ArqNome).pcr | cut -f1 -d":" | sed -n ${fase}p )
	LOC_Val=$((LOC + 1))
	LOC_Parm=$((LOC + 2))
	Val
	Param
}


function Linha_Size_Model_17 (){
	Nome_Parametro=($(grep K00 $ArqNome.pcr | cut -f2 -d"!"))
	VecLocM=$(grep -n "K00" $(echo $ArqNome).pcr | cut -f1 -d":" | wc -l )
	if [[ $VecLocM == $ColJob3 ]] ; then
		LOC=$(grep -n "K00" $(echo $ArqNome).pcr | cut -f1 -d":" | sed -n ${fase}p )
	else
		LOC=$(grep -n "K00" $(echo $ArqNome).pcr | cut -f1 -d":" | sed -n ${VecLocM}p )
	fi
	LOC_Val=$((LOC + 1))
	LOC_Parm=$((LOC + 2))
	Val
	Param
}

function linhaABC () {
	Nome_Parametro=(a b c alpha beta gamma)
	LOC=$(grep -n "!     a " $(echo $ArqNome).pcr | cut -f1 -d":" | sed -n ${fase}p )
	LOC_Val=$((LOC + 1))
	LOC_Parm=$((LOC + 2))
	Val
	Param
}

function linhaPREF () {
	Nome_Parametro=(Pref1 Pref2 Asy1 Asy2 Asy3 Asy4 S_L D_L) 
	LOC=$(grep -n "!  Pref1" $(echo $ArqNome).pcr | cut -f1 -d":" | sed -n ${fase}p )
	LOC_Val=$((LOC + 1))
	LOC_Parm=$((LOC + 2))
	Val
	Param
}


function linhaNUMATOM () {
	Nome_Parametro=(X Y Z Biso Occ)
	LOC=$(grep -n "Atom   " $(echo $ArqNome).pcr | cut -f1 -d":" | sed -n ${fase}p )
	LOC_Val=$((LOC + 1))
	if [[ -n $(sed -n ${LOC_Val}p $ArqNome.pcr | grep beta11 ) ]]; then
		LOC_Parm=$((LOC + 3))
		LOC_Val=$((LOC + 2))
		LOC_Val_BETA=$((LOC + 4))
		LOC_Parm_BETA=$((LOC + 5))
		BETA=1 # Verdade
	else
		LOC_Parm=$((LOC + 2))
		LOC_Val=$((LOC + 1))
		BETA=0 # Falso
	fi
	LOC2=$(grep -n "Profile Parameters" $(echo $ArqNome).pcr | cut -f1 -d":" | sed -n ${fase}p )
	LOC_Val_ATOM2=$((LOC2 - 1))
}

function linhaATOM (){
	Nome_Parametro=(X Y Z Biso Occ)
	Val
	Param
}

function linhaBETA (){
	LINHA_Val_BETA=$(sed -n ${LOC_Val_BETA}p $(echo $ArqNome).pcr)
	ColBETA1=$(echo $LINHA_Val_BETA | cut -f1 -d" ") # beta11
	ColBETA2=$(echo $LINHA_Val_BETA | cut -f2 -d" ") # beta22
	ColBETA3=$(echo $LINHA_Val_BETA | cut -f3 -d" ") # beta33
	ColBETA4=$(echo $LINHA_Val_BETA | cut -f4 -d" ") # beta12
	ColBETA5=$(echo $LINHA_Val_BETA | cut -f5 -d" ") # beta13
	ColBETA6=$(echo $LINHA_Val_BETA | cut -f6 -d" ") # beta23

	LINHA_Parm_BETA=$(sed -n ${LOC_Parm_BETA}p $(echo $ArqNome).pcr)
	ColBETAP1=$(echo $LINHA_Parm_BETA | cut -f1 -d" ") # X
	ColBETAP2=$(echo $LINHA_Parm_BETA | cut -f2 -d" ") # Y
	ColBETAP3=$(echo $LINHA_Parm_BETA | cut -f3 -d" ") # Z
	ColBETAP4=$(echo $LINHA_Parm_BETA | cut -f4 -d" ") # Biso
	ColBETAP5=$(echo $LINHA_Parm_BETA | cut -f5 -d" ") # Occ
	ColBETAP6=$(echo $LINHA_Parm_BETA | cut -f5 -d" ") # Occ
}



function VEC_linhaNUMATOM () {
	#!Atom   Typ       X        Y        Z     Biso       Occ     In Fin N_t Spc /Codes
	VEC_LOC=$(grep -n "Atom   " $(echo $ArqNome).pcr | cut -f1 -d":" | sed -n ${fase}p )
	VEC_LOC_Val_ATOM=$((VEC_LOC + 1))
	if [[ -n $(sed -n ${VEC_LOC_Val_ATOM}p $ArqNome.pcr | grep beta11 ) ]]; then
		VEC_LOC_Parm_Atom=$((VEC_LOC + 3))
		VEC_LOC_Val_Atom=$((VEC_LOC + 2))
		VEC_BETA=1 # Verdade
	else
		VEC_LOC_Parm_Atom=$((VEC_LOC + 2))
		VEC_LOC_Val_Atom=$((VEC_LOC + 1))
		VEC_BETA=0 # Falso
	fi
}

function VEC_linhaATOM (){
	VEC_LINHA_Val_Atom=$(sed -n ${VEC_LOC_Val_Atom}p $ArqNome.pcr)
	VEC_ColAtom3=$(echo $VEC_LINHA_Val_Atom | cut -f3 -d" ") # X	
	VEC_ColAtom4=$(echo $VEC_LINHA_Val_Atom | cut -f4 -d" ") # Y
	VEC_ColAtom5=$(echo $VEC_LINHA_Val_Atom | cut -f5 -d" ") # Z
	VEC_ColAtom6=$(echo $VEC_LINHA_Val_Atom | cut -f6 -d" ") # Biso
	VEC_ColAtom7=$(echo $VEC_LINHA_Val_Atom | cut -f7 -d" ") # Occ
}




function linhaBackcoef () {
	LOC=$(grep -n "!   Background coefficients" $(echo $ArqNome).pcr | cut -f1 -d":" )
	LOC_Parm=$((LOC + 2))
	Param
}

function linha_Strain_Model13 () {
	#!       S_400          S_220
	LOC=$(grep -n "S_400 " $(echo $ArqNome).pcr | cut -f1 -d":" | sed -n ${fase}p )
	LOC_Val_Strain=$((LOC + 1))
	LOC_Parm_Strain=$((LOC + 2))
	Strain_Mode_Nome=(S_400 S_220)
	Linha_Val_Strain=$(sed -n ${LOC_Val_Strain}p $(echo $ArqNome).pcr)
	ColStrain1=$(echo $Linha_Val_Strain | cut -f1 -d" ") # S_400
	ColStrain2=$(echo $Linha_Val_Strain | cut -f2 -d" ") # S_004 

	Linha_Parm_Strain=$(sed -n ${LOC_Parm_Strain}p $(echo $ArqNome).pcr)
	ColStrainP1=$(echo $Linha_Parm_Strain | cut -f1 -d" ") # S_400
	ColStrainP2=$(echo $Linha_Parm_Strain | cut -f2 -d" ") # S_004
}



function linha_Strain_Model8 () {
	#!       S_400         S_004         S_112
	LOC=$(grep -n "S_400 " $(echo $ArqNome).pcr | cut -f1 -d":" | sed -n ${fase}p )
	LOC_Val_Strain=$((LOC + 1))
	LOC_Parm_Strain=$((LOC + 2))
	Strain_Mode_Nome=(S_400 S_004 S_112)
	Linha_Val_Strain=$(sed -n ${LOC_Val_Strain}p $(echo $ArqNome).pcr)
	ColStrain1=$(echo $Linha_Val_Strain | cut -f1 -d" ") # S_400
	ColStrain2=$(echo $Linha_Val_Strain | cut -f2 -d" ") # S_004 
	ColStrain3=$(echo $Linha_Val_Strain | cut -f3 -d" ") # S_112

	Linha_Parm_Strain=$(sed -n ${LOC_Parm_Strain}p $(echo $ArqNome).pcr)
	ColStrainP1=$(echo $Linha_Parm_Strain | cut -f1 -d" ") # S_400
	ColStrainP2=$(echo $Linha_Parm_Strain | cut -f2 -d" ") # S_004
	ColStrainP3=$(echo $Linha_Parm_Strain | cut -f3 -d" ") # S_112
}

function linha_Strain_Model3 () {
	#!      S_400        S_040        S_004        S_220        S_202        S_022
	LOC=$(grep -n "S_400 " $(echo $ArqNome).pcr | cut -f1 -d":" | sed -n ${fase}p )
	LOC_Val_Strain=$((LOC + 1))
	LOC_Parm_Strain=$((LOC + 2))
	Strain_Mode_Nome=(S_400 S_040 S_004 S_220 S_202 S_022)
	Linha_Val_Strain=$(sed -n ${LOC_Val_Strain}p $(echo $ArqNome).pcr)
	ColStrain1=$(echo $Linha_Val_Strain | cut -f1 -d" ") # S_400
	ColStrain2=$(echo $Linha_Val_Strain | cut -f2 -d" ") # S_040 
	ColStrain3=$(echo $Linha_Val_Strain | cut -f3 -d" ") # S_004
	ColStrain4=$(echo $Linha_Val_Strain | cut -f4 -d" ") # S_220
	ColStrain5=$(echo $Linha_Val_Strain | cut -f5 -d" ") # S_202
	ColStrain6=$(echo $Linha_Val_Strain | cut -f6 -d" ") # S_022

	Linha_Parm_Strain=$(sed -n ${LOC_Parm_Strain}p $(echo $ArqNome).pcr)
	ColStrainP1=$(echo $Linha_Parm_Strain | cut -f1 -d" ") # S_400
	ColStrainP2=$(echo $Linha_Parm_Strain | cut -f2 -d" ") # S_040
	ColStrainP3=$(echo $Linha_Parm_Strain | cut -f3 -d" ") # S_004
	ColStrainP4=$(echo $Linha_Parm_Strain | cut -f4 -d" ") # S_220
	ColStrainP5=$(echo $Linha_Parm_Strain | cut -f5 -d" ") # S_202
	ColStrainP6=$(echo $Linha_Parm_Strain | cut -f6 -d" ") # S_022
}

function linha_Lorentzian_strain () {
#!  Lorentzian strain coeff.+ code 
	LOC=$(grep -n "Lorentzian strain" $(echo $ArqNome).pcr | cut -f1 -d":" | sed -n ${fase}p )
	LOC_Val_Strain=$((LOC + 1))

	Linha_Val_Strain=$(sed -n ${LOC_Val_Strain}p $(echo $ArqNome).pcr)
	ColStrain1=$(echo $Linha_Val_Strain | cut -f1 -d" ") # S_400
	ColStrain2=$(echo $Linha_Val_Strain | cut -f2 -d" ") # S_040 
}


function linha_Strain_Model4 () {
	#!      S_400        S_004        S_220        S_202        
	LOC=$(grep -n "S_400 " $(echo $ArqNome).pcr | cut -f1 -d":" | sed -n ${fase}p )
	LOC_Val_Strain=$((LOC + 1))
	LOC_Parm_Strain=$((LOC + 2))
	Strain_Mode_Nome=(S_400 S_004 S_220 S_202)
	Linha_Val_Strain=$(sed -n ${LOC_Val_Strain}p $(echo $ArqNome).pcr)
	ColStrain1=$(echo $Linha_Val_Strain | cut -f1 -d" ") # S_400
	ColStrain2=$(echo $Linha_Val_Strain | cut -f2 -d" ") # S_004 
	ColStrain3=$(echo $Linha_Val_Strain | cut -f3 -d" ") # S_220
	ColStrain4=$(echo $Linha_Val_Strain | cut -f4 -d" ") # S_202

	Linha_Parm_Strain=$(sed -n ${LOC_Parm_Strain}p $(echo $ArqNome).pcr)
	ColStrainP1=$(echo $Linha_Parm_Strain | cut -f1 -d" ") # S_400
	ColStrainP2=$(echo $Linha_Parm_Strain | cut -f2 -d" ") # S_004
	ColStrainP3=$(echo $Linha_Parm_Strain | cut -f3 -d" ") # S_220
	ColStrainP4=$(echo $Linha_Parm_Strain | cut -f4 -d" ") # S_202

}

function Parametro_0_2 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo 0.00  0.00 )
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_1_2 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $(echo $PP) $CalParam2 )
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_2_2 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $CalParam1 $(echo $PP) )
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}


function Parametro_0_5 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo 0.00  0.00  0.00  0.00  0.00 )
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_1_5 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $(echo $PP) $CalParam2 $CalParam3 $CalParam4 $CalParam5)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}


function Parametro_2_5 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $CalParam1 $(echo $PP) $CalParam3 $CalParam4 $CalParam5)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}
function Parametro_3_5 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $CalParam1 $CalParam2 $(echo $PP) $CalParam4 $CalParam5)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}
function Parametro_4_5 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $CalParam1 $CalParam2 $CalParam3 $(echo $PP) $CalParam5)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}
function Parametro_5_5 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $CalParam1 $CalParam2 $CalParam3 $CalParam4 $(echo $PP))
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_0_6 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $CalParam1  0.00  0.00  0.00  0.00  0.00 )
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}
function Parametro_0_6_1 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo 0.00  0.00  0.00  0.00  0.00  0.00 )
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_1_6 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $(echo $PP) $CalParam2 $CalParam3 $CalParam4 $CalParam5 $CalParam6)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_2_6 (){ 
	LINHA_Parm=$(echo $CalParam1 $(echo $PP) $CalParam3 $CalParam4 $CalParam5 $CalParam6)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_3_6 (){ 
	LINHA_Parm=$(echo $CalParam1 $CalParam2 $(echo $PP) $CalParam4 $CalParam5 $CalParam6)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_4_6 (){ 
	LINHA_Parm=$(echo $CalParam1 $CalParam2 $CalParam3 $(echo $PP) $CalParam5 $CalParam6)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_5_6 (){ 
	LINHA_Parm=$(echo $CalParam1 $CalParam2 $CalParam3 $CalParam4 $(echo $PP) $CalParam6)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_6_6 (){ 
	LINHA_Parm=$(echo $CalParam1 $CalParam2 $CalParam3 $CalParam4 $CalParam5 $(echo $PP))
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_0_7 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo 0.00  0.00  0.00  0.00  0.00  0.00 0.00 )
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_0_7_1 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo 0.00  0.00  0.00  $CalParam4 $CalParam5 $CalParam6 $CalParam7 )
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_1_7 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $(echo $PP) $CalParam2 $CalParam3 $CalParam4 $CalParam5 $CalParam6 $CalParam7)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_2_7 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $CalParam1 $(echo $PP) $CalParam3 $CalParam4 $CalParam5 $CalParam6 $CalParam7)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_3_7 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $CalParam1 $CalParam2 $(echo $PP) $CalParam4 $CalParam5 $CalParam6 $CalParam7)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_4_7 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $CalParam1 $CalParam2 $CalParam3 $(echo $PP) $CalParam5 $CalParam6 $CalParam7)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_5_7 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $CalParam1 $CalParam2 $CalParam3 $CalParam4 $(echo $PP) $CalParam6 $CalParam7)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_6_7 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $CalParam1 $CalParam2 $CalParam3 $CalParam4 $CalParam5 $(echo $PP) $CalParam7)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_7_7 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $CalParam1 $CalParam2 $CalParam3 $CalParam4 $CalParam5 $CalParam6 $(echo $PP))
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_0_8 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo 0.00  0.00  0.00  0.00  0.00  0.00 0.00 0.00 )
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_1_8 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $(echo $PP) $CalParam2 $CalParam3 $CalParam4 $CalParam5 $CalParam6 $CalParam7 $CalParam8)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}
function Parametro_2_8 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $CalParam1 $(echo $PP) $CalParam3 $CalParam4 $CalParam5 $CalParam6 $CalParam7 $CalParam8)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}
function Parametro_3_8 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $CalParam1 $CalParam2 $(echo $PP) $CalParam4 $CalParam5 $CalParam6 $CalParam7 $CalParam8)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}
function Parametro_4_8 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $CalParam1 $CalParam2 $CalParam3 $(echo $PP) $CalParam5 $CalParam6 $CalParam7 $CalParam8)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}
function Parametro_5_8 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $CalParam1 $CalParam2 $CalParam3 $CalParam4 $(echo $PP) $CalParam6 $CalParam7 $CalParam8)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}
function Parametro_6_8 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $CalParam1 $CalParam2 $CalParam3 $CalParam4 $CalParam5 $(echo $PP) $CalParam7 $CalParam8)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}
function Parametro_7_8 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $CalParam1 $CalParam2 $CalParam3 $CalParam4 $CalParam5 $CalParam6 $(echo $PP) $CalParam8)
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}
function Parametro_8_8 (){ # Primeiro Parâmetro de 6
	LINHA_Parm=$(echo $CalParam1 $CalParam2 $CalParam3 $CalParam4 $CalParam5 $CalParam6 $CalParam7 $(echo $PP))
	sed -i "$LOC_Parm s/.*/$LINHA_Parm/" $(echo $ArqNome).pcr
}

function Parametro_0_9 (){ # Primeiro Parâmetro de 6
	LINHA_Val=$(echo $CalVal1 0.00 $CalVal3 0.00 $CalVal5 0.00 $CalVal7 0.00 $CalVal9)
	sed -i "$LOC_Val s/.*/$LINHA_Val/" $(echo $ArqNome).pcr
}

function Parametro_2_9 (){ # Primeiro Parâmetro de 6
	LINHA_Val=$(echo $CalVal1 $(echo $PP) $CalVal3 $CalVal4 $CalVal5 $CalVal6 $CalVal7 $CalVal8 $CalVal9)
	sed -i "$LOC_Val s/.*/$LINHA_Val/" $(echo $ArqNome).pcr
}

function Parametro_4_9 (){ # Primeiro Parâmetro de 6
	LINHA_Val=$(echo $CalVal1 $CalVal2 $CalVal3 $(echo $PP) $CalVal5 $CalVal6 $CalVal7 $CalVal8 $CalVal9)
	sed -i "$LOC_Val s/.*/$LINHA_Val/" $(echo $ArqNome).pcr
}
function Parametro_6_9 (){ # Primeiro Parâmetro de 6
	LINHA_Val=$(echo $CalVal1 $CalVal2 $CalVal3 $CalVal4 $CalVal5 $(echo $PP) $CalVal7 $CalVal8 $CalVal9)
	sed -i "$LOC_Val s/.*/$LINHA_Val/" $(echo $ArqNome).pcr
}
function Parametro_8_9 (){ # Primeiro Parâmetro de 6
	LINHA_Val=$(echo $CalVal1 $CalVal2 $CalVal3 $CalVal4 $CalVal5 $CalVal6 $CalVal7 $(echo $PP) $CalVal9)
	sed -i "$LOC_Val s/.*/$LINHA_Val/" $(echo $ArqNome).pcr
}


