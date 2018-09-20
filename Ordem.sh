# --- Modo de Refinamento dos Parâmetros Térmicos e Ocupação --- #
# Quando igual a 0 (zero) é modo Manual, irá refinar testando varios valores e pegará o melhor. Igual a 1 (um) irá refinar normalmente.
# Quando igual a 1 corre um risco de dar valor inapropriado!! Se colocar valor diferente de 0 ou 1, será considerado como 0.
Quantidade=2 # Quantidade de vezes que ele irá refinar antes de passar para o próximo parametro.
Biso_Mode=0   
Ocup_Mode=0
Travar_UVW=0
Travar_Back=0

# --- Ordem do Refinamento Método Rietveld --- # Para NÃO refinar um determinado parâmetro basta por o # ANTES do parâmetro

ESCALA                       ### Refinar o Fator de Escala #
PARAMETROS_UVW               ### Refinar a Largura à Meia Altura dos Picos por Meio dos Parâmetros U, V e W #
paramZERO                    ### Refinar o Deslocamento do Zero da Escala 2θ #
paramBack                    ### Refinar o Background #
paramSyCos                   ### Refinar Cos #
paramSySin                   ### Refinar Sin #
PARAMETROS_REDE              ### Refinar os Parâmetros da Célula Unitária (a, b e c) #
PosicaoAtomica               ### Refinar as Posições Atômicas #
PARAMETRO_ASSIMETRIA         ### Refinar os Parâmetros de Assimetrias #
PARAMETRO_SHAPE              ### Refinar o Shape #
PARAMETROS_XY                ### Refinar o X e Y #
Strain_Model                 ### Refina Strain Model
PARAMETRO_GauSiz_LorSiz      ### Refina os parâmetros Gaussiano e Lorentziano
Size_Model                   ### Refina o Size Model 
Parametro_Ocupacao           ### Refinar os Parâmetros de Ocupação
Parametro_Termico            ### Refinar os Parâmetros Térmicos #

############ --- Refinando o que deram de Errado e Finalizando --- #
Finalizar_VEC=1

Exec_Erros
PARAMETROS_UVW            # Refinar novamente para ver se melhora!! 
paramBack            # Refinar novamente para ver se melhora!! 
Finalizando
